import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracking_repository/time_tracking_repository.dart';
import 'package:settings_repository/settings_repository.dart';
import 'analytics/bloc/analytics_bloc.dart';
import 'analytics/bloc/analytics_event.dart';
import 'settings/bloc/settings_bloc.dart';
import 'settings/bloc/settings_event.dart';
import 'app/view/shell_page.dart';
import 'timer/view/timer_page.dart';
import 'analytics/view/analytics_page.dart';
import 'settings/view/settings_page.dart';

abstract final class AppRoutePath {
  static const timer = '/';
  static const analytics = '/analytics';
  static const settings = '/settings';
}

final routerConfig = GoRouter(
  initialLocation: AppRoutePath.timer,
  routes: [
    ShellRoute(
      builder: (context, state, child) => ShellPage(child: child),
      routes: [
        GoRoute(
          path: AppRoutePath.timer,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: TimerPage()),
        ),
        GoRoute(
          path: AppRoutePath.analytics,
          pageBuilder: (context, state) => NoTransitionPage(
            child: BlocProvider(
              create: (context) => AnalyticsBloc(
                timeTrackingRepository: context.read<TimeTrackingRepository>(),
              )..add(const AnalyticsLoaded()),
              child: const AnalyticsPage(),
            ),
          ),
        ),
        GoRoute(
          path: AppRoutePath.settings,
          pageBuilder: (context, state) => NoTransitionPage(
            child: BlocProvider(
              create: (context) => SettingsBloc(
                settingsRepository: context.read<SettingsRepository>(),
              )..add(const SettingsLoaded()),
              child: const SettingsPage(),
            ),
          ),
        ),
      ],
    ),
  ],
);
