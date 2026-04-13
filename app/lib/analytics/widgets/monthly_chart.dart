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
    final tertiary = theme.textTheme.labelSmall?.color;

    final codingHours = summary.totalCodingSeconds / 3600;
    final meetingHours = summary.totalMeetingSeconds / 3600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BREAKDOWN',
          style: AppTypography.labelSmall.copyWith(
            color: tertiary,
            letterSpacing: 1.5,
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
                    sectionsSpace: 1,
                    centerSpaceRadius: 36,
                    sections: [
                      PieChartSectionData(
                        value: summary.totalCodingSeconds.toDouble(),
                        color: AppColors.codingPrimary,
                        title: '${(summary.codingRatio * 100).round()}%',
                        titleStyle: AppTypography.monoSmall.copyWith(
                          color: AppColors.darkTextPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        radius: 40,
                      ),
                      PieChartSectionData(
                        value: summary.totalMeetingSeconds.toDouble(),
                        color: AppColors.meetingPrimary,
                        title:
                            '${((1 - summary.codingRatio) * 100).round()}%',
                        titleStyle: AppTypography.monoSmall.copyWith(
                          color: AppColors.darkBackground,
                          fontWeight: FontWeight.w600,
                        ),
                        radius: 40,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xl),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LegendRow(
                    color: AppColors.codingPrimary,
                    label: 'code',
                    value: '${codingHours.toStringAsFixed(1)}h',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _LegendRow(
                    color: AppColors.meetingPrimary,
                    label: 'meet',
                    value: '${meetingHours.toStringAsFixed(1)}h',
                  ),
                ],
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
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: AppTypography.monoSmall.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          value,
          style: AppTypography.monoSmall.copyWith(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
