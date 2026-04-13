import 'package:equatable/equatable.dart';

class TimeSummary extends Equatable {
  const TimeSummary({
    required this.totalCodingSeconds,
    required this.totalMeetingSeconds,
    required this.entriesCount,
    required this.longestSessionSeconds,
    required this.dailyBreakdown,
  });

  final int totalCodingSeconds;
  final int totalMeetingSeconds;
  final int entriesCount;
  final int longestSessionSeconds;
  final Map<DateTime, DailySummary> dailyBreakdown;

  int get totalSeconds => totalCodingSeconds + totalMeetingSeconds;
  double get codingRatio =>
      totalSeconds > 0 ? totalCodingSeconds / totalSeconds : 0;

  @override
  List<Object?> get props => [
    totalCodingSeconds,
    totalMeetingSeconds,
    entriesCount,
    longestSessionSeconds,
    dailyBreakdown,
  ];
}

class DailySummary extends Equatable {
  const DailySummary({
    required this.codingSeconds,
    required this.meetingSeconds,
  });

  final int codingSeconds;
  final int meetingSeconds;

  int get totalSeconds => codingSeconds + meetingSeconds;

  @override
  List<Object?> get props => [codingSeconds, meetingSeconds];
}
