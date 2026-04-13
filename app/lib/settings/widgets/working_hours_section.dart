import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_ui/app_ui.dart';
import 'package:settings_repository/settings_repository.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class WorkingHoursSection extends StatelessWidget {
  const WorkingHoursSection({super.key});

  @override
  Widget build(BuildContext context) {
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
        return AppCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Working Hours',
                style: AppTypography.titleMedium.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Text(
                    'Start: ',
                    style: AppTypography.bodyLarge.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
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
                    'End: ',
                    style: AppTypography.bodyLarge.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
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
              Text(
                'Working Days',
                style: AppTypography.bodyLarge.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  for (final entry in {
                    'Mon': 1,
                    'Tue': 2,
                    'Wed': 3,
                    'Thu': 4,
                    'Fri': 5,
                    'Sat': 6,
                    'Sun': 7,
                  }.entries)
                    _DayChip(
                      label: entry.key,
                      isSelected: hours.workingDays.contains(entry.value),
                      onTap: () {
                        final newDays = List<int>.from(hours.workingDays);
                        if (newDays.contains(entry.value)) {
                          newDays.remove(entry.value);
                        } else {
                          newDays.add(entry.value);
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
                ],
              ),
            ],
          ),
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
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Text(
          '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
          style: AppTypography.labelLarge.copyWith(
            color: Theme.of(context).textTheme.bodyLarge?.color,
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.codingPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
          border: Border.all(
            color: isSelected
                ? AppColors.codingPrimary
                : Theme.of(context).dividerColor,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: isSelected
                ? Colors.white
                : Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ),
    );
  }
}
