import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/demo_screen.dart';
import '../screens/about_screen.dart';
import '../screens/help_screen.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 48),
          // Profile icon at the top
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.lightGreen,
            child: const Icon(
              Icons.person,
              size: 48,
              color: AppColors.darkGreen,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          // Drawer items
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.play_circle_outline),
            title: const Text('Demo'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const DemoScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HelpScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('App Version'),
            subtitle: const Text('1.0.0'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
