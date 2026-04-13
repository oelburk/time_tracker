import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import '../widgets/widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: AppTypography.headlineMedium.copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const ThemeSection(),
          const SizedBox(height: AppSpacing.lg),
          const WorkingHoursSection(),
          const SizedBox(height: AppSpacing.lg),
          const HotkeySection(),
          const SizedBox(height: AppSpacing.lg),
          const ExportSection(),
        ],
      ),
    );
  }
}
