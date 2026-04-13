import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_ui/app_ui.dart';
import 'package:settings_repository/settings_repository.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class HotkeySection extends StatelessWidget {
  const HotkeySection({super.key});

  @override
  Widget build(BuildContext context) {
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
        return AppCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mode Switch Hotkey',
                style: AppTypography.titleMedium.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Press to toggle between Coding and Meeting modes',
                style: AppTypography.bodySmall.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.buttonRadius,
                      ),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: Text(
                      config.isConfigured ? config.label : 'Not set',
                      style: AppTypography.labelLarge.copyWith(
                        color: config.isConfigured
                            ? Theme.of(context).textTheme.bodyLarge?.color
                            : Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () => _showHotkeyRecorder(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.codingPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                    ),
                    child: const Text('Record'),
                  ),
                  if (config.isConfigured) ...[
                    const SizedBox(width: AppSpacing.sm),
                    IconButton(
                      onPressed: () {
                        context.read<SettingsBloc>().add(
                          const SettingsHotkeyChanged(
                            hotkeyConfig: HotkeyConfig(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.clear, size: 18),
                      tooltip: 'Clear hotkey',
                    ),
                  ],
                ],
              ),
            ],
          ),
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
  String _displayText = 'Press a key combination...';
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
    return AlertDialog(
      title: const Text('Record Hotkey'),
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
          width: 250,
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Center(
            child: Text(
              _displayText,
              style: AppTypography.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _recorded != null
              ? () {
                  widget.onRecorded(_recorded!);
                  Navigator.of(context).pop();
                }
              : null,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
