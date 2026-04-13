import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ThemeSection(),
          SizedBox(height: AppSpacing.xxl),
          LaunchAtLoginSection(),
          SizedBox(height: AppSpacing.xxl),
          WorkingHoursSection(),
          SizedBox(height: AppSpacing.xxl),
          HotkeySection(),
          SizedBox(height: AppSpacing.xxl),
          ExportSection(),
          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
