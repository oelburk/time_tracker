import 'package:app_ui/app_ui.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:time_tracking_repository/time_tracking_repository.dart';

class WeeklyChart extends StatelessWidget {
  const WeeklyChart({super.key, required this.summary});
  final TimeSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final tertiary = theme.textTheme.labelSmall?.color;

    final sortedDays = summary.dailyBreakdown.keys.toList()..sort();
    final Map<int, DailySummary> weekdayData = {};
    for (final day in sortedDays) {
      weekdayData[day.weekday] = summary.dailyBreakdown[day]!;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'DISTRIBUTION',
              style: AppTypography.labelSmall.copyWith(
                color: tertiary,
                letterSpacing: 1.5,
              ),
            ),
            const Spacer(),
            const _LegendDot(color: AppColors.codingPrimary, label: 'code'),
            const SizedBox(width: AppSpacing.md),
            const _LegendDot(color: AppColors.meetingPrimary, label: 'meet'),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _getMaxY(weekdayData),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final hours = rod.toY.toStringAsFixed(1);
                    return BarTooltipItem(
                      '${hours}h',
                      AppTypography.monoSmall.copyWith(
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) => Text(
                      '${value.toInt()}',
                      style: AppTypography.monoSmall.copyWith(
                        color: tertiary,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        dayLabels[value.toInt()],
                        style: AppTypography.monoSmall.copyWith(
                          color: tertiary,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 2,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: theme.dividerColor.withValues(alpha: 0.5),
                  strokeWidth: 0.5,
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(7, (index) {
                final weekday = index + 1;
                final data = weekdayData[weekday];
                final codingHours = (data?.codingSeconds ?? 0) / 3600;
                final meetingHours = (data?.meetingSeconds ?? 0) / 3600;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: codingHours + meetingHours,
                      width: 16,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(2),
                      ),
                      rodStackItems: [
                        BarChartRodStackItem(
                          0,
                          codingHours,
                          AppColors.codingPrimary,
                        ),
                        BarChartRodStackItem(
                          codingHours,
                          codingHours + meetingHours,
                          AppColors.meetingPrimary,
                        ),
                      ],
                      color: Colors.transparent,
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  double _getMaxY(Map<int, DailySummary> data) {
    double max = 4;
    for (final d in data.values) {
      final total = d.totalSeconds / 3600;
      if (total > max) max = total;
    }
    return (max * 1.2).ceilToDouble();
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.monoSmall.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}
