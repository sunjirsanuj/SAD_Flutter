import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/zikir_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ZikirProvider>();
    final week = p.dailyTotals(days: 7);
    final maxY = (week.fold<int>(0, (a, b) => a > b ? a : b) * 1.25).toDouble();
    final safeMax = maxY < 5 ? 5.0 : maxY;
    final now = DateTime.now();
    final monthTotal = p.monthlyTotal(now.year, now.month);
    final lastMonthDate = DateTime(now.year, now.month - 1);
    final lastMonthTotal = p.monthlyTotal(lastMonthDate.year, lastMonthDate.month);
    final difference = monthTotal - lastMonthTotal;

    return Scaffold(
      appBar: AppBar(title: const Text('Your progress')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        children: [
          Row(children: [
            Expanded(child: _MetricCard(
              title: 'All-time total',
              value: NumberFormat.compact().format(p.allTimeTotal),
              icon: Icons.auto_awesome,
            )),
            const SizedBox(width: 12),
            Expanded(child: _MetricCard(
              title: 'This month',
              value: NumberFormat.compact().format(monthTotal),
              icon: Icons.calendar_month_outlined,
            )),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _MetricCard(
              title: 'Today',
              value: NumberFormat.compact().format(p.todayTotal),
              icon: Icons.today_outlined,
            )),
            const SizedBox(width: 12),
            Expanded(child: _MetricCard(
              title: 'Goals reached',
              value: '${p.completedGoals}',
              icon: Icons.flag_outlined,
            )),
          ]),
          const SizedBox(height: 25),
          const Text('Last 7 days', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          const Text('Total Zikir recorded each day', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 22, 18, 14),
              child: SizedBox(
                height: 210,
                child: BarChart(BarChartData(
                  maxY: safeMax,
                  minY: 0,
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(color: const Color(0xFFE9EFEB), strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(sideTitles: SideTitles(
                      showTitles: true, reservedSize: 38,
                      getTitlesWidget: (value, meta) => Text(
                        NumberFormat.compact().format(value),
                        style: const TextStyle(fontSize: 9, color: Colors.black45),
                      ),
                    )),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index > 6) return const SizedBox.shrink();
                        final day = DateTime.now().subtract(Duration(days: 6 - index));
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(DateFormat('E').format(day),
                            style: const TextStyle(fontSize: 10, color: Colors.black54)),
                        );
                      },
                    )),
                  ),
                  barGroups: List.generate(7, (i) => BarChartGroupData(
                    x: i,
                    barRods: [BarChartRodData(
                      toY: week[i].toDouble(),
                      width: 17,
                      borderRadius: BorderRadius.circular(6),
                      color: const Color(0xFF23866A),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true, toY: safeMax, color: const Color(0xFFF0F4F1),
                      ),
                    )],
                  )),
                )),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Monthly comparison', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Card(child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(children: [
              _MonthRow(
                label: DateFormat('MMMM yyyy').format(lastMonthDate),
                value: lastMonthTotal,
              ),
              const Divider(height: 24),
              _MonthRow(
                label: DateFormat('MMMM yyyy').format(now),
                value: monthTotal,
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F3EE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  difference > 0
                    ? 'You recorded ${NumberFormat('#,###').format(difference)} more this month.'
                    : difference < 0
                      ? 'You recorded ${NumberFormat('#,###').format(difference.abs())} fewer than last month.'
                      : 'Your recorded total matches last month.',
                  style: const TextStyle(color: Color(0xFF174B3B), fontWeight: FontWeight.w700),
                ),
              ),
            ]),
          )),
          const SizedBox(height: 20),
          const Text('Zikir breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          if (p.activeZikirs.isEmpty)
            const Text('Add a Zikir goal to see its breakdown.', style: TextStyle(color: Colors.black54))
          else
            ...p.activeZikirs.map((z) {
              final total = p.totalForZikir(z.id!);
              final percent = (total / z.target).clamp(0.0, 1.0);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(z.name, style: const TextStyle(fontWeight: FontWeight.w700))),
                      Text('${(percent * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(color: Color(0xFF23866A), fontWeight: FontWeight.w800)),
                    ]),
                    const SizedBox(height: 9),
                    LinearProgressIndicator(value: percent, minHeight: 7, borderRadius: BorderRadius.circular(8)),
                    const SizedBox(height: 6),
                    Text('${NumberFormat('#,###').format(total)} / ${NumberFormat('#,###').format(z.target)}',
                      style: const TextStyle(color: Colors.black54, fontSize: 12)),
                  ]),
                )),
              );
            }),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  const _MetricCard({required this.title, required this.value, required this.icon});
  @override
  Widget build(BuildContext context) => Card(child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: const Color(0xFF23866A)),
      const SizedBox(height: 12),
      Text(value, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
      Text(title, style: const TextStyle(color: Colors.black54, fontSize: 11)),
    ]),
  ));
}

class _MonthRow extends StatelessWidget {
  final String label;
  final int value;
  const _MonthRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Row(children: [
    Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
    Text(NumberFormat('#,###').format(value),
      style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF174B3B))),
  ]);
}
