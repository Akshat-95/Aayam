import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/dummy_data_service.dart';
import '../models/complaint.dart';
import '../widgets/complaint_card.dart';
import 'complaint_details_screen.dart';
import '../widgets/custom_bottom_nav.dart';
import 'camera_page.dart';
import 'issues_map_page.dart';
import 'community_screen.dart';

class MyComplaintsScreen extends StatefulWidget {
  const MyComplaintsScreen({super.key});

  @override
  State<MyComplaintsScreen> createState() => _MyComplaintsScreenState();
}

class _MyComplaintsScreenState extends State<MyComplaintsScreen> {
  final List<Map<String, Object>> _filters = [
    {'label': 'All', 'icon': Icons.list},
    {'label': 'Active', 'icon': Icons.fiber_manual_record},
    {'label': 'Worker Assigned', 'icon': Icons.person},
    {'label': 'In Progress', 'icon': Icons.play_arrow},
    {'label': 'Completed', 'icon': Icons.check_circle},
    {'label': 'Closed', 'icon': Icons.remove_circle},
  ];

  String _selectedFilter = 'All';
  int _currentIndex = 3; // keep bottom nav in sync with other screens

  List<Complaint> get _allComplaints => DummyDataService.getComplaints();

  List<Complaint> get _filteredComplaints {
    if (_selectedFilter == 'All') return _allComplaints;
    switch (_selectedFilter) {
      case 'Active':
        return _allComplaints
            .where(
              (c) =>
                  c.status != ComplaintStatus.resolved &&
                  c.status != ComplaintStatus.closed,
            )
            .toList();
      case 'Worker Assigned':
        return _allComplaints
            .where((c) => c.status == ComplaintStatus.workerAssigned)
            .toList();
      case 'In Progress':
        return _allComplaints
            .where((c) => c.status == ComplaintStatus.inProgress)
            .toList();
      case 'Completed':
        return _allComplaints
            .where((c) => c.status == ComplaintStatus.resolved)
            .toList();
      case 'Closed':
        return _allComplaints
            .where((c) => c.status == ComplaintStatus.closed)
            .toList();
      default:
        return _allComplaints;
    }
  }

  void _openDetails(Complaint c) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComplaintDetailsScreen(
          imageUrl: c.imageUrl,
          date: c.dateSubmitted,
          category: c.category,
          description: c.description,
          status: c.status,
          location: c.location,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final complaints = _filteredComplaints;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // Modern gradient header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 48,
              left: 16,
              right: 24,
              bottom: 24,
            ),
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
                  tooltip: 'Back',
                ),
                const SizedBox(width: 4),
                const Text(
                  'My Complaints',
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
          // Filter chips
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            color: Colors.transparent,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((f) {
                  final label = f['label'] as String;
                  final icon = f['icon'] as IconData;
                  final selected = _selectedFilter == label;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ChoiceChip(
                      avatar: Icon(
                        icon,
                        size: 18,
                        color: selected
                            ? Colors.white
                            : AppColors.secondaryText,
                      ),
                      label: Text(label),
                      selected: selected,
                      onSelected: (_) =>
                          setState(() => _selectedFilter = label),
                      selectedColor: AppColors.primaryGreen,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: selected
                            ? Colors.white
                            : AppColors.secondaryText,
                      ),
                      elevation: selected ? 2 : 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // List
          Expanded(
            child: Container(
              decoration: const BoxDecoration(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: complaints.length,
                itemBuilder: (context, index) {
                  final c = complaints[index];
                  return ComplaintCard(
                    complaint: c,
                    onTap: () => _openDetails(c),
                  );
                },
              ),
            ),
          ),
        ],
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
          if (index == 3) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CommunityScreen()),
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
          }
        },
      ),
    );
  }

  // Helpers removed: formatting and status badge handled by ComplaintCard
}
