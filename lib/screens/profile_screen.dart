import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Modern gradient header with back button and title
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
                    'Profile',
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
            // Profile avatar
            CircleAvatar(
              radius: 54,
              backgroundColor: AppColors.lightGreen,
              child: const Icon(
                Icons.person,
                size: 60,
                color: AppColors.darkGreen,
              ),
            ),
            const SizedBox(height: 16),
            // Name
            const Text(
              'Akshat Sharma',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 4),
            // Email
            const Text(
              'akshat@email.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            // Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ProfileStat(title: 'Complaints', value: '24'),
                  _ProfileStat(title: 'Resolved', value: '18'),
                  _ProfileStat(title: 'Points', value: '1200'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Edit profile button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
              ),
              icon: const Icon(Icons.edit, color: Colors.white),
              label: const Text(
                'Edit Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
            ),
            const Spacer(),
            // Logout button
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: TextButton.icon(
                icon: const Icon(Icons.logout, color: AppColors.primaryGreen),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: AppColors.primaryGreen, fontSize: 16),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String title;
  final String value;
  const _ProfileStat({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGreen,
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
