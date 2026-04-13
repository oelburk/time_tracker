import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:time_tracking_repository/time_tracking_repository.dart';

import 'timer_event.dart';
import 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc({
    required TimeTrackingRepository timeTrackingRepository,
    required SettingsRepository settingsRepository,
  }) : _timeTrackingRepository = timeTrackingRepository,
       _settingsRepository = settingsRepository,
       super(const TimerIdle()) {
    on<TimerStarted>(_onStarted);
    on<TimerStopped>(_onStopped);
    on<TimerSwitched>(_onSwitched);
    on<TimerTicked>(_onTicked);
    on<TimerWorkingHoursExceeded>(_onWorkingHoursExceeded);
  }

  final TimeTrackingRepository _timeTrackingRepository;
  final SettingsRepository _settingsRepository;
  Timer? _ticker;
  Timer? _workingHoursChecker;

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      add(const TimerTicked());
    });
    _workingHoursChecker?.cancel();
    _workingHoursChecker = Timer.periodic(const Duration(minutes: 1), (_) {
      final now = DateTime.now();
      final workingHours = _settingsRepository.getWorkingHours();
      if (!workingHours.isWithinWorkingHours(now)) {
        add(const TimerWorkingHoursExceeded());
      }
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
    _workingHoursChecker?.cancel();
    _workingHoursChecker = null;
  }

  Future<void> _onStarted(TimerStarted event, Emitter<TimerState> emit) async {
    if (state is TimerRunning) {
      await _saveCurrentSession();
    }
    _startTicker();
    emit(
      TimerRunning(
        mode: event.mode,
        startTime: DateTime.now(),
        elapsed: Duration.zero,
      ),
    );
  }

  Future<void> _onStopped(TimerStopped event, Emitter<TimerState> emit) async {
    if (state is TimerRunning) {
      await _saveCurrentSession();
    }
    _stopTicker();
    emit(const TimerIdle());
  }

  Future<void> _onSwitched(
    TimerSwitched event,
    Emitter<TimerState> emit,
  ) async {
    final currentState = state;
    if (currentState is TimerRunning) {
      await _saveCurrentSession();
      final newMode = currentState.mode == TrackingMode.coding
          ? TrackingMode.meeting
          : TrackingMode.coding;
      emit(
        TimerRunning(
          mode: newMode,
          startTime: DateTime.now(),
          elapsed: Duration.zero,
        ),
      );
    }
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    final currentState = state;
    if (currentState is TimerRunning) {
      emit(
        TimerRunning(
          mode: currentState.mode,
          startTime: currentState.startTime,
          elapsed: DateTime.now().difference(currentState.startTime),
        ),
      );
    }
  }

  Future<void> _onWorkingHoursExceeded(
    TimerWorkingHoursExceeded event,
    Emitter<TimerState> emit,
  ) async {
    if (state is TimerRunning) {
      await _saveCurrentSession();
      _stopTicker();
      emit(const TimerIdle());
    }
  }

  Future<void> _saveCurrentSession() async {
    final currentState = state;
    if (currentState is TimerRunning) {
      final now = DateTime.now();
      if (now.difference(currentState.startTime).inSeconds > 5) {
        final entry = TimeEntry(
          id: '${currentState.startTime.millisecondsSinceEpoch}',
          mode: currentState.mode,
          startTime: currentState.startTime,
          endTime: now,
        );
        await _timeTrackingRepository.addEntry(entry);
      }
    }
  }

  @override
  Future<void> close() {
    _stopTicker();
    return super.close();
  }
}
