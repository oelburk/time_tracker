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
    return '${hours.toStringAsFixed(1)}h';
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: StatCard(
            label: 'Total',
            value: _formatHours(current.totalSeconds),
            trend: _calculateTrend(current.totalSeconds, previous.totalSeconds),
            trendPositive: current.totalSeconds >= previous.totalSeconds,
          ),
        ),
        Expanded(
          child: StatCard(
            label: 'Avg/day',
            value: _formatDuration(avgDaily),
            trend: _calculateTrend(avgDaily, prevAvgDaily),
            trendPositive: avgDaily >= prevAvgDaily,
          ),
        ),
        Expanded(
          child: StatCard(
            label: 'Longest',
            value: _formatDuration(current.longestSessionSeconds),
          ),
        ),
        Expanded(
          child: StatCard(
            label: 'Code %',
            value: '${(current.codingRatio * 100).round()}%',
          ),
        ),
      ],
    );
  }
}
