import 'dart:async';

import 'package:tray_manager/tray_manager.dart';

enum TrayMode { coding, meeting, idle }

class TrayService with TrayListener {
  TrayService({
    required this.onModeChanged,
    required this.onShowWindow,
    required this.onQuit,
  });

  final void Function(TrayMode mode) onModeChanged;
  final Future<void> Function() onShowWindow;
  final Future<void> Function() onQuit;

  static const _icons = {
    TrayMode.coding: 'assets/icons/tray_coding.png',
    TrayMode.meeting: 'assets/icons/tray_meeting.png',
    TrayMode.idle: 'assets/icons/tray_idle.png',
  };

  Future<void> init() async {
    await trayManager.setIcon(_icons[TrayMode.idle]!);
    trayManager.addListener(this);
    await trayManager.setContextMenu(_buildMenu());
    await trayManager.setToolTip('Time Tracker');
  }

  Menu _buildMenu() {
    return Menu(
      items: [
        MenuItem(key: 'coding', label: 'Start Coding'),
        MenuItem(key: 'meeting', label: 'Start Meeting'),
        MenuItem(key: 'idle', label: 'Stop Tracking'),
        MenuItem.separator(),
        MenuItem(key: 'show', label: 'Open Dashboard'),
        MenuItem(key: 'quit', label: 'Quit'),
      ],
    );
  }

  Future<void> updateMode(TrayMode mode) async {
    await trayManager.setIcon(_icons[mode]!);
    final tip = switch (mode) {
      TrayMode.coding => 'Time Tracker — Coding',
      TrayMode.meeting => 'Time Tracker — Meeting',
      TrayMode.idle => 'Time Tracker',
    };
    await trayManager.setToolTip(tip);
  }

  @override
  void onTrayIconMouseDown() {
    unawaited(onShowWindow());
  }

  @override
  void onTrayIconRightMouseDown() {
    unawaited(trayManager.popUpContextMenu());
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'coding':
        onModeChanged(TrayMode.coding);
      case 'meeting':
        onModeChanged(TrayMode.meeting);
      case 'idle':
        onModeChanged(TrayMode.idle);
      case 'show':
        unawaited(onShowWindow());
      case 'quit':
        unawaited(onQuit());
      default:
        break;
    }
  }

  void dispose() {
    trayManager.removeListener(this);
  }
}
