import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';
import 'project_detail_screen.dart';

class ProejctsScreen extends StatelessWidget [
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
      //add again later
    )
  }
]