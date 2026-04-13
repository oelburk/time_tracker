import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_repository/settings_repository.dart';

import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class HotkeySection extends StatelessWidget {
  const HotkeySection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tertiary = theme.textTheme.labelSmall?.color;

    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (prev, curr) {
        if (prev is SettingsLoadSuccess && curr is SettingsLoadSuccess) {
          return prev.hotkeyConfig != curr.hotkeyConfig;
        }
        return true;
      },
      builder: (context, state) {
        final config = state is SettingsLoadSuccess
            ? state.hotkeyConfig
            : const HotkeyConfig();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HOTKEY',
              style: AppTypography.labelSmall.copyWith(
                color: tertiary,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Toggle between coding and meeting modes',
              style: AppTypography.bodySmall.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.chipRadius),
                    border:
                        Border.all(color: theme.dividerColor, width: 0.5),
                  ),
                  child: Text(
                    config.isConfigured ? config.label : '—',
                    style: AppTypography.monoSmall.copyWith(
                      color: config.isConfigured
                          ? theme.textTheme.bodyLarge?.color
                          : tertiary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                GestureDetector(
                  onTap: () => _showHotkeyRecorder(context),
                  child: Text(
                    'RECORD',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.codingPrimary,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                if (config.isConfigured) ...[
                  const SizedBox(width: AppSpacing.md),
                  GestureDetector(
                    onTap: () {
                      context.read<SettingsBloc>().add(
                            const SettingsHotkeyChanged(
                              hotkeyConfig: HotkeyConfig(),
                            ),
                          );
                    },
                    child: Text(
                      'CLEAR',
                      style: AppTypography.labelSmall.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }

  void _showHotkeyRecorder(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => _HotkeyRecorderDialog(
        onRecorded: (config) {
          context.read<SettingsBloc>().add(
                SettingsHotkeyChanged(hotkeyConfig: config),
              );
        },
      ),
    );
  }
}

class _HotkeyRecorderDialog extends StatefulWidget {
  const _HotkeyRecorderDialog({required this.onRecorded});
  final ValueChanged<HotkeyConfig> onRecorded;

  @override
  State<_HotkeyRecorderDialog> createState() => _HotkeyRecorderDialogState();
}

class _HotkeyRecorderDialogState extends State<_HotkeyRecorderDialog> {
  String _displayText = 'Press a key combination…';
  HotkeyConfig? _recorded;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(
        'RECORD HOTKEY',
        style: AppTypography.labelSmall.copyWith(
          color: theme.textTheme.labelSmall?.color,
          letterSpacing: 1.5,
        ),
      ),
      content: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: (event) {
          if (event is KeyDownEvent) {
            final modifiers = <String>[];
            if (HardwareKeyboard.instance.isControlPressed) {
              modifiers.add('ctrl');
            }
            if (HardwareKeyboard.instance.isAltPressed) {
              modifiers.add('alt');
            }
            if (HardwareKeyboard.instance.isShiftPressed) {
              modifiers.add('shift');
            }
            if (HardwareKeyboard.instance.isMetaPressed) {
              modifiers.add('meta');
            }

            final key = event.logicalKey;
            if (key != LogicalKeyboardKey.control &&
                key != LogicalKeyboardKey.controlLeft &&
                key != LogicalKeyboardKey.controlRight &&
                key != LogicalKeyboardKey.alt &&
                key != LogicalKeyboardKey.altLeft &&
                key != LogicalKeyboardKey.altRight &&
                key != LogicalKeyboardKey.shift &&
                key != LogicalKeyboardKey.shiftLeft &&
                key != LogicalKeyboardKey.shiftRight &&
                key != LogicalKeyboardKey.meta &&
                key != LogicalKeyboardKey.metaLeft &&
                key != LogicalKeyboardKey.metaRight) {
              final label = [
                ...modifiers.map(
                  (m) => m == 'meta'
                      ? '⌘'
                      : m == 'ctrl'
                          ? '⌃'
                          : m == 'alt'
                              ? '⌥'
                              : '⇧',
                ),
                key.keyLabel,
              ].join(' + ');
              setState(() {
                _displayText = label;
                _recorded = HotkeyConfig(
                  keyCode: key.keyId,
                  modifiers: modifiers,
                  label: label,
                );
              });
            }
          }
        },
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(color: theme.dividerColor, width: 0.5),
          ),
          child: Center(
            child: Text(
              _displayText,
              style: AppTypography.monoSmall.copyWith(
                color: theme.textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'CANCEL',
            style: AppTypography.labelSmall.copyWith(
              color: theme.textTheme.bodySmall?.color,
              letterSpacing: 1,
            ),
          ),
        ),
        TextButton(
          onPressed: _recorded != null
              ? () {
                  widget.onRecorded(_recorded!);
                  Navigator.of(context).pop();
                }
              : null,
          child: Text(
            'SAVE',
            style: AppTypography.labelSmall.copyWith(
              color: _recorded != null
                  ? AppColors.codingPrimary
                  : theme.textTheme.labelSmall?.color,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }
}
