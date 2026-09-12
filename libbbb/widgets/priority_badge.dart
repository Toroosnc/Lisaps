import 'package:flutter/material.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';

class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  const PriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    late Color bg;
    late Color fg;
    switch (priority) {
      case TaskPriority.tinggi:
        bg = AppColors.priorityHighBg;
        fg = AppColors.priorityHighText;
        break;
      case TaskPriority.sedang:
        bg = AppColors.priorityMedBg;
        fg = AppColors.priorityMedText;
        break;
      case TaskPriority.rendah:
        bg = AppColors.priorityLowBg;
        fg = AppColors.priorityLowText;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(2)),
      child: Text(priority.label, style: AppTheme.mono(fontSize: 10, color: fg)),
    );
  }
}

class TagBadge extends StatelessWidget {
  final String label;
  const TagBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.chip,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: AppTheme.mono(fontSize: 10)),
    );
  }
}
