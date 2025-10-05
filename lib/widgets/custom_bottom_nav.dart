import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomBottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Set<int>
  transientIndices; // indices that should not change selected state

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.transientIndices = const {},
  });

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int? _pressedIndex;

  void _handleTap(int index) {
    // If index is transient, do not expect parent to change currentIndex
    widget.onTap(index);
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isActive,
    bool isSpecial = false,
  }) {
    final double iconSize = isSpecial ? 32 : 26;
    final Color activeColor = isSpecial ? Colors.white : AppColors.primaryGreen;
    final Color bgColor = isSpecial
        ? AppColors.primaryGreen
        : isActive
        ? Colors.white.withOpacity(0.18)
        : Colors.transparent;
    final List<BoxShadow> iconShadow = isActive
        ? [
            BoxShadow(
              color: AppColors.primaryGreen.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ]
        : [];

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressedIndex = index),
      onTapUp: (_) => setState(() => _pressedIndex = null),
      onTapCancel: () => setState(() => _pressedIndex = null),
      onTap: () => _handleTap(index),
      child: AnimatedScale(
        scale: _pressedIndex == index ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.all(isSpecial ? 10 : 8),
              decoration: BoxDecoration(
                gradient: isActive
                    ? LinearGradient(
                        colors: [
                          AppColors.primaryGreen.withOpacity(0.18),
                          AppColors.lightGreen.withOpacity(0.18),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: bgColor,
                shape: BoxShape.circle,
                boxShadow: iconShadow,
                border: isActive
                    ? Border.all(color: AppColors.primaryGreen, width: 1.5)
                    : null,
              ),
              child: Icon(icon, color: activeColor, size: iconSize),
            ),
            if (isActive)
              Positioned(
                bottom: 0,
                child: Container(
                  width: 24,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: LinearGradient(
                      colors: [AppColors.primaryGreen, AppColors.lightGreen],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.85),
            AppColors.lightGreen.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(28)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 32,
            spreadRadius: 2,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            icon: Icons.home,
            label: '',
            index: 0,
            isActive: widget.currentIndex == 0,
          ),
          _buildNavItem(
            icon: Icons.map,
            label: '',
            index: 1,
            isActive:
                widget.currentIndex == 1 &&
                !widget.transientIndices.contains(1),
          ),
          _buildNavItem(
            icon: Icons.camera_alt,
            label: '',
            index: 2,
            isActive: widget.currentIndex == 2,
            isSpecial: true,
          ),
          _buildNavItem(
            icon: Icons.people,
            label: '',
            index: 3,
            isActive: widget.currentIndex == 3,
          ),
          _buildNavItem(
            icon: Icons.emoji_events,
            label: '',
            index: 4,
            isActive: widget.currentIndex == 4,
          ),
        ],
      ),
    );
  }
}
