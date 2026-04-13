import 'package:equatable/equatable.dart';
import 'package:time_tracking_repository/time_tracking_repository.dart';

sealed class TimerEvent extends Equatable {
  const TimerEvent();
}

final class TimerStarted extends TimerEvent {
  const TimerStarted({required this.mode});
  final TrackingMode mode;
  @override
  List<Object?> get props => [mode];
}

final class TimerStopped extends TimerEvent {
  const TimerStopped();
  @override
  List<Object?> get props => [];
}

final class TimerSwitched extends TimerEvent {
  const TimerSwitched();
  @override
  List<Object?> get props => [];
}

final class TimerTicked extends TimerEvent {
  const TimerTicked();
  @override
  List<Object?> get props => [];
}

final class TimerWorkingHoursExceeded extends TimerEvent {
  const TimerWorkingHoursExceeded();
  @override
  List<Object?> get props => [];
}

final class TimerTodayTotalsRequested extends TimerEvent {
  const TimerTodayTotalsRequested();
  @override
  List<Object?> get props => [];
}
