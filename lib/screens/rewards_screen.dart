import 'package:flutter/material.dart';
import '../models/league.dart';
import '../constants/app_colors.dart';

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
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // League Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isLocked ? Colors.grey[800] : AppColors.lightGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.emoji_events_rounded,
                    color: isLocked ? Colors.grey[500] : AppColors.primaryGreen,
                    size: 28,
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        league.reward,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        league.rewardDescription,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Required: ${league.requiredXP} XP',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w500,
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(text, style: TextStyle(color: color, fontSize: 13)),
          ],
        ),
      );
    }

    final isLocked = color == Colors.grey[600];
    if (isLocked) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 6),
            Text(text, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          ],
        ),
      );
    }

    // Collect state
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
