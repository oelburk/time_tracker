import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_ui/app_ui.dart';
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
        return AppCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Appearance',
                style: AppTypography.titleMedium.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  _ThemeOption(
                    label: 'Light',
                    icon: Icons.light_mode,
                    value: 'light',
                    current: themeMode,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _ThemeOption(
                    label: 'Dark',
                    icon: Icons.dark_mode,
                    value: 'dark',
                    current: themeMode,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _ThemeOption(
                    label: 'System',
                    icon: Icons.settings_brightness,
                    value: 'system',
                    current: themeMode,
                  ),
                ],
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
    required this.icon,
    required this.value,
    required this.current,
  });

  final String label;
  final IconData icon;
  final String value;
  final String current;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == current;
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
                ? AppColors.codingPrimary.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            border: Border.all(
              color: isSelected
                  ? AppColors.codingPrimary
                  : Theme.of(context).dividerColor,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? AppColors.codingPrimary
                    : Theme.of(context).iconTheme.color,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  color: isSelected
                      ? AppColors.codingPrimary
                      : Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
