import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'models/models.dart';

class TimeTrackingRepository {
  List<TimeEntry> _entries = [];
  String? _filePath;

  Future<void> init() async {
    final dir = await getApplicationSupportDirectory();
    _filePath = p.join(dir.path, 'time_entries.json');
    await _loadEntries();
  }

  Future<void> _loadEntries() async {
    final file = File(_filePath!);
    if (await file.exists()) {
      final contents = await file.readAsString();
      final list = jsonDecode(contents) as List<dynamic>;
      _entries = list
          .map((e) => TimeEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }

  Future<void> _saveEntries() async {
    final file = File(_filePath!);
    final json = jsonEncode(_entries.map((e) => e.toJson()).toList());
    await file.writeAsString(json);
  }

  Future<void> addEntry(TimeEntry entry) async {
    _entries.add(entry);
    await _saveEntries();
  }

  Future<List<TimeEntry>> getEntries() async => List.unmodifiable(_entries);

  Future<List<TimeEntry>> getEntriesForDateRange(
    DateTime start,
    DateTime end,
  ) async {
    return _entries
        .where((e) => e.startTime.isAfter(start) && e.startTime.isBefore(end))
        .toList();
  }

  Future<TimeSummary> getSummaryForDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final entries = await getEntriesForDateRange(start, end);

    var totalCoding = 0;
    var totalMeeting = 0;
    var longestSession = 0;
    final daily = <DateTime, DailySummary>{};

    for (final entry in entries) {
      final seconds = entry.durationSeconds;
      if (seconds > longestSession) longestSession = seconds;

      if (entry.mode == TrackingMode.coding) {
        totalCoding += seconds;
      } else {
        totalMeeting += seconds;
      }

      final day = DateTime(
        entry.startTime.year,
        entry.startTime.month,
        entry.startTime.day,
      );
      final existing = daily[day];
      if (existing != null) {
        daily[day] = DailySummary(
          codingSeconds:
              existing.codingSeconds +
              (entry.mode == TrackingMode.coding ? seconds : 0),
          meetingSeconds:
              existing.meetingSeconds +
              (entry.mode == TrackingMode.meeting ? seconds : 0),
        );
      } else {
        daily[day] = DailySummary(
          codingSeconds: entry.mode == TrackingMode.coding ? seconds : 0,
          meetingSeconds: entry.mode == TrackingMode.meeting ? seconds : 0,
        );
      }
    }

    return TimeSummary(
      totalCodingSeconds: totalCoding,
      totalMeetingSeconds: totalMeeting,
      entriesCount: entries.length,
      longestSessionSeconds: longestSession,
      dailyBreakdown: daily,
    );
  }

  Future<String> exportToCsv() async {
    final rows = <List<String>>[
      ['Date', 'Mode', 'Start', 'End', 'Duration (minutes)'],
    ];

    for (final entry in _entries) {
      rows.add([
        '${entry.startTime.year}-${entry.startTime.month.toString().padLeft(2, '0')}-${entry.startTime.day.toString().padLeft(2, '0')}',
        entry.mode.label,
        entry.startTime.toIso8601String(),
        entry.endTime.toIso8601String(),
        (entry.durationSeconds / 60).toStringAsFixed(1),
      ]);
    }

    return rows.map((row) => row.map((cell) => '"$cell"').join(',')).join('\n');
  }
}
