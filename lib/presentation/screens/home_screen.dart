import 'package:flutter/material.dart';
import 'package:jprimemobile/core/theme/app_theme.dart';
import 'package:jprimemobile/presentation/screens/favorites_screen.dart';
import 'package:jprimemobile/presentation/screens/hall_sessions_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<_NavigationTab> _tabs = [
    _NavigationTab(
      label: 'Hall A',
      icon: Icons.meeting_room,
      screen: const HallSessionsScreen(hallName: 'hall A'),
    ),
    _NavigationTab(
      label: 'Hall B',
      icon: Icons.meeting_room,
      screen: const HallSessionsScreen(hallName: 'hall B'),
    ),
    _NavigationTab(
      label: 'Workshops',
      icon: Icons.school,
      screen: const HallSessionsScreen(hallName: 'workshops'),
    ),
    _NavigationTab(
      label: 'Favorites',
      icon: Icons.star,
      screen: const FavoritesScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryPurple.withValues(alpha: 0.8),
                    AppTheme.darkPurple.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'jPrime',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _tabs[_currentIndex].label,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs.map((tab) => tab.screen).toList(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryPurple.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: _tabs
              .map(
                (tab) => BottomNavigationBarItem(
                  icon: Icon(tab.icon),
                  label: tab.label,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _NavigationTab {
  final String label;
  final IconData icon;
  final Widget screen;

  _NavigationTab({
    required this.label,
    required this.icon,
    required this.screen,
  });
}
