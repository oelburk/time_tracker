import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        children: [
          SizedBox(height: AppSpacing.lg),
          TimerDisplay(),
          SizedBox(height: AppSpacing.xxl),
          DailyTotals(),
          Spacer(),
          ModeSwitchButtons(),
          SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
