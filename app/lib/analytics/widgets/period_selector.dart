import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class PeriodSelector extends StatelessWidget {
  const PeriodSelector({
    super.key,
    required this.isWeekly,
    required this.periodLabel,
    required this.onPrevious,
    required this.onNext,
    required this.onTabChanged,
  });

  final bool isWeekly;
  final String periodLabel;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final ValueChanged<bool> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _TabButton(
              label: 'Weekly',
              isActive: isWeekly,
              onTap: () => onTabChanged(true),
            ),
            const SizedBox(width: AppSpacing.sm),
            _TabButton(
              label: 'Monthly',
              isActive: !isWeekly,
              onTap: () => onTabChanged(false),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: onPrevious,
              icon: const Icon(Icons.chevron_left),
              iconSize: 20,
            ),
            Text(
              periodLabel,
              style: AppTypography.titleMedium.copyWith(
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            IconButton(
              onPressed: onNext,
              icon: const Icon(Icons.chevron_right),
              iconSize: 20,
            ),
          ],
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.codingPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
          border: Border.all(
            color: isActive
                ? AppColors.codingPrimary
                : Theme.of(context).dividerColor,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelLarge.copyWith(
            color: isActive
                ? Colors.white
                : Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ),
    );
  }
}
