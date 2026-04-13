import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/analytics_bloc.dart';
import '../bloc/analytics_event.dart';
import '../bloc/analytics_state.dart';
import '../widgets/widgets.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        if (state is AnalyticsLoadInProgress || state is AnalyticsInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is AnalyticsLoadFailure) {
          return const Center(child: Text('Failed to load analytics'));
        }
        final data = state as AnalyticsLoadSuccess;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PeriodSelector(
                isWeekly: data.isWeekly,
                periodLabel: data.periodLabel,
                onPrevious: () {
                  if (data.isWeekly) {
                    context.read<AnalyticsBloc>().add(
                      AnalyticsWeekChanged(weekOffset: data.weekOffset - 1),
                    );
                  } else {
                    context.read<AnalyticsBloc>().add(
                      AnalyticsMonthChanged(monthOffset: data.monthOffset - 1),
                    );
                  }
                },
                onNext: () {
                  if (data.isWeekly) {
                    context.read<AnalyticsBloc>().add(
                      AnalyticsWeekChanged(weekOffset: data.weekOffset + 1),
                    );
                  } else {
                    context.read<AnalyticsBloc>().add(
                      AnalyticsMonthChanged(monthOffset: data.monthOffset + 1),
                    );
                  }
                },
                onTabChanged: (isWeekly) {
                  context.read<AnalyticsBloc>().add(
                    AnalyticsTabChanged(isWeekly: isWeekly),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              SummaryStats(
                current: data.currentSummary,
                previous: data.previousSummary,
              ),
              const SizedBox(height: AppSpacing.xl),
              if (data.isWeekly)
                WeeklyChart(summary: data.currentSummary)
              else
                MonthlyChart(summary: data.currentSummary),
            ],
          ),
        );
      },
    );
  }
}
