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
      body: SafeArea(
        child: provider.isLoaded
            ? ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                children: [
                  _SummaryCard(progress: progress, done: doneCount, total: total),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final f = filters[i];
                        final selected = f == _filter;
                        return ChoiceChip(
                          label: Text(f == 'Semua' ? '$f (${todayTasks.length})' : f),
                          selected: selected,
                          onSelected: (_) => setState(() => _filter = f),
                          selectedColor: AppColors.ink,
                          backgroundColor: AppColors.chip,
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : AppColors.ink,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                            side: BorderSide.none,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (visibleTasks.isEmpty)
                    const _EmptyState()
                  else
                    ...visibleTasks.map(
                      (t) => TaskCard(
                        task: t,
                        onToggle: (_) => provider.toggleDone(t.id),
                        onDismissed: () => provider.deleteTask(t.id),
                      ),
                    ),
                ],
              )
            : const Center(child: CircularProgressIndicator(color: AppColors.ink)),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final double progress;
  final int done;
  final int total;
  const _SummaryCard({required this.progress, required this.done, required this.total});

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).round();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hari Ini',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.ink)),
          const SizedBox(height: 10),
          Text('Kemajuan Aktivitas  $done dari $total tugas selesai ($pct%)',
              style: const TextStyle(fontSize: 13, color: AppColors.graphite)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.chip,
              valueColor: const AlwaysStoppedAnimation(AppColors.ink),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.hairline, style: BorderStyle.solid),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Belum ada tugas di kategori ini.\nKetuk (+) untuk menambah tugas baru.',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.draftingSlate, fontSize: 13),
      ),
    );
  }
}
