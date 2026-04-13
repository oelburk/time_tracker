import 'package:equatable/equatable.dart';

class WorkingHours extends Equatable {
  const WorkingHours({
    this.startHour = 9,
    this.startMinute = 0,
    this.endHour = 17,
    this.endMinute = 0,
    this.workingDays = const [1, 2, 3, 4, 5], // Mon-Fri
  });

  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final List<int> workingDays; // 1=Mon, 7=Sun

  bool isWithinWorkingHours(DateTime dateTime) {
    if (!workingDays.contains(dateTime.weekday)) return true;
    final currentMinutes = dateTime.hour * 60 + dateTime.minute;
    final startMinutes = startHour * 60 + startMinute;
    final endMinutes = endHour * 60 + endMinute;
    return currentMinutes >= startMinutes && currentMinutes < endMinutes;
  }

  Map<String, dynamic> toJson() => {
    'startHour': startHour,
    'startMinute': startMinute,
    'endHour': endHour,
    'endMinute': endMinute,
    'workingDays': workingDays,
  };

  factory WorkingHours.fromJson(Map<String, dynamic> json) => WorkingHours(
    startHour: json['startHour'] as int? ?? 9,
    startMinute: json['startMinute'] as int? ?? 0,
    endHour: json['endHour'] as int? ?? 17,
    endMinute: json['endMinute'] as int? ?? 0,
    workingDays:
        (json['workingDays'] as List<dynamic>?)?.cast<int>() ??
        const [1, 2, 3, 4, 5],
  );

  @override
  List<Object?> get props => [
    startHour,
    startMinute,
    endHour,
    endMinute,
    workingDays,
  ];
}
