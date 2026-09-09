import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';

class AddTaskScreen extends StatefulWidget {
  const AddtaskScreen({super.key});
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddtaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _projectController = TextEditingController(text: 'Kerja');
  taskPriority _priority = TaskPriority.sedang;
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  @override
  void dispose() {
    _titleController.dispose();
    _projectConrtroller.dispose();
    super.dispose();
  }
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      fistDate: DateTime.now().subtract(const Duration(days: 365)),
      LastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context,
    initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }
  void _save() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul tidak boleh kosong')),
      );
      return;
    }
    final task = TodoTask(
      id: TaskProvider.newId(),
      title: _titleController.text.trim(),
      projectName: _projectController.text.trim().isEmpty
          ? 'Umum'
          : _projectController.text.trim(),
      priority: _priority,
      date: _date,
      time: '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}',
    );
    context.read<TaskProvider>().addTask(task);
    Navigator.of(context).pop();
  }
  @override
  //add after
}