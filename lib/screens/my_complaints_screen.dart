import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/dummy_data_service.dart';
import '../models/complaint.dart';
import '../widgets/complaint_card.dart';
import 'complaint_details_screen.dart';
import '../widgets/custom_bottom_nav.dart';
import 'camera_page.dart';
import 'issues_map_page.dart';

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
      appBar: AppBar(title: const Text('My Complaints'), centerTitle: true),
      body: Column(
        children: [
          // Sort chips
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            color: Colors.white,
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
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // List
          Expanded(
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
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        transientIndices: const {1},
        onTap: (index) async {
          // If the tapped index is transient (map), don't permanently change currentIndex
          if (index == 1) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const IssuesMapPage()),
            );
            return;
          }

          final prev = _currentIndex;
          setState(() => _currentIndex = index);

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

  // Helpers removed: formatting and status badge handled by ComplaintCard
}
