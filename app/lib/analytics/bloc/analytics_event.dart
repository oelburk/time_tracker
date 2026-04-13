import 'package:equatable/equatable.dart';

sealed class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();
}

final class AnalyticsLoaded extends AnalyticsEvent {
  const AnalyticsLoaded();
  @override
  List<Object?> get props => [];
}

final class AnalyticsWeekChanged extends AnalyticsEvent {
  const AnalyticsWeekChanged({required this.weekOffset});
  final int weekOffset;
  @override
  List<Object?> get props => [weekOffset];
}

final class AnalyticsMonthChanged extends AnalyticsEvent {
  const AnalyticsMonthChanged({required this.monthOffset});
  final int monthOffset;
  @override
  List<Object?> get props => [monthOffset];
}

final class AnalyticsTabChanged extends AnalyticsEvent {
  const AnalyticsTabChanged({required this.isWeekly});
  final bool isWeekly;
  @override
  List<Object?> get props => [isWeekly];
}
