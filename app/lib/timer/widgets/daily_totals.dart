import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/timer_bloc.dart';
import '../bloc/timer_state.dart';

class DailyTotals extends StatelessWidget {
  const DailyTotals({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TimerBloc, TimerState, ({int coding, int meeting})>(
      selector: (state) => (
        coding: state.todayCodingSeconds,
        meeting: state.todayMeetingSeconds,
      ),
      builder: (context, totals) {
        return Row(
          children: [
            Expanded(
              child: _TotalTile(
                label: 'CODING',
                seconds: totals.coding,
                color: AppColors.codingPrimary,
              ),
            ),
            SizedBox(
              height: 40,
              child: VerticalDivider(
                width: 1,
                thickness: 0.5,
                color: Theme.of(context).dividerColor,
              ),
            ),
            Expanded(
              child: _TotalTile(
                label: 'MEETINGS',
                seconds: totals.meeting,
                color: AppColors.meetingPrimary,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TotalTile extends StatelessWidget {
  const _TotalTile({
    required this.label,
    required this.seconds,
    required this.color,
  });

  final String label;
  final int seconds;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final formatted = h > 0 ? '${h}h ${m}m' : '${m}m';

    return Column(
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: Theme.of(context).textTheme.labelSmall?.color,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.15),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              )),
              child: child,
            ),
          ),
          child: Text(
            formatted,
            key: ValueKey(formatted),
            style: AppTypography.monoMedium.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
