import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:settings_repository/settings_repository.dart';

/// Registers the user-defined global shortcut from [HotkeyConfig].
class HotkeyService {
  HotkeyService({required this.onToggle});

  final void Function() onToggle;

  Future<void> init() async {
    await hotKeyManager.unregisterAll();
  }

  Future<void> updateHotkey(HotkeyConfig config) async {
    await hotKeyManager.unregisterAll();
    if (!config.isConfigured || config.keyCode == null) {
      return;
    }

    final logicalKey = LogicalKeyboardKey.findKeyByKeyId(config.keyCode!);
    if (logicalKey == null) {
      return;
    }

    final modifiers = <HotKeyModifier>[];
    for (final m in config.modifiers) {
      switch (m) {
        case 'ctrl':
          modifiers.add(HotKeyModifier.control);
        case 'alt':
          modifiers.add(HotKeyModifier.alt);
        case 'shift':
          modifiers.add(HotKeyModifier.shift);
        case 'meta':
          modifiers.add(HotKeyModifier.meta);
      }
    }

    await hotKeyManager.register(
      HotKey(
        key: logicalKey,
        modifiers: modifiers.isEmpty ? null : modifiers,
        scope: HotKeyScope.system,
      ),
      keyDownHandler: (_) => onToggle(),
    );
  }
}
