import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/task_card.dart';

class TodayTasksScreen extends StatefulWidget {
  const TodayTasksScreen({super.key});
  @override
  State<TodayTasksScreen> createState() => _TodayTasksScreenState();
}

class _TodayTasksScreenState extends State<TodayTasksScreen> {
  String _filter = 'Semua';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final today = DateTime.now();
    final todayTasks = provider.tasksForDate(today);
    final filters = ['Semua', ...provider.projectNames];
    final visibleTasks = _filter == 'Semua'
        ? todayTasks
        : todayTasks.where((t) => t.projectName == _filter).toList();
    final doneCount = todayTasks.where((t) => t.isDone).length;
    final total = todayTasks.length;
    final progress = total == 0 ? 0.0 : doneCount / total;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            const Text('LISAPS',
                style: TextStyle(fontSize: 12, letterSpacing: 1, color: AppColors.graphite)),
            const SizedBox(width: 8),
            const Text('Today Tasks',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.ink)),
          ],
        ),
      ),
    )
  }
}