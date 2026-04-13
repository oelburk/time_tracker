import 'package:equatable/equatable.dart';

class HotkeyConfig extends Equatable {
  const HotkeyConfig({
    this.keyCode,
    this.modifiers = const [],
    this.label = '',
  });

  final int? keyCode;
  final List<String> modifiers; // 'ctrl', 'alt', 'shift', 'meta'
  final String label;

  bool get isConfigured => keyCode != null;

  Map<String, dynamic> toJson() => {
    'keyCode': keyCode,
    'modifiers': modifiers,
    'label': label,
  };

  factory HotkeyConfig.fromJson(Map<String, dynamic> json) => HotkeyConfig(
    keyCode: json['keyCode'] as int?,
    modifiers:
        (json['modifiers'] as List<dynamic>?)?.cast<String>() ?? const [],
    label: json['label'] as String? ?? '',
  );

  @override
  List<Object?> get props => [keyCode, modifiers, label];
}
