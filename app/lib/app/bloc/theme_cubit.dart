import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:settings_repository/settings_repository.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository,
      super(_parseThemeMode(settingsRepository.getThemeMode()));

  final SettingsRepository _settingsRepository;

  static ThemeMode _parseThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(String mode) async {
    await _settingsRepository.setThemeMode(mode);
    emit(_parseThemeMode(mode));
  }
}
