import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/task_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selected;
  late DateTime _weekStart;

  @override
  void initState() {
    super.initState();
    _selected = DateTime.now();
    _weekStart = _startOfWeek(_selected);
  }

  DateTime _startOfWeek(DateTime d) =>
      DateTime(d.year, d.month, d.day).subtract(Duration(days: d.weekday - 1));

  void _changeWeek(int deltaWeeks) {
    setState(() => _weekStart = _weekStart.add(Duration(days: 7 * deltaWeeks)));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final tasks = provider.tasksForDate(_selected);
    final days = List.generate(7, (i) => _weekStart.add(Duration(days: i)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalender', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => _changeWeek(-1),
                  ),
                  Expanded(
                    child: Text(
                      DateFormat('MMMM yyyy', 'id_ID').format(_weekStart),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => _changeWeek(1),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 74,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: days.map((d) {
                    final isSelected = d.year == _selected.year &&
                        d.month == _selected.month &&
                        d.day == _selected.day;
                    final dayTaskCount = provider.tasksForDate(d).length;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selected = d),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.ink : AppColors.chip,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('E', 'id_ID').format(d).substring(0, 1).toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isSelected ? Colors.white70 : AppColors.graphite,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${d.day}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white : AppColors.ink,
                                ),
                              ),
                              const SizedBox(height: 2),
                              if (dayTaskCount > 0)
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.white : AppColors.cobalt,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: tasks.isEmpty
                  ? Center(
                      child: Text(
                        'Tidak ada tugas pada\n${DateFormat('d MMMM yyyy', 'id_ID').format(_selected)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.draftingSlate),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      children: tasks
                          .map((t) => TaskCard(
                                task: t,
                                onToggle: (_) => provider.toggleDone(t.id),
                                onDismissed: () => provider.deleteTask(t.id),
                              ))
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
