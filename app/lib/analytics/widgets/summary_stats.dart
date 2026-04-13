import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:time_tracking_repository/time_tracking_repository.dart';

class SummaryStats extends StatelessWidget {
  const SummaryStats({
    super.key,
    required this.current,
    required this.previous,
  });

  final TimeSummary current;
  final TimeSummary previous;

  String _formatHours(int seconds) {
    final hours = seconds / 3600;
    return hours.toStringAsFixed(1);
  }

  String _formatDuration(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }

  String? _calculateTrend(int currentVal, int previousVal) {
    if (previousVal == 0) return null;
    final change = ((currentVal - previousVal) / previousVal * 100).round();
    if (change == 0) return null;
    return '${change > 0 ? '+' : ''}$change%';
  }

  @override
  Widget build(BuildContext context) {
    final dailyCount = current.dailyBreakdown.length;
    final avgDaily = dailyCount > 0 ? current.totalSeconds ~/ dailyCount : 0;
    final prevDailyCount = previous.dailyBreakdown.length;
    final prevAvgDaily = prevDailyCount > 0
        ? previous.totalSeconds ~/ prevDailyCount
        : 0;

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        SizedBox(
          width: 170,
          child: StatCard(
            label: 'Total Hours',
            value: _formatHours(current.totalSeconds),
            icon: Icons.schedule,
            trend: _calculateTrend(current.totalSeconds, previous.totalSeconds),
            trendPositive: current.totalSeconds >= previous.totalSeconds,
          ),
        ),
        SizedBox(
          width: 170,
          child: StatCard(
            label: 'Daily Average',
            value: _formatDuration(avgDaily),
            icon: Icons.bar_chart,
            trend: _calculateTrend(avgDaily, prevAvgDaily),
            trendPositive: avgDaily >= prevAvgDaily,
          ),
        ),
        SizedBox(
          width: 170,
          child: StatCard(
            label: 'Longest Session',
            value: _formatDuration(current.longestSessionSeconds),
            icon: Icons.emoji_events,
          ),
        ),
        SizedBox(
          width: 170,
          child: StatCard(
            label: 'Coding Ratio',
            value: '${(current.codingRatio * 100).round()}%',
            icon: Icons.code,
          ),
        ),
      ],
    );
  }
}
