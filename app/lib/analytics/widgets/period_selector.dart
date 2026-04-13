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

    return Row(
      children: [
        _TabButton(
          label: 'WEEK',
          isActive: isWeekly,
          onTap: () => onTabChanged(true),
        ),
        const SizedBox(width: 1),
        _TabButton(
          label: 'MONTH',
          isActive: !isWeekly,
          onTap: () => onTabChanged(false),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onPrevious,
          child: Icon(
            Icons.chevron_left,
            size: 16,
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
        SizedBox(
          width: 140,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: Text(
              periodLabel,
              key: ValueKey(periodLabel),
              textAlign: TextAlign.center,
              style: AppTypography.monoSmall.copyWith(
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: onNext,
          child: Icon(
            Icons.chevron_right,
            size: 16,
            color: theme.textTheme.bodySmall?.color,
          ),
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
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.codingPrimary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
          border: Border.all(
            color: isActive
                ? AppColors.codingPrimary.withValues(alpha: 0.3)
                : theme.dividerColor,
            width: 0.5,
          ),
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          style: AppTypography.labelSmall.copyWith(
            color: isActive
                ? AppColors.codingPrimary
                : theme.textTheme.bodySmall?.color,
            letterSpacing: 1.2,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
