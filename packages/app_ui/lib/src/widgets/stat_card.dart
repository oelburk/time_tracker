import 'package:flutter/material.dart';

import '../colors.dart';
import '../spacing.dart';
import '../typography.dart';

/// Dense stat readout: label above, monospace value below, optional trend.
/// No card wrapper — caller provides the container if needed.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.trend,
    this.trendPositive,
    this.icon,
  });

  final String label;
  final String value;
  final String? trend;
  final bool? trendPositive;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondary = theme.textTheme.bodySmall?.color;
    final tertiary = theme.textTheme.labelSmall?.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.labelSmall.copyWith(
            color: tertiary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTypography.monoMedium.copyWith(
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        if (trend != null && trend!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            trend!,
            style: AppTypography.monoSmall.copyWith(
              color: trendPositive == null
                  ? secondary
                  : trendPositive!
                  ? AppColors.positive
                  : AppColors.negative,
            ),
          ),
        ],
      ],
    );
  }
}
