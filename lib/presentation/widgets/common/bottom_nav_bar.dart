import 'package:flutter/material.dart';

import '../../../core/config/theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.onBackground.withValues(alpha: 0.5),
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          key: Key('nav_home'),
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          key: Key('nav_explore'),
          icon: Icon(Icons.explore_outlined),
          activeIcon: Icon(Icons.explore),
          label: 'Explorer',
        ),
        BottomNavigationBarItem(
          key: Key('nav_add'),
          icon: Icon(
            Icons.add,
            size: 32,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          key: Key('nav_news'),
          icon: Icon(Icons.newspaper_outlined),
          activeIcon: Icon(Icons.newspaper),
          label: 'Actus',
        ),
        BottomNavigationBarItem(
          key: Key('nav_profile'),
          icon: Icon(Icons.person_outlined),
          activeIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}
