import 'package:equatable/equatable.dart';
import 'package:time_tracking_repository/time_tracking_repository.dart';

sealed class AnalyticsState extends Equatable {
  const AnalyticsState();
}

final class AnalyticsInitial extends AnalyticsState {
  const AnalyticsInitial();
  @override
  List<Object?> get props => [];
}

final class AnalyticsLoadInProgress extends AnalyticsState {
  const AnalyticsLoadInProgress();
  @override
  List<Object?> get props => [];
}

final class AnalyticsLoadSuccess extends AnalyticsState {
  const AnalyticsLoadSuccess({
    required this.currentSummary,
    required this.previousSummary,
    required this.isWeekly,
    required this.weekOffset,
    required this.monthOffset,
    required this.periodLabel,
  });

  final TimeSummary currentSummary;
  final TimeSummary previousSummary;
  final bool isWeekly;
  final int weekOffset;
  final int monthOffset;
  final String periodLabel;

  @override
  List<Object?> get props => [
    currentSummary,
    previousSummary,
    isWeekly,
    weekOffset,
    monthOffset,
    periodLabel,
  ];
}

final class AnalyticsLoadFailure extends AnalyticsState {
  const AnalyticsLoadFailure();
  @override
  List<Object?> get props => [];
}
