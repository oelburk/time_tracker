import 'package:equatable/equatable.dart';
import 'package:settings_repository/settings_repository.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();
}

final class SettingsInitial extends SettingsState {
  const SettingsInitial();
  @override
  List<Object?> get props => [];
}

final class SettingsLoadSuccess extends SettingsState {
  const SettingsLoadSuccess({
    required this.themeMode,
    required this.workingHours,
    required this.hotkeyConfig,
    required this.launchAtLogin,
  });

  final String themeMode;
  final WorkingHours workingHours;
  final HotkeyConfig hotkeyConfig;
  final bool launchAtLogin;

  SettingsLoadSuccess copyWith({
    String? themeMode,
    WorkingHours? workingHours,
    HotkeyConfig? hotkeyConfig,
    bool? launchAtLogin,
  }) {
    return SettingsLoadSuccess(
      themeMode: themeMode ?? this.themeMode,
      workingHours: workingHours ?? this.workingHours,
      hotkeyConfig: hotkeyConfig ?? this.hotkeyConfig,
      launchAtLogin: launchAtLogin ?? this.launchAtLogin,
    );
  }

  @override
  List<Object?> get props => [
    themeMode,
    workingHours,
    hotkeyConfig,
    launchAtLogin,
  ];
}
