import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class LaunchAtLoginSection extends StatelessWidget {
  const LaunchAtLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Platform.isMacOS) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (prev, curr) {
        if (prev is SettingsLoadSuccess && curr is SettingsLoadSuccess) {
          return prev.launchAtLogin != curr.launchAtLogin;
        }
        return true;
      },
      builder: (context, state) {
        final enabled = state is SettingsLoadSuccess
            ? state.launchAtLogin
            : false;
        final theme = Theme.of(context);
        final tertiary = theme.textTheme.labelSmall?.color;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LAUNCH ON STARTUP',
              style: AppTypography.labelSmall.copyWith(
                color: tertiary,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Open Time Tracker when you sign in to this Mac.',
              style: AppTypography.bodySmall.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                _ToggleChip(
                  label: 'OFF',
                  isSelected: !enabled,
                  onTap: () {
                    if (enabled) {
                      context.read<SettingsBloc>().add(
                        const SettingsLaunchAtLoginChanged(enabled: false),
                      );
                    }
                  },
                ),
                const SizedBox(width: AppSpacing.sm),
                _ToggleChip(
                  label: 'ON',
                  isSelected: enabled,
                  onTap: () {
                    if (!enabled) {
                      context.read<SettingsBloc>().add(
                        const SettingsLaunchAtLoginChanged(enabled: true),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.codingPrimary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            border: Border.all(
              color: isSelected
                  ? AppColors.codingPrimary.withValues(alpha: 0.3)
                  : theme.dividerColor,
              width: 0.5,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: isSelected
                    ? AppColors.codingPrimary
                    : theme.textTheme.bodySmall?.color,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
