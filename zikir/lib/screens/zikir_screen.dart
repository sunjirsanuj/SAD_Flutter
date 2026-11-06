
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/zikir_provider.dart';
import '../models/zikir.dart';
import '../widgets/empty_state.dart';
import 'zikir_form_screen.dart';
import 'log_form_screen.dart';

class ZikirScreen extends StatelessWidget {
  const ZikirScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ZikirProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Zikir goals'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ZikirFormScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF174B3B),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Zikir'),
      ),
      body: p.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : p.activeZikirs.isEmpty
              ? const EmptyState(
                  title: 'No Zikir goals yet',
                  message: 'Tap Add Zikir to create your first goal.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                  itemCount: p.activeZikirs.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _ZikirTile(
                      zikir: p.activeZikirs[index],
                    );
                  },
                ),
    );
  }
}

class _ZikirTile extends StatelessWidget {
  final Zikir zikir;

  const _ZikirTile({required this.zikir});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ZikirProvider>();

    final done = p.totalForZikir(zikir.id!);
    final ratio = (done / zikir.target).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    zikir.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ZikirFormScreen(zikir: zikir),
                        ),
                      );
                    } else if (value == 'delete') {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete this Zikir?'),
                          content: const Text(
                            'Its recorded history will also be deleted. '
                            'This cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(ctx, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(ctx, true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (ok == true) {
                        await p.deleteZikir(zikir.id!);
                      }
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete permanently'),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: Text(
                    '${NumberFormat('#,###').format(done)} / '
                    '${NumberFormat('#,###').format(zikir.target)} completed',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Text(
                  '${(ratio * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF23866A),
                  ),
                ),
              ],
            ),

            if (zikir.dailyTarget != null) ...[
              const SizedBox(height: 5),
              Text(
                'Today: ${p.todayForZikir(zikir.id!)} / '
                '${zikir.dailyTarget}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LogFormScreen(zikir: zikir),
                    ),
                  );
                },
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Record count'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
