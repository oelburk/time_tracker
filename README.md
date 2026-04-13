# Time Tracker

A minimal macOS menu-bar app for tracking time spent coding and in meetings.
Built with Flutter and designed to stay out of your way.

[![CI](https://github.com/oelburk/time_tracker/actions/workflows/ci.yaml/badge.svg)](https://github.com/oelburk/time_tracker/actions/workflows/ci.yaml)

## Features

- **System tray integration** — start, stop and switch modes from the menu bar without opening the window.
- **Two tracking modes** — separate timers for *Coding* and *Meeting* time.
- **Daily totals** — see how much time you've spent today at a glance.
- **Weekly & monthly analytics** — charts and summary stats with period navigation.
- **Global hotkey** — toggle tracking from anywhere on your Mac.
- **CSV export** — dump your time entries for use in spreadsheets or invoicing tools.
- **Configurable working hours** — set daily targets and get a sense of progress.
- **Light & dark theme** — follows system appearance or can be set manually.
- **Launch at login** — optionally start with macOS so tracking is always ready.

## Architecture

The project is a Dart workspace monorepo:

```
time_tracker/
├── app/                        # Flutter macOS application
├── packages/
│   ├── app_ui/                 # Shared theme, typography, colors, widgets
│   ├── time_tracking_repository/  # Time entry persistence & domain models
│   └── settings_repository/    # User preferences via SharedPreferences
├── pubspec.yaml                # Workspace root
└── analysis_options.yaml
```

State management uses **BLoC / Cubit** with `flutter_bloc`.
Navigation is handled by **GoRouter** with a `ShellRoute` for the tab layout.

## Prerequisites

| Tool | Version |
|------|---------|
| Flutter | stable channel (SDK ≥ 3.11) |
| macOS | 13+ (Ventura or later) |
| Xcode | 15+ |

The repo pins Flutter via [FVM](https://fvm.app) — run `fvm use` to pick up the
pinned version, or just use any recent stable Flutter.

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run the app
cd app
flutter run -d macos
```

## Project Structure

| Package | Purpose |
|---------|---------|
| `app` | Main application — UI, BLoCs, routing, tray & hotkey services |
| `app_ui` | Design tokens (colors, spacing, typography) and reusable widgets |
| `time_tracking_repository` | JSON-file–based storage for time entries, summaries, and domain models |
| `settings_repository` | SharedPreferences wrapper for user settings (theme, hotkey, working hours) |

## License

This is a personal project and is not currently licensed for redistribution.
