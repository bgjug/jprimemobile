import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jprimemobile/core/di/injection.dart';
import 'package:jprimemobile/core/theme/app_theme.dart';
import 'package:jprimemobile/data/repositories/sessions_repository.dart';
import 'package:jprimemobile/presentation/screens/favorites_screen.dart';
import 'package:jprimemobile/presentation/screens/hall_sessions_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  DateTime? _selectedDate;
  List<DateTime> _availableDates = [];
  bool _isLoadingDates = true;

  @override
  void initState() {
    super.initState();
    _loadAvailableDates();
  }

  Future<void> _loadAvailableDates() async {
    setState(() {
      _isLoadingDates = true;
    });

    final repository = getIt<SessionsRepository>();
    final result = await repository.getAvailableDates();

    result.fold(
      (error) {
        // If we can't load dates, just continue without date filtering
        setState(() {
          _isLoadingDates = false;
        });
      },
      (dates) {
        DateTime? initialDate;
        if (dates.isNotEmpty) {
          // Try to find today's date in the available dates
          final today = DateTime.now();
          final todayDate = DateTime(today.year, today.month, today.day);

          final matchingDate = dates.firstWhere(
            (date) => date.year == todayDate.year &&
                date.month == todayDate.month &&
                date.day == todayDate.day,
            orElse: () => dates.first,
          );
          initialDate = matchingDate;
        }

        setState(() {
          _availableDates = dates;
          _selectedDate = initialDate;
          _isLoadingDates = false;
        });
      },
    );
  }

  List<_NavigationTab> _getTabs() {
    return [
      _NavigationTab(
        label: 'Hall A',
        icon: Icons.meeting_room,
        screen: HallSessionsScreen(
          hallName: 'hall A',
          selectedDate: _selectedDate,
          key: ValueKey('hall_a_$_selectedDate'),
        ),
      ),
      _NavigationTab(
        label: 'Hall B',
        icon: Icons.meeting_room,
        screen: HallSessionsScreen(
          hallName: 'hall B',
          selectedDate: _selectedDate,
          key: ValueKey('hall_b_$_selectedDate'),
        ),
      ),
      _NavigationTab(
        label: 'Workshops & Deep dives',
        icon: Icons.school,
        screen: HallSessionsScreen(
          hallName: 'workshops',
          selectedDate: _selectedDate,
          key: ValueKey('workshops_$_selectedDate'),
        ),
      ),
      _NavigationTab(
        label: 'Favorites',
        icon: Icons.star,
        screen: FavoritesScreen(
          selectedDate: _selectedDate,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final tabs = _getTabs();

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
              tabs[_currentIndex].label,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        bottom: _isLoadingDates
            ? const PreferredSize(
                preferredSize: Size.fromHeight(4),
                child: LinearProgressIndicator(),
              )
            : _availableDates.isNotEmpty
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(56),
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.center,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _availableDates.length,
                        itemBuilder: (context, index) {
                          final date = _availableDates[index];
                          final isSelected = _selectedDate != null &&
                              date.year == _selectedDate!.year &&
                              date.month == _selectedDate!.month &&
                              date.day == _selectedDate!.day;
                          final dateFormat = DateFormat('EEE, MMM d');

                          // Check if this is today
                          final today = DateTime.now();
                          final isToday = date.year == today.year &&
                              date.month == today.month &&
                              date.day == today.day;

                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedDate = date;
                                  });
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? LinearGradient(
                                            colors: [
                                              AppTheme.primaryPurple,
                                              AppTheme.accentPurple,
                                            ],
                                          )
                                        : null,
                                    color: isSelected
                                        ? null
                                        : AppTheme.darkPurple.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppTheme.accentPurple
                                          : AppTheme.primaryPurple.withValues(alpha: 0.3),
                                      width: isSelected ? 2 : 1,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: AppTheme.accentPurple.withValues(alpha: 0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isToday) ...[
                                        Icon(
                                          Icons.today,
                                          size: 16,
                                          color: isSelected ? Colors.white : AppTheme.accentPurple,
                                        ),
                                        const SizedBox(width: 6),
                                      ],
                                      Text(
                                        dateFormat.format(date),
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : Colors.white70,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : null,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: tabs.map((tab) => tab.screen).toList(),
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
          items: tabs
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
