import 'package:flutter/material.dart';

import '../typography.dart';
import 'app_card.dart';

/// Metric summary with label, value, and optional trend.
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

    Widget? trendRow;
    if (trend != null && trend!.isNotEmpty) {
      Color? trendColor;
      IconData? trendIcon;
      if (trendPositive != null) {
        trendColor = trendPositive!
            ? const Color(0xFF10B981)
            : const Color(0xFFEF4444);
        trendIcon = trendPositive!
            ? Icons.trending_up_rounded
            : Icons.trending_down_rounded;
      }

      trendRow = Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trendIcon != null)
              Icon(trendIcon, size: 16, color: trendColor ?? secondary),
            if (trendIcon != null) const SizedBox(width: 4),
            Text(
              trend!,
              style: AppTypography.bodySmall.copyWith(
                color: trendColor ?? secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.bodySmall.copyWith(color: secondary),
                ),
              ),
              if (icon != null) Icon(icon, size: 18, color: secondary),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTypography.headlineMedium.copyWith(
              color: theme.textTheme.headlineMedium?.color,
            ),
          ),
          ?trendRow,
        ],
      ),
    );
  }
}
