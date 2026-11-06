
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    late String dbPath;

    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
      dbPath = 'zikir_tracker_web.db';
    } else {
      final path = await getDatabasesPath();
      dbPath = p.join(path, 'zikir_tracker.db');
    }

    _database = await openDatabase(
      dbPath,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE zikirs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            target INTEGER NOT NULL,
            daily_target INTEGER,
            note TEXT,
            created_at TEXT NOT NULL,
            is_active INTEGER NOT NULL DEFAULT 1
          )
        ''');

        await db.execute('''
          CREATE TABLE zikir_logs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            zikir_id INTEGER NOT NULL,
            count INTEGER NOT NULL,
            performed_at TEXT NOT NULL,
            note TEXT,
            FOREIGN KEY (zikir_id)
              REFERENCES zikirs (id) ON DELETE CASCADE
          )
        ''');

        await db.execute(
          'CREATE INDEX idx_logs_zikir_date '
          'ON zikir_logs(zikir_id, performed_at)',
        );

        await db.execute(
          'CREATE INDEX idx_logs_date ON zikir_logs(performed_at)',
        );
      },
    );

    return _database!;
  }

  Future<int> insertZikir(Map<String, Object?> values) async =>
      (await database).insert('zikirs', values);

  Future<int> updateZikir(
    int id,
    Map<String, Object?> values,
  ) async =>
      (await database).update(
        'zikirs',
        values,
        where: 'id = ?',
        whereArgs: [id],
      );

  Future<int> deleteZikir(int id) async =>
      (await database).delete(
        'zikirs',
        where: 'id = ?',
        whereArgs: [id],
      );

  Future<List<Map<String, Object?>>> getZikirs() async =>
      (await database).query(
        'zikirs',
        orderBy: 'is_active DESC, created_at DESC',
      );

  Future<int> insertLog(Map<String, Object?> values) async =>
      (await database).insert('zikir_logs', values);

  Future<int> updateLog(
    int id,
    Map<String, Object?> values,
  ) async =>
      (await database).update(
        'zikir_logs',
        values,
        where: 'id = ?',
        whereArgs: [id],
      );

  Future<int> deleteLog(int id) async =>
      (await database).delete(
        'zikir_logs',
        where: 'id = ?',
        whereArgs: [id],
      );

  Future<List<Map<String, Object?>>> getLogs() async =>
      (await database).query(
        'zikir_logs',
        orderBy: 'performed_at DESC',
      );

  Future<List<Map<String, Object?>>> getLogsForZikir(
    int zikirId,
  ) async =>
      (await database).query(
        'zikir_logs',
        where: 'zikir_id = ?',
        whereArgs: [zikirId],
        orderBy: 'performed_at DESC',
      );
}
