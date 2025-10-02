import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/dummy_data_service.dart';
import '../models/complaint.dart';
import '../widgets/complaint_card.dart';
import 'complaint_details_screen.dart';
import '../widgets/custom_bottom_nav.dart';

class MyComplaintsScreen extends StatefulWidget {
  const MyComplaintsScreen({super.key});

  @override
  State<MyComplaintsScreen> createState() => _MyComplaintsScreenState();
}

class _MyComplaintsScreenState extends State<MyComplaintsScreen> {
  final List<String> _filters = [
    'All',
    'Active',
    'Worker Assigned',
    'In Progress',
    'Completed',
    'Closed',
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
                  c.status.toLowerCase() != 'resolved' &&
                  c.status.toLowerCase() != 'closed',
            )
            .toList();
      case 'Worker Assigned':
        return _allComplaints
            .where((c) => c.status.toLowerCase() == 'worker assigned')
            .toList();
      case 'In Progress':
        return _allComplaints
            .where((c) => c.status.toLowerCase() == 'in progress')
            .toList();
      case 'Completed':
        return _allComplaints
            .where((c) => c.status.toLowerCase() == 'resolved')
            .toList();
      case 'Closed':
        return _allComplaints
            .where((c) => c.status.toLowerCase() == 'closed')
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
                  final selected = _selectedFilter == f;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ChoiceChip(
                      label: Text(f),
                      selected: selected,
                      onSelected: (_) => setState(() => _selectedFilter = f),
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
        transientIndices: const {},
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }

  // Helpers removed: formatting and status badge handled by ComplaintCard
}
