import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                    label: 'CODE',
                    color: AppColors.codingPrimary,
                    mutedColor: AppColors.codingMuted,
                    isActive: currentMode == TrackingMode.coding,
                    onPressed: () {
                      context.read<TimerBloc>().add(
                        const TimerStarted(mode: TrackingMode.coding),
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _ModeButton(
                    label: 'MEET',
                    color: AppColors.meetingPrimary,
                    mutedColor: AppColors.meetingMuted,
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
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              alignment: Alignment.topCenter,
              child: isRunning
                  ? Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              context.read<TimerBloc>().add(
                                const TimerStopped(),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.error.withValues(
                                alpha: 0.8,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                              ),
                            ),
                            child: Text(
                              'STOP',
                              style: AppTypography.labelLarge.copyWith(
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}

class _ModeButton extends StatefulWidget {
  const _ModeButton({
    required this.label,
    required this.color,
    required this.mutedColor,
    required this.isActive,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final Color mutedColor;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  State<_ModeButton> createState() => _ModeButtonState();
}

class _ModeButtonState extends State<_ModeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _scaleController.forward();

  void _onTapUp(TapUpDetails _) {
    _scaleController.reverse();
    widget.onPressed();
  }

  void _onTapCancel() => _scaleController.reverse();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: widget.isActive ? widget.mutedColor : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            border: Border.all(
              color: widget.isActive
                  ? widget.color.withValues(alpha: 0.4)
                  : theme.dividerColor,
              width: 0.5,
            ),
          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              style: AppTypography.labelLarge.copyWith(
                color: widget.isActive
                    ? widget.color
                    : theme.textTheme.bodySmall?.color,
                letterSpacing: 2,
              ),
              child: Text(widget.label),
            ),
          ),
        ),
      ),
    );
  }
}
