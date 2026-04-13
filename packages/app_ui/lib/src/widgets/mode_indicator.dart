import 'package:flutter/material.dart';

import '../colors.dart';
import '../spacing.dart';
import '../typography.dart';

/// Colored dot and label for tracking mode; dot pulses when [isActive].
class ModeIndicator extends StatefulWidget {
  const ModeIndicator({super.key, required this.mode, this.isActive = false});

  /// One of: `coding`, `meeting`, `idle` (case-insensitive).
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
      duration: const Duration(milliseconds: 1100),
    );
    _pulse = Tween<double>(
      begin: 0.45,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    if (widget.isActive) {
      _controller.repeat(reverse: true);
    }
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

  Color _dotColor() {
    switch (widget.mode.toLowerCase()) {
      case 'coding':
        return AppColors.codingPrimary;
      case 'meeting':
        return AppColors.meetingPrimary;
      case 'idle':
      default:
        return AppColors.idle;
    }
  }

  String _label() {
    switch (widget.mode.toLowerCase()) {
      case 'coding':
        return 'Coding';
      case 'meeting':
        return 'Meeting';
      case 'idle':
        return 'Idle';
      default:
        if (widget.mode.isEmpty) return 'Unknown';
        return widget.mode[0].toUpperCase() + widget.mode.substring(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelColor = theme.textTheme.bodyLarge?.color;
    final dotColor = _dotColor();

    final dot = Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: dotColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: dotColor.withValues(alpha: 0.45),
            blurRadius: widget.isActive ? 6 : 3,
            spreadRadius: widget.isActive ? 1 : 0,
          ),
        ],
      ),
    );

    final animatedDot = widget.isActive
        ? FadeTransition(opacity: _pulse, child: dot)
        : dot;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        animatedDot,
        const SizedBox(width: AppSpacing.sm),
        Text(
          _label(),
          style: AppTypography.labelLarge.copyWith(color: labelColor),
        ),
      ],
    );
  }
}
