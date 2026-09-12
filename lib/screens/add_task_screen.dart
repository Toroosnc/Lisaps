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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Tugas Baru', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _label('Judul Tugas'),
            TextField(
              controller: _titleController,
              decoration: _inputDecoration('Ketik tugas...'),
              autofocus: true,
            ),
            const SizedBox(height: 20),
            _label ('Proyek/Kategori'),
            TextField(
              controller: _projectController,
              decoration: _inputDecoration('mis. Kerja, Pribadi, Kesehatan')
            ),
            const SizedBox(height: 20),
            _label('Prioritas'),
            Wrap(
              spacing: 8,
              children: TaskPriority.value.map((p){
                final selected = p == _priority;
                return ChoiceChip(
                  label: Text(p.label),
                  selected: selected,
                  onSelected: (_) => setState(() => _priority = p),
                  selectedColor: AppColors.ink,
                  backgroundColor: AppColors.chip,
                  labelStyle: TextStylr(
                    color: selected ? Colors.white : AppColors.ink,
                    fontSize: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                    side: BorderSide.none,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _PickerTile(
                    icon: Icons.calendar_today_outlined,
                    label: '${_date.day}/${_date.month}/${_date.year}',
                    onTap: _pickDate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PickerTile(
                    icon: Icons.access_time,
                    label: _time.format(context),
                    onTap: _pickTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Simpan Tugas'),
              ),
            ),
          ],
        ),
      ),
    );
    //add another after this
  }
}