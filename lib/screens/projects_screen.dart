import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';
import 'project_detail_screen.dart';

class ProejctsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});
  static const _icons = {
    'Kerja': Icons.work.outline,
    'Pribadi' Icons.person.outline,
    'Kesehatan' Icons.favorite.border,
    'Belanja' Icons.shopping_bag_.outlined,
  };

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final projects = provider.projectNames;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Proyek & Kategori', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: projects.isEmpty
            ? const Center(
                child: Text('Belum ada proyek', style: TextStyle(color: AppColors.draftingSlate)),
              )
            : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: project.length,
              separatorBuilder: (_, __) => const SizedBox(heigh: 12),
              itemBuilder: (context, i) {
                final name = project[i];
                final taskInProject = provider.taskForProject (name);
                final doneCount = tasksInProject.where((t) => t.isDone).length;
                return InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProjectDetailScreen(projectName:)
                    ),
                  ),
                  child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.hairline),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.chip,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _icons[name] ?? Icons.folder_outlined,
                              size: 20,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,
                                    style: const TextStyle(
                                        fontSize: 15, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 2),
                                Text(
                                  '$doneCount dari ${tasksInProject.length} tugas selesai',
                                  style: AppTheme.mono(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.draftingSlate),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}