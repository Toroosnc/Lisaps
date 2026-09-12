import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'today_tasks_screen.dart';
import 'calendar_screen.dart';
import 'projects_screen.dart';
import 'settings_screen.dart';
import 'add_task_screen.dart';

/// Shell utama berisi bottom navigation bar 5 item persis seperti di
/// wireframe: Tugas, Kalender, (+) FAB tengah, Proyek, Setelan.
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

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAddTap;

  const _BottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.canvas,
        border: Border(top: BorderSide(color: AppColors.hairline)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            _NavItem(
              icon: Icons.check_box_outlined,
              label: 'Tugas',
              selected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavItem(
              icon: Icons.calendar_today_outlined,
              label: 'Kalender',
              selected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: onAddTap,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.ink,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 24),
                  ),
                ),
              ),
            ),
            _NavItem(
              icon: Icons.folder_open_outlined,
              label: 'Proyek',
              selected: currentIndex == 2,
              onTap: () => onTap(2),
            ),
            _NavItem(
              icon: Icons.settings_outlined,
              label: 'Setelan',
              selected: currentIndex == 3,
              onTap: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.ink : AppColors.draftingSlate;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTheme.mono(
                fontSize: 10,
                color: color,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
