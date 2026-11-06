import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/zikir_provider.dart';
import '../models/zikir_log.dart';
import '../widgets/empty_state.dart';
import 'log_form_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ZikirProvider>();
    if (p.logs.isEmpty) {
      return const Scaffold(
        appBar: _HistoryAppBar(),
        body: EmptyState(title: 'No activity recorded',
          message: 'Your Zikir sessions will appear here after you record a completed count.',
          icon: Icons.history),
      );
    }
    final grouped = <String, List<ZikirLog>>{};
    for (final log in p.logs) {
      final key = DateFormat('yyyy-MM-dd').format(log.performedAt);
      grouped.putIfAbsent(key, () => []).add(log);
    }
    final keys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    return Scaffold(
      appBar: const _HistoryAppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          ...keys.map((key) {
            final entries = grouped[key]!;
            final total = entries.fold<int>(0, (s, l) => s + l.count);
            final date = DateTime.parse(key);
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(top: 18, bottom: 10),
                child: Row(children: [
                  Expanded(child: Text(DateFormat('EEEE, d MMM yyyy').format(date),
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14))),
                  Text('+${NumberFormat('#,###').format(total)}',
                    style: const TextStyle(color: Color(0xFF23866A), fontWeight: FontWeight.w800)),
                ]),
              ),
              Card(child: Column(children: entries.map((log) {
                final z = p.zikirById(log.zikirId);
                return ListTile(
                  leading: Container(
                    width: 42, height: 42,
                    decoration: const BoxDecoration(color: Color(0xFFE7F3EE), shape: BoxShape.circle),
                    child: const Icon(Icons.spa_outlined, color: Color(0xFF174B3B)),
                  ),
                  title: Text(z?.name ?? 'Deleted Zikir', style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('${DateFormat('hh:mm a').format(log.performedAt)}${log.note == null ? '' : ' • ${log.note}'}'),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text('+${NumberFormat('#,###').format(log.count)}',
                      style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF174B3B))),
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'edit' && z != null) {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (_) => LogFormScreen(zikir: z, log: log)));
                        } else if (value == 'delete') {
                          final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
                            title: const Text('Delete this entry?'),
                            content: const Text('This recorded activity will be removed.'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                            ],
                          ));
                          if (ok == true) await p.deleteLog(log.id!);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit entry')),
                        PopupMenuItem(value: 'delete', child: Text('Delete entry')),
                      ],
                    ),
                  ]),
                );
              }).toList())),
            ]);
          }),
        ],
      ),
    );
  }
}

class _HistoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HistoryAppBar();
  @override
  Widget build(BuildContext context) => AppBar(title: const Text('Activity history'));
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
