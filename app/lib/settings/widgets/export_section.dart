import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_ui/app_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:time_tracking_repository/time_tracking_repository.dart';

class ExportSection extends StatelessWidget {
  const ExportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data Export',
            style: AppTypography.titleMedium.copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Export all time tracking data as CSV',
            style: AppTypography.bodySmall.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton.icon(
            onPressed: () => _exportData(context),
            icon: const Icon(Icons.download, size: 18),
            label: const Text('Export CSV'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.codingPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportData(BuildContext context) async {
    try {
      final repo = context.read<TimeTrackingRepository>();
      final csv = await repo.exportToCsv();
      final dir =
          await getDownloadsDirectory() ??
          await getApplicationDocumentsDirectory();
      final file = File(
        '${dir.path}/time_tracker_export_${DateTime.now().millisecondsSinceEpoch}.csv',
      );
      await file.writeAsString(csv);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Exported to ${file.path}')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }
}
