import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';
import 'package:time_tracking_repository/time_tracking_repository.dart';
import 'package:settings_repository/settings_repository.dart';
import 'timer/bloc/timer_bloc.dart';
import 'timer/bloc/timer_event.dart';
import 'timer/bloc/timer_state.dart';
import 'tray/tray_service.dart';
import 'hotkey/hotkey_service.dart';
import 'app/bloc/theme_cubit.dart';
import 'app/view/app.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(480, 640),
    minimumSize: Size(400, 500),
    center: true,
    title: 'Time Tracker',
    titleBarStyle: TitleBarStyle.hidden,
    backgroundColor: Colors.transparent,
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  final settingsRepository = SettingsRepository();
  await settingsRepository.init();

  final timeTrackingRepository = TimeTrackingRepository();
  await timeTrackingRepository.init();

  final timerBloc = TimerBloc(
    timeTrackingRepository: timeTrackingRepository,
    settingsRepository: settingsRepository,
  );

  late final TrayService trayService;
  late final HotkeyService hotkeyService;

  trayService = TrayService(
    onModeChanged: (mode) {
      switch (mode) {
        case TrayMode.coding:
          timerBloc.add(const TimerStarted(mode: TrackingMode.coding));
        case TrayMode.meeting:
          timerBloc.add(const TimerStarted(mode: TrackingMode.meeting));
        case TrayMode.idle:
          timerBloc.add(const TimerStopped());
      }
    },
    onShowWindow: () async {
      await windowManager.show();
      await windowManager.focus();
    },
    onQuit: () async {
      timerBloc.add(const TimerStopped());
      await Future<void>.delayed(const Duration(milliseconds: 200));
      await windowManager.destroy();
    },
  );
  await trayService.init();

  hotkeyService = HotkeyService(
    onToggle: () {
      timerBloc.add(const TimerSwitched());
    },
  );
  await hotkeyService.init();
  await hotkeyService.updateHotkey(settingsRepository.getHotkeyConfig());

  timerBloc.stream.listen((state) {
    if (state is TimerRunning) {
      final trayMode = state.mode == TrackingMode.coding
          ? TrayMode.coding
          : TrayMode.meeting;
      trayService.updateMode(trayMode);
    } else {
      trayService.updateMode(TrayMode.idle);
    }
  });

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: timeTrackingRepository),
        RepositoryProvider.value(value: settingsRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: timerBloc),
          BlocProvider(
            create: (_) => ThemeCubit(settingsRepository: settingsRepository),
          ),
        ],
        child: const App(),
      ),
    ),
  );
}
