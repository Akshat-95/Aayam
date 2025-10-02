import 'package:flutter/material.dart';
import '../constants/app_styles.dart';
import 'feature_card.dart';
import '../screens/camera_page.dart';
import '../screens/my_complaints_screen.dart';

class FeatureCardsGrid extends StatelessWidget {
  const FeatureCardsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // First row
          Row(
            children: [
              Expanded(
                child: FeatureCard(
                  title: 'Report Issue',
                  description: 'Raise civic problems',
                  icon: Icons.camera_alt,
                  gradientDecoration: AppStyles.innovationGradient,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CameraPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FeatureCard(
                  title: 'Issues near me',
                  description: 'Check local problems',
                  icon: Icons.location_on,
                  gradientDecoration: AppStyles.sustainabilityGradient,
                  onTap: () {
                    // Handle issues near me tap
                    print('Issues near me tapped');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Second row
          Row(
            children: [
              Expanded(
                child: FeatureCard(
                  title: 'My Complaints',
                  description: 'Track your reports',
                  icon: Icons.assignment,
                  gradientDecoration: AppStyles.efficiencyGradient,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyComplaintsScreen(),
                      ),
                    );
                    // Handle my complaints tap
                    print('My Complaints tapped');
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FeatureCard(
                  title: 'Alerts & News',
                  description: 'Stay updated',
                  icon: Icons.warning,
                  gradientDecoration: AppStyles.renewableGradient,
                  onTap: () {
                    // Handle alerts & news tap
                    print('Alerts & News tapped');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
