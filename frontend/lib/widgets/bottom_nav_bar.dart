import 'package:flutter/material.dart';
import '../theme.dart';

class SYEBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const SYEBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: onTap,
            backgroundColor: Colors.transparent,
            elevation: 0,
            indicatorColor: AppTheme.paleGreen,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon:
                    Icon(Icons.home_rounded, color: AppTheme.darkGreen),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.spa_outlined),
                selectedIcon:
                    Icon(Icons.spa_rounded, color: AppTheme.darkGreen),
                label: 'Harvests',
              ),
              NavigationDestination(
                icon: Icon(Icons.storefront_outlined),
                selectedIcon:
                    Icon(Icons.storefront_rounded, color: AppTheme.darkGreen),
                label: 'Markets',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon:
                    Icon(Icons.person_rounded, color: AppTheme.darkGreen),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
