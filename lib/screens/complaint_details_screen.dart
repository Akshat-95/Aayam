import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_bottom_nav.dart';
import '../models/complaint.dart';
import 'camera_page.dart';
import 'issues_map_page.dart';
import 'community_screen.dart';

class ComplaintDetailsScreen extends StatefulWidget {
  final String imageUrl;
  final DateTime date;
  final String category;
  final String description;
  final ComplaintStatus status;
  final String location;

  const ComplaintDetailsScreen({
    super.key,
    required this.imageUrl,
    required this.date,
    required this.category,
    required this.description,
    required this.status,
    required this.location,
  });

  @override
  State<ComplaintDetailsScreen> createState() => _ComplaintDetailsScreenState();
}

class _ComplaintDetailsScreenState extends State<ComplaintDetailsScreen> {
  int _currentIndex = 3; // People tab index

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.secondaryText,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: const Text('Complaint Details'), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.lightGreen,
                    child: const Center(
                      child: Icon(
                        Icons.error_outline,
                        color: AppColors.primaryGreen,
                        size: 32,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Details section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightGreen,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      Complaint.statusToString(widget.status),
                      style: const TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Info rows
                  _buildInfoRow('Category', widget.category),
                  _buildInfoRow(
                    'Date',
                    '${widget.date.day}/${widget.date.month}/${widget.date.year}',
                  ),
                  _buildInfoRow('Location', widget.location),

                  const SizedBox(height: 16),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        transientIndices: const {1, 2},
        onTap: (index) async {
          if (index == 1) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const IssuesMapPage()),
            );
            return;
          }
          final prev = _currentIndex;
          setState(() => _currentIndex = index);
          if (index == 2) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CameraPage()),
            );
            if (mounted) setState(() => _currentIndex = prev);
            return;
          }
          if (index == 3) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CommunityScreen()),
            );
            return;
          }
          if (index != _currentIndex) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
