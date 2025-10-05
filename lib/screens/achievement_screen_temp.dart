import 'package:flutter/material.dart';
import '../models/league.dart';
import '../models/user_ranking.dart';
import '../constants/app_colors.dart';
import 'rewards_screen.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({Key? key}) : super(key: key);

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final int currentXP = 450; // TODO: Get from user data
  late League currentLeague;
  late League nextLeague;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    currentLeague = League.getCurrentLeague(currentXP);
    nextLeague = League.getNextLeague(currentXP);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        backgroundColor: AppColors.primaryGreen,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            _buildLeagueProgress(),
            const SizedBox(height: 16),
            _buildLeaderboardTabs(),
            const SizedBox(height: 12),
            Expanded(child: _buildLeaderboardContent()),
            _buildRewardsButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLeagueProgress() {
    final nextLevelXP = nextLeague.requiredXP;
    final progress = currentXP / nextLevelXP;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Current League (70%)
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current League',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  currentLeague.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '$currentXP / $nextLevelXP XP',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryGreen,
                    ),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          // Next League (30%)
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.black12, width: 1),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Next League',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nextLeague.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.black87,
        unselectedLabelColor: Colors.grey[400],
        indicator: BoxDecoration(
          color: AppColors.primaryGreen,
          borderRadius: BorderRadius.circular(8),
        ),
        tabs: const [
          Tab(text: 'League'),
          Tab(text: 'City'),
          Tab(text: 'State'),
          Tab(text: 'National'),
        ],
      ),
    );
  }

  Widget _buildLeaderboardContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildRankingList('League'),
        _buildRankingList('City'),
        _buildRankingList('State'),
        _buildRankingList('National'),
      ],
    );
  }

  Widget _buildRankingList(String scope) {
    final rankings = UserRanking.generateSampleRankings(scope);

    return ListView.builder(
      itemCount: rankings.length,
      itemBuilder: (context, index) {
        final ranking = rankings[index];
        final bgColor = ranking.isCurrentUser
            ? AppColors.lightGreen
            : Colors.white;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: Colors.grey.withOpacity(0.15)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 36,
                child: Text(
                  '#${ranking.rank}',
                  style: TextStyle(
                    color: ranking.isCurrentUser
                        ? AppColors.primaryGreen
                        : Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(backgroundImage: AssetImage(ranking.avatarUrl)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  ranking.name,
                  style: TextStyle(
                    color: ranking.isCurrentUser
                        ? Colors.black87
                        : Colors.black54,
                    fontWeight: ranking.isCurrentUser
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${ranking.xp} XP',
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRewardsButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => const RewardsScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'View Rewards',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
