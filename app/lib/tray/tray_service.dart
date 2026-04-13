import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
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

  Future<void> init() async {
    final iconPath = await _extractAssetIcon();
    await trayManager.setIcon(iconPath, isTemplate: true);
    trayManager.addListener(this);
    await trayManager.setContextMenu(_buildMenu());
    await trayManager.setToolTip('Time Tracker');
  }

  Future<String> _extractAssetIcon() async {
    final data = await rootBundle.load('assets/icons/tray.png');
    final dir = await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, 'tray_icon.png'));
    if (!await file.exists()) {
      await file.writeAsBytes(data.buffer.asUint8List());
    }
    return file.path;
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
