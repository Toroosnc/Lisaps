import 'package:flutter/material.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';
import 'priority_badge.dart';

class TaskCard extends StatelessWidget {
  final TodoTask task;
  final ValueChanged<bool> onToggle;
  final VoidCallback? onDismissed;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    this.onDismissed,
  });
  
}