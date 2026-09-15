import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'today_tasks_screen.dart';
import 'calendar_screen.dart';
import 'projects_screen.dart';
import 'settings_screen.dart';
import 'add_task_screen.dart';

// Shell Awal
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}
class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final _screens = const [
    TodayTasksScreen(),
    CalendarScreen(),
    ProjectsScreen(),
    SettingsScreen(),
  ];

  void _openAddTask() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddTaskScreen()),
    );
  }
  @override
  Widget build(BuildContext context) {
    // _index 2 dan 3 dipakai untuk Proyek & Setelan; posisi ke-2 di nav
    // (indeks 2 visual) adalah tombol tambah, jadi kita map manual.
    final navIndexToScreen = [0, 1, 2, 3];
    return Scaffold(
      body: IndexedStack(
        index: navIndexToScreen[_index],
        children: _screens,
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        onAddTap: _openAddTask,
      ),
    );
  }
}
