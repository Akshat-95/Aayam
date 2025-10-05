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
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // Modern gradient header
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 48, left: 16, right: 24, bottom: 24),
            decoration: BoxDecoration(
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
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Back',
                ),
                SizedBox(width: 4),
                Text(
                  'Rewards',
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
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: League.allLeagues.length,
              itemBuilder: (context, index) {
                final league = League.allLeagues[index];
                final bool isLocked = currentXP < league.requiredXP;
                final bool isCollected =
                    currentXP >= league.requiredXP &&
                    league.requiredXP <= currentLeague.requiredXP;
                return Container(
                  margin: EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.surfaceColor, AppColors.lightGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.darkGreen.withOpacity(0.10),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: isLocked
                              ? Colors.grey[300]
                              : AppColors.primaryGreen,
                          child: Icon(
                            Icons.emoji_events_rounded,
                            color: isLocked ? Colors.grey[600] : Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 16),
                        // Main content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      league.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isLocked
                                            ? Colors.grey[600]
                                            : AppColors.primaryText,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 8, top: 2),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isCollected
                                          ? AppColors.primaryGreen.withOpacity(
                                              0.15,
                                            )
                                          : Colors.grey.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      isCollected
                                          ? 'Collected'
                                          : (isLocked ? 'Locked' : 'Unlocked'),
                                      style: TextStyle(
                                        color: isCollected
                                            ? AppColors.primaryGreen
                                            : (isLocked
                                                  ? Colors.grey[600]
                                                  : AppColors.darkGreen),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
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
                              SizedBox(height: 6),
                              Text(
                                league.rewardDescription,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isLocked
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.symmetric(
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
                        // Status button (if any)
                        Padding(
                          padding: EdgeInsets.only(left: 8, top: 8),
                          child: _buildStatusButton(isLocked, isCollected),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 4, // Achievement tab index
        onTap: (index) {
          if (index == 4) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
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
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: isCollected ? Colors.grey[200] : color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(8),
      border: isCollected
          ? Border.all(color: Colors.grey[400]!, width: 1)
          : null,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 18),
        SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    ),
  );
}
