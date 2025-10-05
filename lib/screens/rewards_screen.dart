import 'package:flutter/material.dart';
import '../models/league.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_bottom_nav.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentXP = 450; // TODO: Get from user data
    final currentLeague = League.getCurrentLeague(currentXP);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Rewards'),
        backgroundColor: AppColors.primaryGreen,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 4, // Achievement tab index
        onTap: (index) {
          if (index == 4) {
            Navigator.pop(context);
          }
        },
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: League.allLeagues.length,
        itemBuilder: (context, index) {
          final league = League.allLeagues[index];
          final bool isLocked = currentXP < league.requiredXP;
          final bool isCollected =
              currentXP >= league.requiredXP &&
              league.requiredXP <= currentLeague.requiredXP;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  isCollected
                      ? AppColors.lightGreen.withOpacity(0.1)
                      : Colors.white,
                  isCollected
                      ? AppColors.lightGreen.withOpacity(0.05)
                      : Colors.grey.shade50,
                ],
              ),
              border: Border.all(
                color: isCollected
                    ? AppColors.primaryGreen.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.15),
              ),
              boxShadow: [
                BoxShadow(
                  color: isCollected
                      ? AppColors.primaryGreen.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.08),
                  spreadRadius: 0,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // League Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        isLocked
                            ? Colors.grey[300]!
                            : AppColors.lightGreen.withOpacity(0.9),
                        isLocked
                            ? Colors.grey[400]!
                            : AppColors.primaryGreen.withOpacity(0.2),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: isLocked
                            ? Colors.grey.withOpacity(0.2)
                            : AppColors.primaryGreen.withOpacity(0.2),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.emoji_events_rounded,
                    color: isLocked ? Colors.grey[600] : AppColors.primaryGreen,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 14),
                // League & Reward Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        league.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isLocked ? Colors.grey[600] : Colors.black87,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        league.reward,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: isLocked
                              ? Colors.grey[500]
                              : AppColors.primaryGreen.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        league.rewardDescription,
                        style: TextStyle(
                          fontSize: 13,
                          color: isLocked ? Colors.grey[400] : Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isLocked
                              ? Colors.grey[100]
                              : AppColors.lightGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Required: ${league.requiredXP} XP',
                          style: TextStyle(
                            fontSize: 13,
                            color: isLocked
                                ? Colors.grey[600]
                                : AppColors.primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Status Button
                _buildStatusButton(isLocked, isCollected),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusButton(bool isLocked, bool isCollected) {
    if (isLocked) {
      return _buildButton(
        text: 'Locked',
        icon: Icons.lock_outline,
        color: Colors.grey[600]!,
        onTap: null,
      );
    } else if (isCollected) {
      return _buildButton(
        text: 'Collected',
        icon: Icons.check_circle_outline,
        color: Colors.grey[400]!,
        onTap: null,
        isCollected: true,
      );
    } else {
      return _buildButton(
        text: 'Collect',
        icon: Icons.card_giftcard,
        color: AppColors.primaryGreen,
        onTap: () {
          // TODO: Implement reward collection
        },
      );
    }
  }

  Widget _buildButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
    bool isCollected = false,
  }) {
    // Locked: gray, Collect: primaryGreen button, Collected: muted outline
    if (isCollected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.lightGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primaryGreen.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: AppColors.primaryGreen.withOpacity(0.8),
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: AppColors.primaryGreen.withOpacity(0.8),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    final isLocked = color == Colors.grey[600];
    if (isLocked) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    // Collect state
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryGreen,
              AppColors.primaryGreen.withOpacity(0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withOpacity(0.25),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
