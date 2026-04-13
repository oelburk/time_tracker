import 'package:bloc/bloc.dart';
import 'package:settings_repository/settings_repository.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository,
      super(const SettingsInitial()) {
    on<SettingsLoaded>(_onLoaded);
    on<SettingsThemeChanged>(_onThemeChanged);
    on<SettingsWorkingHoursChanged>(_onWorkingHoursChanged);
    on<SettingsHotkeyChanged>(_onHotkeyChanged);
  }

  final SettingsRepository _settingsRepository;

  Future<void> _onLoaded(
    SettingsLoaded event,
    Emitter<SettingsState> emit,
  ) async {
    emit(
      SettingsLoadSuccess(
        themeMode: _settingsRepository.getThemeMode(),
        workingHours: _settingsRepository.getWorkingHours(),
        hotkeyConfig: _settingsRepository.getHotkeyConfig(),
      ),
    );
  }

  Future<void> _onThemeChanged(
    SettingsThemeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsRepository.setThemeMode(event.themeMode);
    final current = state;
    if (current is SettingsLoadSuccess) {
      emit(current.copyWith(themeMode: event.themeMode));
    }
  }

  Future<void> _onWorkingHoursChanged(
    SettingsWorkingHoursChanged event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsRepository.setWorkingHours(event.workingHours);
    final current = state;
    if (current is SettingsLoadSuccess) {
      emit(current.copyWith(workingHours: event.workingHours));
    }
  }

  Future<void> _onHotkeyChanged(
    SettingsHotkeyChanged event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsRepository.setHotkeyConfig(event.hotkeyConfig);
    final current = state;
    if (current is SettingsLoadSuccess) {
      emit(current.copyWith(hotkeyConfig: event.hotkeyConfig));
    }
  }
}
