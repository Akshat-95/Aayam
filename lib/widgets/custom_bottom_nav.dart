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

  Alignment _alignmentForIndex(int index, int count) {
    if (count <= 1) return Alignment.center;
    final double step = 2 / (count - 1); // from -1 to 1 inclusive
    final double x = -1 + (index * step);
    return Alignment(x, 0);
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    bool isActive = false,
    bool isSpecial = false,
  }) {
    final bool showActive =
        isActive && !widget.transientIndices.contains(index);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressedIndex = index),
      onTapUp: (_) {
        setState(() => _pressedIndex = null);
        widget.onTap(index);
      },
      onTapCancel: () => setState(() => _pressedIndex = null),
      child: AnimatedScale(
        scale: _pressedIndex == index ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: SizedBox(
          width: 56,
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: showActive ? AppColors.lightGreen : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: showActive
                        ? AppColors.primaryGreen
                        : AppColors.secondaryText,
                    size: isSpecial ? 28 : 24,
                  ),
                ),
              ),
              if (label.isNotEmpty)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 12,
                      color: showActive
                          ? AppColors.primaryGreen
                          : AppColors.secondaryText,
                      fontWeight: showActive
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    child: Text(label, textAlign: TextAlign.center),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const int itemCount = 5;
    final Alignment indicatorAlign = _alignmentForIndex(
      widget.currentIndex,
      itemCount,
    );

    return SafeArea(
      top: false,
      child: Container(
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: 72,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Sliding circular indicator
                  AnimatedAlign(
                    alignment: indicatorAlign,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: FractionallySizedBox(
                      widthFactor: 1 / itemCount,
                      child: Center(
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.lightGreen.withOpacity(0.95),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Row of nav items
                  Row(
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
                        isActive: widget.currentIndex == 1,
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
