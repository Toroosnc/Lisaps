import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}
 class _SettingScreenState extends State<SettingsScreen> {
  bool _notifOn = true;
  bool _streakOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setelan', style: TextStyle(fontWeight: Font Weight.w600))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container (
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.hairline),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.ink,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Icon(Icons.person, color Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pengguna Lisaps', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('Data tersimpan lokal di perangkat ini',
                          style: TextStyle(fontSize: 12, color: AppColors.graphite)),
                    ],
                  ),
                ],
              ),
            ),
            //add later
          ]
        )
      )
    )
  }
 }