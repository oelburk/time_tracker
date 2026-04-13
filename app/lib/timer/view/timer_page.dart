import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TimerDisplay(),
          SizedBox(height: AppSpacing.xl),
          ModeSwitchButtons(),
        ],
      ),
    );
  }
}
