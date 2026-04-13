import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_repository/settings_repository.dart';

import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class WorkingHoursSection extends StatelessWidget {
  const WorkingHoursSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tertiary = theme.textTheme.labelSmall?.color;

    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (prev, curr) {
        if (prev is SettingsLoadSuccess && curr is SettingsLoadSuccess) {
          return prev.workingHours != curr.workingHours;
        }
        return true;
      },
      builder: (context, state) {
        final hours = state is SettingsLoadSuccess
            ? state.workingHours
            : const WorkingHours();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WORKING HOURS',
              style: AppTypography.labelSmall.copyWith(
                color: tertiary,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Text(
                  'Start',
                  style: AppTypography.bodySmall.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _TimePickerButton(
                  hour: hours.startHour,
                  minute: hours.startMinute,
                  onChanged: (h, m) {
                    context.read<SettingsBloc>().add(
                          SettingsWorkingHoursChanged(
                            workingHours: WorkingHours(
                              startHour: h,
                              startMinute: m,
                              endHour: hours.endHour,
                              endMinute: hours.endMinute,
                              workingDays: hours.workingDays,
                            ),
                          ),
                        );
                  },
                ),
                const SizedBox(width: AppSpacing.xl),
                Text(
                  'End',
                  style: AppTypography.bodySmall.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _TimePickerButton(
                  hour: hours.endHour,
                  minute: hours.endMinute,
                  onChanged: (h, m) {
                    context.read<SettingsBloc>().add(
                          SettingsWorkingHoursChanged(
                            workingHours: WorkingHours(
                              startHour: hours.startHour,
                              startMinute: hours.startMinute,
                              endHour: h,
                              endMinute: m,
                              workingDays: hours.workingDays,
                            ),
                          ),
                        );
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                for (final (label, day) in [
                  ('M', 1), ('T', 2), ('W', 3), ('T', 4),
                  ('F', 5), ('S', 6), ('S', 7),
                ]) ...[
                  _DayChip(
                    label: label,
                    isSelected: hours.workingDays.contains(day),
                    onTap: () {
                      final newDays = List<int>.from(hours.workingDays);
                      if (newDays.contains(day)) {
                        newDays.remove(day);
                      } else {
                        newDays.add(day);
                        newDays.sort();
                      }
                      context.read<SettingsBloc>().add(
                            SettingsWorkingHoursChanged(
                              workingHours: WorkingHours(
                                startHour: hours.startHour,
                                startMinute: hours.startMinute,
                                endHour: hours.endHour,
                                endMinute: hours.endMinute,
                                workingDays: newDays,
                              ),
                            ),
                          );
                    },
                  ),
                  if (day < 7) const SizedBox(width: AppSpacing.xs),
                ],
              ],
            ),
          ],
        );
      },
    );
  }
}

class _TimePickerButton extends StatelessWidget {
  const _TimePickerButton({
    required this.hour,
    required this.minute,
    required this.onChanged,
  });

  final int hour;
  final int minute;
  final void Function(int hour, int minute) onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: hour, minute: minute),
        );
        if (time != null) {
          onChanged(time.hour, time.minute);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
          border: Border.all(color: theme.dividerColor, width: 0.5),
        ),
        child: Text(
          '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
          style: AppTypography.monoSmall.copyWith(
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.codingPrimary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
          border: Border.all(
            color: isSelected
                ? AppColors.codingPrimary.withValues(alpha: 0.4)
                : theme.dividerColor,
            width: 0.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: isSelected
                  ? AppColors.codingPrimary
                  : theme.textTheme.bodySmall?.color,
              fontSize: 9,
              letterSpacing: 0,
            ),
          ),
        ),
      ),
    );
  }
}
