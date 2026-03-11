import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fbla_connect/entities/color_pallete.dart';
import 'package:fbla_connect/tabs/calendar_tab.dart';
import 'package:fbla_connect/tabs/home_tab.dart';

class FloatingNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<FloatingNavBar> createState() => _FloatingNavBarState();
}

class _FloatingNavBarState extends State<FloatingNavBar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animations = List.generate(5, (index) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.15, 0.6 + index * 0.1, curve: Curves.easeOutBack),
        ),
      );
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.white.withOpacity(0.7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.home_rounded,
                  label: 'Home',
                  activeIcon: Icons.home_rounded,
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.calendar_month_rounded,
                  label: 'Events',
                  activeIcon: Icons.calendar_month_rounded,
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.library_books_rounded,
                  label: 'Resources',
                  activeIcon: Icons.library_books_rounded,
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  activeIcon: Icons.person_rounded,
                ),
                _buildNavItem(
                  index: 4,
                  icon: Icons.person_rounded,
                  label: 'Social',
                  activeIcon: Icons.person_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required IconData activeIcon,
  }) {
    final isSelected = widget.currentIndex == index;
    
    return AnimatedBuilder(
      animation: _animations[index],
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (_animations[index].value * 0.2),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _animationController.reset();
                _animationController.forward();
              });
              widget.onTap(index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: isSelected
                  ? BoxDecoration(
                      color: uniqueTertiaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    )
                  : null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSelected ? activeIcon : icon,
                    color: isSelected ? uniqueTertiaryColor : Colors.grey[600],
                    size: isSelected ? 28 : 24,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? uniqueTertiaryColor : Colors.grey[600],
                      fontSize: isSelected ? 12 : 10,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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
}