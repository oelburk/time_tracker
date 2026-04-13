import 'package:equatable/equatable.dart';
import 'package:time_tracking_repository/time_tracking_repository.dart';

sealed class TimerState extends Equatable {
  const TimerState();
}

final class TimerIdle extends TimerState {
  const TimerIdle();
  @override
  List<Object?> get props => [];
}

final class TimerRunning extends TimerState {
  const TimerRunning({
    required this.mode,
    required this.startTime,
    required this.elapsed,
  });
  final TrackingMode mode;
  final DateTime startTime;
  final Duration elapsed;

  @override
  List<Object?> get props => [mode, startTime, elapsed];
}
