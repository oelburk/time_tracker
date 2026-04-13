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
    final dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final sortedDays = summary.dailyBreakdown.keys.toList()..sort();
    final Map<int, DailySummary> weekdayData = {};
    for (final day in sortedDays) {
      weekdayData[day.weekday] = summary.dailyBreakdown[day]!;
    }

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Time Distribution',
            style: AppTypography.titleMedium.copyWith(
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Row(
            children: [
              _LegendDot(color: AppColors.codingPrimary, label: 'Coding'),
              SizedBox(width: AppSpacing.lg),
              _LegendDot(color: AppColors.meetingPrimary, label: 'Meeting'),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 200,
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
                        AppTypography.bodySmall.copyWith(color: Colors.white),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}h',
                        style: AppTypography.bodySmall.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          dayLabels[value.toInt()],
                          style: AppTypography.bodySmall.copyWith(
                            color: theme.textTheme.bodySmall?.color,
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
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: theme.dividerColor, strokeWidth: 0.5),
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
                        width: 20,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
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
      ),
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
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }
}
