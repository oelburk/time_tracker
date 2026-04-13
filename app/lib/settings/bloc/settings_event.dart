import 'package:equatable/equatable.dart';
import 'package:settings_repository/settings_repository.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();
}

final class SettingsLoaded extends SettingsEvent {
  const SettingsLoaded();
  @override
  List<Object?> get props => [];
}

final class SettingsThemeChanged extends SettingsEvent {
  const SettingsThemeChanged({required this.themeMode});
  final String themeMode;
  @override
  List<Object?> get props => [themeMode];
}

final class SettingsWorkingHoursChanged extends SettingsEvent {
  const SettingsWorkingHoursChanged({required this.workingHours});
  final WorkingHours workingHours;
  @override
  List<Object?> get props => [workingHours];
}

final class SettingsHotkeyChanged extends SettingsEvent {
  const SettingsHotkeyChanged({required this.hotkeyConfig});
  final HotkeyConfig hotkeyConfig;
  @override
  List<Object?> get props => [hotkeyConfig];
}

final class SettingsLaunchAtLoginChanged extends SettingsEvent {
  const SettingsLaunchAtLoginChanged({required this.enabled});
  final bool enabled;
  @override
  List<Object?> get props => [enabled];
}
