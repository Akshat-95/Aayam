import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/header_section.dart';
import '../widgets/feature_cards_grid.dart';
import '../widgets/near_you_section.dart';
import '../widgets/custom_bottom_nav.dart';
import 'camera_page.dart';
import 'issues_map_page.dart';
import 'community_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // Header section
          const HeaderSection(),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Feature cards grid
                  const FeatureCardsGrid(),

                  const SizedBox(height: 20),

                  // Near you section
                  const NearYouSection(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        transientIndices: const {1, 2},
        onTap: (index) async {
          // If the tapped index is transient (map), don't permanently change currentIndex
          if (index == 1) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const IssuesMapPage()),
            );
            return;
          }

          // Community tab (people icon)
          if (index == 3) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CommunityScreen()),
            );
            return;
          }

          final prev = _currentIndex;
          setState(() {
            _currentIndex = index;
          });

          // Navigate to camera page when camera button is tapped
          if (index == 2) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CameraPage()),
            );
            if (mounted) setState(() => _currentIndex = prev);
          }
        },
      ),
    );
  }
}
