import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/timer_bloc.dart';
import '../bloc/timer_state.dart';

class TimerDisplay extends StatefulWidget {
  const TimerDisplay({super.key});

  @override
  State<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<TimerDisplay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _syncGlow(bool isRunning) {
    if (isRunning && !_glowController.isAnimating) {
      _glowController.repeat(reverse: true);
    } else if (!isRunning && _glowController.isAnimating) {
      _glowController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        final (isRunning, elapsed, modeKey) = switch (state) {
          TimerRunning(:final mode, :final elapsed) => (
            true,
            elapsed,
            mode.name,
          ),
          _ => (false, Duration.zero, 'idle'),
        };

        final hours = elapsed.inHours.toString().padLeft(2, '0');
        final minutes = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
        final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');

        final theme = Theme.of(context);
        final clockColor = switch (modeKey) {
          'coding' => AppColors.codingPrimary,
          'meeting' => AppColors.meetingPrimary,
          _ => theme.textTheme.bodySmall?.color ?? AppColors.idle,
        };

        _syncGlow(isRunning);

        final clockText = _FixedWidthClock(
          hours: hours,
          minutes: minutes,
          seconds: seconds,
          color: clockColor,
        );

        return Column(
          children: [
            ModeIndicator(mode: modeKey, isActive: isRunning),
            const SizedBox(height: AppSpacing.xl),
            ListenableBuilder(
              listenable: _glowController,
              builder: (context, child) {
                if (!isRunning && _glowController.value == 0) {
                  return child!;
                }
                final v = Curves.easeInOut.transform(_glowController.value);
                return DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: clockColor.withValues(alpha: v * 0.25),
                        blurRadius: 32 + v * 16,
                        spreadRadius: -4,
                      ),
                    ],
                  ),
                  child: child,
                );
              },
              child: clockText,
            ),
          ],
        );
      },
    );
  }
}

/// Renders HH:MM:SS with each character in a fixed-width cell
/// so the total width never shifts as digits change.
class _FixedWidthClock extends StatelessWidget {
  const _FixedWidthClock({
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.color,
  });

  final String hours;
  final String minutes;
  final String seconds;
  final Color color;

  static const _digitWidth = 32.0;
  static const _colonWidth = 18.0;

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.monoLarge.copyWith(color: color);
    final colonStyle = style.copyWith(color: color.withValues(alpha: 0.4));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _char(hours[0], style),
        _char(hours[1], style),
        _colon(colonStyle),
        _char(minutes[0], style),
        _char(minutes[1], style),
        _colon(colonStyle),
        _char(seconds[0], style),
        _char(seconds[1], style),
      ],
    );
  }

  Widget _char(String c, TextStyle style) {
    return SizedBox(
      width: _digitWidth,
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          style: style,
          child: Text(c),
        ),
      ),
    );
  }

  Widget _colon(TextStyle style) {
    return SizedBox(
      width: _colonWidth,
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          style: style,
          child: const Text(':'),
        ),
      ),
    );
  }
}
