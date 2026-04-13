import 'package:equatable/equatable.dart';

import 'tracking_mode.dart';

class TimeEntry extends Equatable {
  const TimeEntry({
    required this.id,
    required this.mode,
    required this.startTime,
    required this.endTime,
  });

  final String id;
  final TrackingMode mode;
  final DateTime startTime;
  final DateTime endTime;

  Duration get duration => endTime.difference(startTime);
  int get durationSeconds => duration.inSeconds;

  Map<String, dynamic> toJson() => {
    'id': id,
    'mode': mode.name,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
  };

  factory TimeEntry.fromJson(Map<String, dynamic> json) => TimeEntry(
    id: json['id'] as String,
    mode: TrackingMode.values.byName(json['mode'] as String),
    startTime: DateTime.parse(json['startTime'] as String),
    endTime: DateTime.parse(json['endTime'] as String),
  );

  @override
  List<Object?> get props => [id, mode, startTime, endTime];
}
