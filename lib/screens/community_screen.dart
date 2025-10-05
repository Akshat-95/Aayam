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

  Color _getScoreColor(double score) {
    if (score >= 0.8) return const Color(0xFF22C55E); // Green
    if (score >= 0.6) return const Color(0xFFF59E0B); // Orange
    return const Color(0xFFEF4444); // Red
  }

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
          // Modern gradient header (like notification screen)
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
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
                      'Community',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                // Optionally, add a badge or icon here if needed
              ],
            ),
          ),
          // Tab strip below header
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: SafeArea(
              top: false,
              bottom: false,
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.darkGreen, AppColors.primaryGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade700,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  letterSpacing: 0.3,
                ),
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                tabs: const [
                  Tab(text: 'Updates'),
                  Tab(text: 'Reports'),
                  Tab(text: 'Polling'),
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
        'category': i % 2 == 0 ? 'Announcement' : 'News',
        'priority': i % 3 == 0 ? 'High' : 'Normal',
      },
    );

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: updates.length,
      separatorBuilder: (_, __) => const SizedBox(height: 18),
      itemBuilder: (context, index) {
        final u = updates[index];
        final isHighPriority = u['priority'] == 'High';
        final isAnnouncement = u['category'] == 'Announcement';

        return InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(18),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.surfaceColor, AppColors.lightGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkGreen.withOpacity(0.10),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              leading: CircleAvatar(
                radius: 26,
                backgroundColor: isHighPriority
                    ? AppColors.darkGreen
                    : AppColors.primaryGreen,
                child: Icon(
                  isAnnouncement
                      ? Icons.campaign_rounded
                      : Icons.newspaper_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      u['title']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                        fontSize: 17,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                  if (isHighPriority)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.darkGreen.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'High',
                        style: TextStyle(
                          color: AppColors.darkGreen,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  u['body']!,
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 15,
                  ),
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.access_time, color: AppColors.darkGreen, size: 16),
                  const SizedBox(height: 6),
                  const Text(
                    '2 hr ago',
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportsTab() {
    final reports = [
      {
        'body': 'Sanitation Department',
        'score': 0.78,
        'icon': Icons.cleaning_services,
      },
      {'body': 'Public Works', 'score': 0.62, 'icon': Icons.construction},
      {'body': 'Electricity', 'score': 0.85, 'icon': Icons.electric_bolt},
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: reports.length,
      separatorBuilder: (_, __) => const SizedBox(height: 18),
      itemBuilder: (context, index) {
        final r = reports[index];
        final score = (r['score'] as double);
        final icon = (r['icon'] as IconData);

        return InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
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
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.surfaceColor, AppColors.lightGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkGreen.withOpacity(0.10),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              leading: CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.primaryGreen,
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      r['body'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                        fontSize: 17,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getScoreColor(score).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${(score * 100).round()}%',
                      style: TextStyle(
                        color: _getScoreColor(score),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      'Performance Score',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Custom Progress Bar
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.grey.shade100,
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Row(
                            children: [
                              Container(
                                width: constraints.maxWidth * score,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      _getScoreColor(score).withOpacity(0.8),
                                      _getScoreColor(score),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getScoreColor(
                                        score,
                                      ).withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Star Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(5, (i) {
                        final filled = (i < (score * 5).round());
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Icon(
                            filled
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: filled
                                ? _getScoreColor(score)
                                : Colors.grey.shade300,
                            size: 22,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.secondaryText,
                size: 18,
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
        'icon': Icons.park,
        'totalVotes': 0,
      },
      {
        'question': 'Which area needs urgent road repairs?',
        'options': ['North', 'East', 'South', 'West'],
        'results': {'North': 45, 'East': 30, 'South': 15, 'West': 10},
        'icon': Icons.construction_rounded,
        'totalVotes': 234,
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: polls.length,
      separatorBuilder: (_, __) => const SizedBox(height: 18),
      itemBuilder: (context, index) {
        final p = polls[index];
        final results = p['results'] as Map<String, int>?;
        final isActive = results == null;
        final icon = p['icon'] as IconData;

        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.surfaceColor, AppColors.lightGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkGreen.withOpacity(0.10),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            leading: CircleAvatar(
              radius: 26,
              backgroundColor: isActive
                  ? AppColors.primaryGreen
                  : AppColors.darkGreen,
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            title: Text(
              p['question'] as String,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
                fontSize: 17,
                letterSpacing: 0.1,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: isActive
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var opt in (p['options'] as List<String>))
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Voted for "$opt"'),
                                    backgroundColor: AppColors.primaryGreen,
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.primaryGreen.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.radio_button_off,
                                      size: 20,
                                      color: AppColors.primaryGreen,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      opt,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade800,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var entry in results.entries)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      entry.key,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '${entry.value}%',
                                      style: TextStyle(
                                        color: AppColors.primaryGreen,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  height: 8,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      final percentage =
                                          entry.value /
                                          results.values.reduce(
                                            (a, b) => a + b,
                                          );
                                      return Stack(
                                        children: [
                                          Container(
                                            width: constraints.maxWidth,
                                            color: Colors.grey.shade100,
                                          ),
                                          Container(
                                            width:
                                                constraints.maxWidth *
                                                percentage,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  AppColors.primaryGreen
                                                      .withOpacity(0.8),
                                                  AppColors.primaryGreen,
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.primaryGreen
                                                      .withOpacity(0.3),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 6),
                        Text(
                          '${p['totalVotes']} votes',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
            ),
            trailing: isActive
                ? const Icon(
                    Icons.how_to_vote_rounded,
                    color: AppColors.primaryGreen,
                    size: 22,
                  )
                : const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.darkGreen,
                    size: 22,
                  ),
          ),
        );
      },
    );
  }
}
