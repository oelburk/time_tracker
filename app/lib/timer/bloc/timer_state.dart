import 'package:equatable/equatable.dart';
import 'package:time_tracking_repository/time_tracking_repository.dart';

sealed class TimerState extends Equatable {
  const TimerState({this.todayCodingSeconds = 0, this.todayMeetingSeconds = 0});

  final int todayCodingSeconds;
  final int todayMeetingSeconds;
}

final class TimerIdle extends TimerState {
  const TimerIdle({super.todayCodingSeconds, super.todayMeetingSeconds});

  @override
  List<Object?> get props => [todayCodingSeconds, todayMeetingSeconds];
}

final class TimerRunning extends TimerState {
  const TimerRunning({
    required this.mode,
    required this.startTime,
    required this.elapsed,
    super.todayCodingSeconds,
    super.todayMeetingSeconds,
  });

  final TrackingMode mode;
  final DateTime startTime;
  final Duration elapsed;

  @override
  List<Object?> get props => [
    mode,
    startTime,
    elapsed,
    todayCodingSeconds,
    todayMeetingSeconds,
  ];
}
