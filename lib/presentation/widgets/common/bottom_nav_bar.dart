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
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(
          top: BorderSide(color: scheme.outline.withValues(alpha: 0.6)),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: scheme.primary,
          unselectedItemColor: scheme.onSurfaceVariant.withValues(alpha: 0.75),
          showUnselectedLabels: true,
          backgroundColor: Colors.transparent,
          items: [
            const BottomNavigationBarItem(
              key: Key('nav_home'),
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Accueil',
            ),
            const BottomNavigationBarItem(
              key: Key('nav_explore'),
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Explorer',
            ),
            BottomNavigationBarItem(
              key: const Key('nav_add'),
              icon: _buildAddIcon(scheme, isActive: false),
              activeIcon: _buildAddIcon(scheme, isActive: true),
              label: '',
            ),
            const BottomNavigationBarItem(
              key: Key('nav_news'),
              icon: Icon(Icons.newspaper_outlined),
              activeIcon: Icon(Icons.newspaper),
              label: 'Actus',
            ),
            const BottomNavigationBarItem(
              key: Key('nav_profile'),
              icon: Icon(Icons.person_outlined),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddIcon(ColorScheme scheme, {required bool isActive}) {
    final backgroundColor = isActive ? AppColors.lagoon700 : scheme.secondary;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.add,
        size: 32,
        color: scheme.onSecondary,
      ),
    );
  }
}
