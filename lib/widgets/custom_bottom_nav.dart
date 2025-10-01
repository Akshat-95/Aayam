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
    final bool isTransient = widget.transientIndices.contains(index);

    if (isSpecial) {
      return GestureDetector(
        onTapDown: (_) => setState(() => _pressedIndex = index),
        onTapUp: (_) => setState(() => _pressedIndex = null),
        onTapCancel: () => setState(() => _pressedIndex = null),
        onTap: () => _handleTap(index),
        child: AnimatedScale(
          scale: _pressedIndex == index ? 0.9 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.primaryGreen,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
      );
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressedIndex = index),
      onTapUp: (_) => setState(() => _pressedIndex = null),
      onTapCancel: () => setState(() => _pressedIndex = null),
      onTap: () => _handleTap(index),
      child: AnimatedScale(
        scale: _pressedIndex == index ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.lightGreen : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isActive
                      ? AppColors.primaryGreen
                      : AppColors.secondaryText,
                  size: 24,
                ),
              ),
              if (label.isNotEmpty) ...[
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive
                        ? AppColors.primaryGreen
                        : AppColors.secondaryText,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                  child: Text(label),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 144, 230, 203),
        borderRadius: BorderRadius.all(Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
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
