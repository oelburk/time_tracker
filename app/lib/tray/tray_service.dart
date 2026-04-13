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

  static const _assetKeys = {
    TrayMode.coding: 'assets/icons/tray_coding.png',
    TrayMode.meeting: 'assets/icons/tray_meeting.png',
    TrayMode.idle: 'assets/icons/tray_idle.png',
  };

  final Map<TrayMode, String> _iconPaths = {};

  Future<void> init() async {
    await _extractIcons();
    await trayManager.setIcon(_iconPaths[TrayMode.idle]!);
    trayManager.addListener(this);
    await trayManager.setContextMenu(_buildMenu());
    await trayManager.setToolTip('Time Tracker');
  }

  /// Extracts bundled assets to the filesystem so tray_manager can read them.
  Future<void> _extractIcons() async {
    final dir = await getApplicationSupportDirectory();
    final iconsDir = Directory(p.join(dir.path, 'tray_icons'));
    if (!iconsDir.existsSync()) {
      iconsDir.createSync(recursive: true);
    }
    for (final entry in _assetKeys.entries) {
      final bytes = await rootBundle.load(entry.value);
      final file = File(p.join(iconsDir.path, p.basename(entry.value)));
      await file.writeAsBytes(bytes.buffer.asUint8List());
      _iconPaths[entry.key] = file.path;
    }
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
    await trayManager.setIcon(_iconPaths[mode]!);
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
