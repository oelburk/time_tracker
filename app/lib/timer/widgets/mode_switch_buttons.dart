import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_ui/app_ui.dart';
import 'package:time_tracking_repository/time_tracking_repository.dart';

import '../bloc/timer_bloc.dart';
import '../bloc/timer_event.dart';
import '../bloc/timer_state.dart';

class ModeSwitchButtons extends StatelessWidget {
  const ModeSwitchButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        final isRunning = state is TimerRunning;
        final currentMode = switch (state) {
          TimerRunning(:final mode) => mode,
          _ => null,
        };

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _ModeButton(
                    label: 'Coding',
                    icon: Icons.code,
                    color: AppColors.codingPrimary,
                    isActive: currentMode == TrackingMode.coding,
                    onPressed: () {
                      context.read<TimerBloc>().add(
                        const TimerStarted(mode: TrackingMode.coding),
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _ModeButton(
                    label: 'Meeting',
                    icon: Icons.groups,
                    color: AppColors.meetingPrimary,
                    isActive: currentMode == TrackingMode.meeting,
                    onPressed: () {
                      context.read<TimerBloc>().add(
                        const TimerStarted(mode: TrackingMode.meeting),
                      );
                    },
                  ),
                ),
              ],
            ),
            if (isRunning) ...[
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.read<TimerBloc>().add(const TimerStopped());
                  },
                  icon: const Icon(Icons.stop_rounded, size: 18),
                  label: const Text('Stop Tracking'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSpacing.buttonRadius,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isActive,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? color : color.withValues(alpha: 0.15),
          foregroundColor: isActive ? Colors.white : color,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
        ),
      ),
    );
  }
}
