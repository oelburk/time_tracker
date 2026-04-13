import 'package:bloc/bloc.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:settings_repository/settings_repository.dart';

import '../../hotkey/hotkey_service.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required SettingsRepository settingsRepository,
    required HotkeyService hotkeyService,
  }) : _settingsRepository = settingsRepository,
       _hotkeyService = hotkeyService,
       super(const SettingsInitial()) {
    on<SettingsLoaded>(_onLoaded);
    on<SettingsThemeChanged>(_onThemeChanged);
    on<SettingsWorkingHoursChanged>(_onWorkingHoursChanged);
    on<SettingsHotkeyChanged>(_onHotkeyChanged);
    on<SettingsLaunchAtLoginChanged>(_onLaunchAtLoginChanged);
  }

  final SettingsRepository _settingsRepository;
  final HotkeyService _hotkeyService;

  Future<void> _onLoaded(
    SettingsLoaded event,
    Emitter<SettingsState> emit,
  ) async {
    emit(
      SettingsLoadSuccess(
        themeMode: _settingsRepository.getThemeMode(),
        workingHours: _settingsRepository.getWorkingHours(),
        hotkeyConfig: _settingsRepository.getHotkeyConfig(),
        launchAtLogin: _settingsRepository.getLaunchAtLogin(),
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
    await _hotkeyService.updateHotkey(event.hotkeyConfig);
    final current = state;
    if (current is SettingsLoadSuccess) {
      emit(current.copyWith(hotkeyConfig: event.hotkeyConfig));
    }
  }

  Future<void> _onLaunchAtLoginChanged(
    SettingsLaunchAtLoginChanged event,
    Emitter<SettingsState> emit,
  ) async {
    if (event.enabled) {
      await launchAtStartup.enable();
    } else {
      await launchAtStartup.disable();
    }
    await _settingsRepository.setLaunchAtLogin(event.enabled);
    final current = state;
    if (current is SettingsLoadSuccess) {
      emit(current.copyWith(launchAtLogin: event.enabled));
    }
  }
}
