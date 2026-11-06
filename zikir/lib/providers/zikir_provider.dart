import 'package:flutter/foundation.dart';
import '../data/database_helper.dart';
import '../models/zikir.dart';
import '../models/zikir_log.dart';

class ZikirProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;

  List<Zikir> _zikirs = [];
  List<ZikirLog> _logs = [];

  bool _isLoading = true;

  List<Zikir> get zikirs => List.unmodifiable(_zikirs);
  List<ZikirLog> get logs => List.unmodifiable(_logs);
  bool get isLoading => _isLoading;

  List<Zikir> get activeZikirs => _zikirs.where((z) => z.isActive).toList();

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    try {
      final zRows = await _db.getZikirs();
      final lRows = await _db.getLogs();

      _zikirs = zRows.map(Zikir.fromMap).toList();
      _logs = lRows.map(ZikirLog.fromMap).toList();
    } catch (e, stackTrace) {
      debugPrint('Load error: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addZikir(Zikir zikir) async {
    try {
      final id = await _db.insertZikir(
        zikir.toMap()..remove('id'),
      );

      debugPrint('Zikir created successfully. ID: $id');

      await load();
    } catch (e, stackTrace) {
      debugPrint('Add Zikir error: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> updateZikir(Zikir zikir) async {
    try {
      await _db.updateZikir(
        zikir.id!,
        zikir.toMap()..remove('id'),
      );

      await load();
    } catch (e, stackTrace) {
      debugPrint('Update Zikir error: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> deleteZikir(int id) async {
    await _db.deleteZikir(id);
    await load();
  }

  Future<void> addLog(ZikirLog log) async {
    await _db.insertLog(log.toMap()..remove('id'));
    await load();
  }

  Future<void> updateLog(ZikirLog log) async {
    await _db.updateLog(
      log.id!,
      log.toMap()..remove('id'),
    );

    await load();
  }

  Future<void> deleteLog(int id) async {
    await _db.deleteLog(id);
    await load();
  }

  int totalForZikir(int zikirId) => _logs
      .where((l) => l.zikirId == zikirId)
      .fold(0, (sum, l) => sum + l.count);

  int todayForZikir(int zikirId) {
    final now = DateTime.now();

    return _logs
        .where((l) =>
            l.zikirId == zikirId &&
            l.performedAt.year == now.year &&
            l.performedAt.month == now.month &&
            l.performedAt.day == now.day)
        .fold(0, (sum, l) => sum + l.count);
  }

  int get todayTotal {
    final now = DateTime.now();

    return _logs
        .where((l) =>
            l.performedAt.year == now.year &&
            l.performedAt.month == now.month &&
            l.performedAt.day == now.day)
        .fold(0, (sum, l) => sum + l.count);
  }

  int get allTimeTotal => _logs.fold(0, (sum, l) => sum + l.count);

  int get completedGoals =>
      _zikirs.where((z) => totalForZikir(z.id!) >= z.target).length;

  List<int> dailyTotals({int days = 7}) {
    final today = DateTime.now();

    return List.generate(days, (index) {
      final day = DateTime(today.year, today.month, today.day)
          .subtract(Duration(days: days - 1 - index));

      return _logs
          .where((l) =>
              l.performedAt.year == day.year &&
              l.performedAt.month == day.month &&
              l.performedAt.day == day.day)
          .fold(0, (sum, l) => sum + l.count);
    });
  }

  int monthlyTotal(int year, int month) => _logs
      .where((l) => l.performedAt.year == year && l.performedAt.month == month)
      .fold(0, (sum, l) => sum + l.count);

  Zikir? zikirById(int id) {
    for (final z in _zikirs) {
      if (z.id == id) return z;
    }

    return null;
  }
}
