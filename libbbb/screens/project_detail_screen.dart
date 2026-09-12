import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/task_card.dart';

class ProjectDetailScreen extends StatelessWidget {
  final String projectName;
  const ProjectDetailScreen({super.key, required this.projectName});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final tasks = provider.tasksForProject(projectName);

    return Scaffold(
      appBar: AppBar(title: Text(projectName, style: const TextStyle(fontWeight: FontWeight.w600))),
      body: SafeArea(
        child: tasks.isEmpty
            ? const Center(
                child: Text('Belum ada tugas di proyek ini',
                    style: TextStyle(color: AppColors.draftingSlate)),
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: tasks
                    .map((t) => TaskCard(
                          task: t,
                          onToggle: (_) => provider.toggleDone(t.id),
                          onDismissed: () => provider.deleteTask(t.id),
                        ))
                    .toList(),
              ),
      ),
    );
  }
}
