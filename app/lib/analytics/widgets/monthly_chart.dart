import 'package:app_ui/app_ui.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:time_tracking_repository/time_tracking_repository.dart';

class MonthlyChart extends StatelessWidget {
  const MonthlyChart({super.key, required this.summary});
  final TimeSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Coding vs Meeting',
                style: AppTypography.titleMedium.copyWith(
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                height: 180,
                child: Row(
                  children: [
                    Expanded(
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: [
                            PieChartSectionData(
                              value: summary.totalCodingSeconds.toDouble(),
                              color: AppColors.codingPrimary,
                              title: '${(summary.codingRatio * 100).round()}%',
                              titleStyle: AppTypography.labelLarge.copyWith(
                                color: Colors.white,
                              ),
                              radius: 45,
                            ),
                            PieChartSectionData(
                              value: summary.totalMeetingSeconds.toDouble(),
                              color: AppColors.meetingPrimary,
                              title:
                                  '${((1 - summary.codingRatio) * 100).round()}%',
                              titleStyle: AppTypography.labelLarge.copyWith(
                                color: Colors.white,
                              ),
                              radius: 45,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _LegendRow(
                          color: AppColors.codingPrimary,
                          label: 'Coding',
                          value:
                              '${(summary.totalCodingSeconds / 3600).toStringAsFixed(1)}h',
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _LegendRow(
                          color: AppColors.meetingPrimary,
                          label: 'Meeting',
                          value:
                              '${(summary.totalMeetingSeconds / 3600).toStringAsFixed(1)}h',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          value,
          style: AppTypography.labelLarge.copyWith(
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }
}
