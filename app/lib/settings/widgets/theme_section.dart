import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/bloc/theme_cubit.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class ThemeSection extends StatelessWidget {
  const ThemeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (prev, curr) {
        if (prev is SettingsLoadSuccess && curr is SettingsLoadSuccess) {
          return prev.themeMode != curr.themeMode;
        }
        return true;
      },
      builder: (context, state) {
        final themeMode = state is SettingsLoadSuccess
            ? state.themeMode
            : 'system';
        return _Section(
          label: 'APPEARANCE',
          child: Row(
            children: [
              _ThemeOption(label: 'Light', value: 'light', current: themeMode),
              const SizedBox(width: AppSpacing.sm),
              _ThemeOption(label: 'Dark', value: 'dark', current: themeMode),
              const SizedBox(width: AppSpacing.sm),
              _ThemeOption(
                label: 'System',
                value: 'system',
                current: themeMode,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.value,
    required this.current,
  });

  final String label;
  final String value;
  final String current;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == current;
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<SettingsBloc>().add(
            SettingsThemeChanged(themeMode: value),
          );
          context.read<ThemeCubit>().setThemeMode(value);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
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
              label.toUpperCase(),
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

class _Section extends StatelessWidget {
  const _Section({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tertiary = Theme.of(context).textTheme.labelSmall?.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: tertiary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        child,
      ],
    );
  }
}
