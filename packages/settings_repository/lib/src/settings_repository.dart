import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models/models.dart';

/// Persists user preferences with [SharedPreferences].
class SettingsRepository {
  SharedPreferences? _prefs;

  static const _keyThemeMode = 'theme_mode';
  static const _keyWorkingHours = 'working_hours';
  static const _keyHotkeyConfig = 'hotkey_config';
  static const _keyLaunchAtLogin = 'launch_at_login';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _preferences {
    final prefs = _prefs;
    if (prefs == null) {
      throw StateError('SettingsRepository.init() must be called before use.');
    }
    return prefs;
  }

  String getThemeMode() {
    return _preferences.getString(_keyThemeMode) ?? 'system';
  }

  Future<void> setThemeMode(String mode) async {
    await _preferences.setString(_keyThemeMode, mode);
  }

  WorkingHours getWorkingHours() {
    final raw = _preferences.getString(_keyWorkingHours);
    if (raw == null || raw.isEmpty) {
      return const WorkingHours();
    }
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return WorkingHours.fromJson(map);
  }

  Future<void> setWorkingHours(WorkingHours hours) async {
    await _preferences.setString(_keyWorkingHours, jsonEncode(hours.toJson()));
  }

  HotkeyConfig getHotkeyConfig() {
    final raw = _preferences.getString(_keyHotkeyConfig);
    if (raw == null || raw.isEmpty) {
      return const HotkeyConfig();
    }
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return HotkeyConfig.fromJson(map);
  }

  Future<void> setHotkeyConfig(HotkeyConfig config) async {
    await _preferences.setString(_keyHotkeyConfig, jsonEncode(config.toJson()));
  }

  bool getLaunchAtLogin() {
    return _preferences.getBool(_keyLaunchAtLogin) ?? false;
  }

  Future<void> setLaunchAtLogin(bool enabled) async {
    await _preferences.setBool(_keyLaunchAtLogin, enabled);
  }
}
