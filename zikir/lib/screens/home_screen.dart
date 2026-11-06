import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zikir_tracker/providers/auth_provider.dart';
import '../providers/zikir_provider.dart';
import '../models/zikir.dart';
import '../widgets/section_title.dart';
import '../widgets/empty_state.dart';
import 'log_form_screen.dart';
import 'zikir_form_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onViewAll;
  const HomeScreen({super.key, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ZikirProvider>();
    final auth = context.watch<AuthProvider>();
    final today = DateFormat('EEEE, d MMMM').format(DateTime.now());
    return RefreshIndicator(
      onRefresh: p.load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
        children: [
          Text(today, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          Text('Assalamu Alaikum, ${auth.studentId}' , style: const TextStyle(
            fontSize: 27, fontWeight: FontWeight.w900, color: Color(0xFF1D2924),
          )),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF174B3B), Color(0xFF28785D)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Expanded(child: Text('YOUR ZIKIR JOURNEY',
                  style: TextStyle(color: Colors.white70, fontSize: 11,
                    letterSpacing: 1.5, fontWeight: FontWeight.w800))),
                Icon(Icons.auto_awesome, color: Colors.white.withOpacity(.8)),
              ]),
              const SizedBox(height: 12),
              Text(NumberFormat('#,###').format(p.todayTotal),
                style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900)),
              const Text('Total recorded today', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 20),
              Row(children: [
                _HeroStat(value: '${p.activeZikirs.length}', label: 'Active goals'),
                const SizedBox(width: 26),
                _HeroStat(value: NumberFormat.compact().format(p.allTimeTotal), label: 'All-time total'),
                const SizedBox(width: 26),
                _HeroStat(value: '${p.completedGoals}', label: 'Goals reached'),
              ]),
            ]),
          ),
          const SizedBox(height: 26),
          SectionTitle('Your Zikir goals', action: 'See all', onAction: onViewAll),
          const SizedBox(height: 12),
          if (p.isLoading)
            const Center(child: Padding(
              padding: EdgeInsets.all(30), child: CircularProgressIndicator(),
            ))
          else if (p.activeZikirs.isEmpty)
            Card(child: EmptyState(
              title: 'Start your Zikir journey',
              message: 'Add your first Zikir goal, then record completed counts whenever you finish.',
            ))
          else
            ...p.activeZikirs.take(4).map((z) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _GoalCard(zikir: z),
            )),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ZikirFormScreen())),
            icon: const Icon(Icons.add),
            label: const Text('Add a new Zikir goal'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF174B3B),
              padding: const EdgeInsets.symmetric(vertical: 15),
              side: const BorderSide(color: Color(0xFFB8D4C7)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String value, label;
  const _HeroStat({required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Expanded(child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(value, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800)),
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
    ],
  ));
}

class _GoalCard extends StatelessWidget {
  final Zikir zikir;
  const _GoalCard({required this.zikir});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ZikirProvider>();
    final done = p.totalForZikir(zikir.id!);
    final today = p.todayForZikir(zikir.id!);
    final ratio = (done / zikir.target).clamp(0.0, 1.0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(zikir.name, style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1D2924),
            ))),
            Text('${(ratio * 100).toStringAsFixed(0)}%',
              style: const TextStyle(color: Color(0xFF23866A), fontWeight: FontWeight.w800)),
          ]),
          const SizedBox(height: 12),
          ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(
            value: ratio, minHeight: 8, backgroundColor: const Color(0xFFE9EFEB),
            color: const Color(0xFF23866A),
          )),
          const SizedBox(height: 9),
          Row(children: [
            Expanded(child: Text('${NumberFormat('#,###').format(done)} / ${NumberFormat('#,###').format(zikir.target)}',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
            if (zikir.dailyTarget != null)
              Text('Today $today / ${zikir.dailyTarget}',
                style: const TextStyle(color: Colors.black54, fontSize: 11)),
          ]),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: FilledButton.tonalIcon(
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => LogFormScreen(zikir: zikir))),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Record completed count'),
            style: FilledButton.styleFrom(
              foregroundColor: const Color(0xFF174B3B),
              backgroundColor: const Color(0xFFE7F3EE),
            ),
          )),
        ]),
      ),
    );
  }
}
