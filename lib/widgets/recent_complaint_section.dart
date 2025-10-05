import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../screens/my_complaints_screen.dart';
import '../services/dummy_data_service.dart';
import '../widgets/complaint_card.dart';

class RecentComplaintSection extends StatelessWidget {
  const RecentComplaintSection({super.key});

  @override
  Widget build(BuildContext context) {
    final complaints = DummyDataService.getComplaints().take(3).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Complaint', style: AppStyles.sectionTitle),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MyComplaintsScreen(),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Text('View all', style: AppStyles.viewAllText),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: AppColors.primaryGreen,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 3 recent complaints
          ...complaints.map((c) => ComplaintCard(complaint: c)).toList(),
        ],
      ),
    );
  }
}
