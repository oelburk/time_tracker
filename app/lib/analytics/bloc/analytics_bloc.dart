import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:time_tracking_repository/time_tracking_repository.dart';

import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  AnalyticsBloc({required TimeTrackingRepository timeTrackingRepository})
    : _timeTrackingRepository = timeTrackingRepository,
      super(const AnalyticsInitial()) {
    on<AnalyticsLoaded>(_onLoaded);
    on<AnalyticsWeekChanged>(_onWeekChanged);
    on<AnalyticsMonthChanged>(_onMonthChanged);
    on<AnalyticsTabChanged>(_onTabChanged);
  }

  final TimeTrackingRepository _timeTrackingRepository;
  int _weekOffset = 0;
  int _monthOffset = 0;
  bool _isWeekly = true;

  Future<void> _onLoaded(
    AnalyticsLoaded event,
    Emitter<AnalyticsState> emit,
  ) async {
    await _loadData(emit);
  }

  Future<void> _onWeekChanged(
    AnalyticsWeekChanged event,
    Emitter<AnalyticsState> emit,
  ) async {
    _weekOffset = event.weekOffset;
    await _loadData(emit);
  }

  Future<void> _onMonthChanged(
    AnalyticsMonthChanged event,
    Emitter<AnalyticsState> emit,
  ) async {
    _monthOffset = event.monthOffset;
    await _loadData(emit);
  }

  Future<void> _onTabChanged(
    AnalyticsTabChanged event,
    Emitter<AnalyticsState> emit,
  ) async {
    _isWeekly = event.isWeekly;
    await _loadData(emit);
  }

  Future<void> _loadData(Emitter<AnalyticsState> emit) async {
    emit(const AnalyticsLoadInProgress());
    try {
      final now = DateTime.now();

      if (_isWeekly) {
        final weekStart = _getWeekStart(
          now,
        ).add(Duration(days: _weekOffset * 7));
        final weekEnd = weekStart.add(const Duration(days: 7));
        final prevWeekStart = weekStart.subtract(const Duration(days: 7));

        final current = await _timeTrackingRepository.getSummaryForDateRange(
          weekStart,
          weekEnd,
        );
        final previous = await _timeTrackingRepository.getSummaryForDateRange(
          prevWeekStart,
          weekStart,
        );

        final label =
            '${DateFormat('MMM d').format(weekStart)} - ${DateFormat('MMM d').format(weekEnd.subtract(const Duration(days: 1)))}';

        emit(
          AnalyticsLoadSuccess(
            currentSummary: current,
            previousSummary: previous,
            isWeekly: true,
            weekOffset: _weekOffset,
            monthOffset: _monthOffset,
            periodLabel: label,
          ),
        );
      } else {
        final monthStart = DateTime(now.year, now.month + _monthOffset, 1);
        final monthEnd = DateTime(now.year, now.month + _monthOffset + 1, 1);
        final prevMonthStart = DateTime(
          now.year,
          now.month + _monthOffset - 1,
          1,
        );

        final current = await _timeTrackingRepository.getSummaryForDateRange(
          monthStart,
          monthEnd,
        );
        final previous = await _timeTrackingRepository.getSummaryForDateRange(
          prevMonthStart,
          monthStart,
        );

        final label = DateFormat('MMMM yyyy').format(monthStart);

        emit(
          AnalyticsLoadSuccess(
            currentSummary: current,
            previousSummary: previous,
            isWeekly: false,
            weekOffset: _weekOffset,
            monthOffset: _monthOffset,
            periodLabel: label,
          ),
        );
      }
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(const AnalyticsLoadFailure());
    }
  }

  DateTime _getWeekStart(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return DateTime(date.year, date.month, date.day - daysFromMonday);
  }
}
