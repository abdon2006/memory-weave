import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:memory_weave/themes/colors.dart';

class Mynav extends StatelessWidget {
  final int current_index;
  final Function(int) onTabChange;

  const Mynav({
    super.key,
    required this.current_index,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            spreadRadius: 5,
            blurRadius: 10,
            color: Colors.grey.withOpacity(0.2),
          ),
        ],
      ),
      child: SafeArea(
        child: GNav(
          tabBackgroundColor: AppColors.primaryBlue.withOpacity(0.4),
          iconSize: 24,
          padding: EdgeInsetsGeometry.symmetric(vertical: 20, horizontal: 20),
          gap: 8,
          rippleColor: Colors.grey[300]!,
          hoverColor: Colors.grey[100]!,
          activeColor: AppColors.primaryBlue,
          color: Colors.grey,

          tabs: [
            GButton(icon: Icons.home_filled, text: "Home"),
            GButton(icon: Icons.route_rounded, text: "Timeline"),
            GButton(icon: Icons.auto_awesome, text: "Memories"),
            GButton(icon: Icons.person_2_rounded, text: "Profile"),
          ],
          selectedIndex: current_index,
          onTabChange: onTabChange,
        ),
      ),
    );
  }
}
