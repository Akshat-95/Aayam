import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_bottom_nav.dart';
import 'issues_map_page.dart';
import 'camera_page.dart';
import 'home_screen.dart';
import 'report_detail_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // Attractive header
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF059669), AppColors.primaryGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              // No bottom radius so color extends fully to the tabs
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.only(
              top: 36,
              left: 12,
              right: 12,
              bottom: 0,
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Community',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Tab strip outside the green header
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: SafeArea(
                      top: false,
                      bottom: false,
                      child: TabBar(
                        controller: _tabController,
                        // pill indicator
                        indicator: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        labelColor: AppColors.primaryGreen,
                        unselectedLabelColor: Colors.grey.shade600,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                        tabs: const [
                          Tab(text: 'Updates'),
                          Tab(text: 'Reports'),
                          Tab(text: 'Polling'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUpdatesTab(),
                _buildReportsTab(),
                _buildPollingTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 3,
        transientIndices: const {1, 2},
        onTap: (index) async {
          // Home
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (c) => const HomeScreen()),
            );
            return;
          }

          // Map (transient)
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => const IssuesMapPage()),
            );
            return;
          }

          // Camera (special)
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => const CameraPage()),
            );
            return;
          }

          // Other indices: do nothing for now
        },
      ),
    );
  }

  Widget _buildUpdatesTab() {
    final updates = List.generate(
      6,
      (i) => {
        'title': 'Community update #${i + 1}',
        'body': 'This is a short summary of the announcement or news item.',
      },
    );

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: updates.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final u = updates[index];
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${u['title']}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text('${u['body']}'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      '2 hr ago',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportsTab() {
    final reports = [
      {'body': 'Sanitation Department', 'score': 0.78},
      {'body': 'Public Works', 'score': 0.62},
      {'body': 'Electricity', 'score': 0.85},
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: reports.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final r = reports[index];
        final score = (r['score'] as double);
        // Make the report card tappable and open details
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Sample computation: assume received is 120 for demo
            final received = 120;
            final resolved = (score * received).round();
            final inProgress = (received * 0.1).round();
            final pending = received - resolved - inProgress;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => ReportDetailScreen(
                  department: '${r['body']}',
                  received: received,
                  resolved: resolved,
                  inProgress: inProgress,
                  pending: pending,
                ),
              ),
            );
          },
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${r['body']}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: score,
                          color: AppColors.primaryGreen,
                          backgroundColor: Colors.grey.shade200,
                          minHeight: 10,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${(score * 100).round()}%',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (i) {
                      final filled = (i < (score * 5).round());
                      return Icon(
                        filled ? Icons.star : Icons.star_border,
                        color: filled ? Colors.amber : Colors.grey,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPollingTab() {
    final polls = [
      {
        'question': 'Should the local park get upgraded facilities?',
        'options': ['Yes', 'No', 'Maybe'],
        'results': null,
      },
      {
        'question': 'Which area needs urgent road repairs?',
        'options': ['North', 'East', 'South', 'West'],
        'results': {'North': 45, 'East': 30, 'South': 15, 'West': 10},
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: polls.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final p = polls[index];
        final results = p['results'] as Map<String, int>?;
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${p['question']}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                if (results == null) ...[
                  // active poll
                  for (var opt in (p['options'] as List<String>))
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.grey),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Voted for "$opt"')),
                          );
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(opt),
                        ),
                      ),
                    ),
                ] else ...[
                  // closed poll - show result bars
                  for (var entry in results.entries)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value:
                                  entry.value /
                                  results.values.reduce((a, b) => a + b),
                              color: AppColors.primaryGreen,
                              backgroundColor: Colors.grey.shade200,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('${entry.key} — ${entry.value}%'),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
