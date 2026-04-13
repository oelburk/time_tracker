import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:time_tracking_repository/time_tracking_repository.dart';

class ExportSection extends StatelessWidget {
  const ExportSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tertiary = theme.textTheme.labelSmall?.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EXPORT',
          style: AppTypography.labelSmall.copyWith(
            color: tertiary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Download all entries as CSV',
          style: AppTypography.bodySmall.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        GestureDetector(
          onTap: () => _exportData(context),
          child: Text(
            'EXPORT CSV →',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.codingPrimary,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _exportData(BuildContext context) async {
    try {
      final repo = context.read<TimeTrackingRepository>();
      final csv = await repo.exportToCsv();
      final dir = await getDownloadsDirectory() ??
          await getApplicationDocumentsDirectory();
      final file = File(
        '${dir.path}/time_tracker_export_${DateTime.now().millisecondsSinceEpoch}.csv',
      );
      await file.writeAsString(csv);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exported to ${file.path}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }
}
