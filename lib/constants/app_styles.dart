import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  // Text styles
  static const TextStyle greetingText = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );

  static const TextStyle locationText = TextStyle(
    fontSize: 14,
    color: AppColors.secondaryText,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );

  static const TextStyle cardDescription = TextStyle(
    fontSize: 12,
    color: AppColors.secondaryText,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );

  static const TextStyle viewAllText = TextStyle(
    fontSize: 14,
    color: AppColors.primaryGreen,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle userNameText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );

  static const TextStyle timeText = TextStyle(
    fontSize: 12,
    color: AppColors.lightText,
  );

  static const TextStyle tagText = TextStyle(
    fontSize: 10,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  // Card styles
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration iconContainerDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(12),
  );

  // Clean & Green Technology gradient decorations
  static BoxDecoration sustainabilityGradient = BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        AppColors.sustainabilityGradientStart,
        AppColors.sustainabilityGradientEnd,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration innovationGradient = BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        AppColors.innovationGradientStart,
        AppColors.innovationGradientEnd,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration efficiencyGradient = BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        AppColors.efficiencyGradientStart,
        AppColors.efficiencyGradientEnd,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration renewableGradient = BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        AppColors.renewableGradientStart,
        AppColors.renewableGradientEnd,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
  );
}
