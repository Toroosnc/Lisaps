import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'screens/home_shell.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const LisapsApp());
}
class LisapsApp extends StatefulWidget {
  const LisapsApp({super.key});
  @override
  State<LisapsApp> createState() => _LisapsAppState();
}

class _LisapsAppState extends State<LisapsApp> {
  late final TaskProvider _taskProvider;
  @override
  void initState() {
    super.initState();
    _taskProvider = TaskProvider();
    _taskProvider.load();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _taskProvider,
      child: MaterialApp(
        title: 'Lisaps',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const HomeShell(),
        ),
      );
  }
}