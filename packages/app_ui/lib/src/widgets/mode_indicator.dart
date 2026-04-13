import 'package:flutter/material.dart';

import '../colors.dart';
import '../spacing.dart';
import '../typography.dart';

/// Colored dot + uppercase label for tracking mode.
/// Dot pulses when [isActive] — a heartbeat, not a disco.
class ModeIndicator extends StatefulWidget {
  const ModeIndicator({super.key, required this.mode, this.isActive = false});

  final String mode;
  final bool isActive;

  @override
  State<ModeIndicator> createState() => _ModeIndicatorState();
}

class _ModeIndicatorState extends State<ModeIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _pulse = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.isActive) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(ModeIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.repeat(reverse: true);
      } else {
        _controller
          ..stop()
          ..reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _dotColor() => switch (widget.mode.toLowerCase()) {
        'coding' => AppColors.codingPrimary,
        'meeting' => AppColors.meetingPrimary,
        _ => AppColors.idle,
      };

  String _label() => switch (widget.mode.toLowerCase()) {
        'coding' => 'CODING',
        'meeting' => 'MEETING',
        'idle' => 'IDLE',
        _ => widget.mode.toUpperCase(),
      };

  @override
  Widget build(BuildContext context) {
    final dotColor = _dotColor();

    final dot = Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: dotColor,
        shape: BoxShape.circle,
      ),
    );

    final animatedDot =
        widget.isActive ? FadeTransition(opacity: _pulse, child: dot) : dot;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        animatedDot,
        const SizedBox(width: AppSpacing.sm),
        Text(
          _label(),
          style: AppTypography.labelSmall.copyWith(
            color: dotColor,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}
