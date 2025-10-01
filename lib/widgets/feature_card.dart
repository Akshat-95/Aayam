import 'package:flutter/material.dart';
import '../constants/app_styles.dart';

class FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final BoxDecoration gradientDecoration;
  final VoidCallback? onTap;

  const FeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.gradientDecoration,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppStyles.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              width: 48,
              height: 48,
              decoration: gradientDecoration,
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 12),

            // Title
            Text(title, style: AppStyles.cardTitle),
            const SizedBox(height: 4),

            // Description
            Text(description, style: AppStyles.cardDescription),
          ],
        ),
      ),
    );
  }
}
