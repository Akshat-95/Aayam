import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.darkGreen, AppColors.primaryGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ListTile(
              leading: const Icon(
                Icons.lock_outline,
                color: AppColors.primaryGreen,
              ),
              title: const Text('Change Password'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.notifications_active_outlined,
                color: AppColors.primaryGreen,
              ),
              title: const Text('Notifications'),
              trailing: Switch(value: true, onChanged: (v) {}),
            ),
            ListTile(
              leading: const Icon(
                Icons.language,
                color: AppColors.primaryGreen,
              ),
              title: const Text('Language'),
              trailing: const Text('English'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.palette_outlined,
                color: AppColors.primaryGreen,
              ),
              title: const Text('Theme'),
              trailing: const Text('Light'),
              onTap: () {},
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Text(
                'App version 1.0.0',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
