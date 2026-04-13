import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_ui/app_ui.dart';

import '../bloc/timer_bloc.dart';
import '../bloc/timer_state.dart';

class TimerDisplay extends StatelessWidget {
  const TimerDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        final (isRunning, elapsed, mode, modeKey) = switch (state) {
          TimerRunning(:final mode, :final elapsed) => (
            true,
            elapsed,
            mode.label,
            mode.name,
          ),
          _ => (false, Duration.zero, 'Idle', 'idle'),
        };

        final hours = elapsed.inHours.toString().padLeft(2, '0');
        final minutes = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
        final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');

        return AppCard(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            children: [
              ModeIndicator(mode: modeKey, isActive: isRunning),
              const SizedBox(height: AppSpacing.lg),
              Text(
                '$hours:$minutes:$seconds',
                style: AppTypography.monoLarge.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                mode,
                style: AppTypography.labelLarge.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
