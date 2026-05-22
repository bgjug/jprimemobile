import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jprimemobile/core/di/injection.dart';
import 'package:jprimemobile/data/models/session.dart';
import 'package:jprimemobile/presentation/cubits/favorites_cubit.dart';
import 'package:jprimemobile/presentation/cubits/sessions_cubit.dart';
import 'package:jprimemobile/presentation/screens/session_detail_screen.dart';
import 'package:jprimemobile/presentation/widgets/current_time_indicator.dart';
import 'package:jprimemobile/presentation/widgets/session_card.dart';

class FavoritesScreen extends StatelessWidget {
  final DateTime? selectedDate;

  const FavoritesScreen({
    super.key,
    this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<SessionsCubit>(),
        ),
      ],
      child: _FavoritesScreenContent(selectedDate: selectedDate),
    );
  }
}

class _FavoritesScreenContent extends StatefulWidget {
  final DateTime? selectedDate;

  const _FavoritesScreenContent({
    this.selectedDate,
  });

  @override
  State<_FavoritesScreenContent> createState() => _FavoritesScreenContentState();
}

class _FavoritesScreenContentState extends State<_FavoritesScreenContent> {
  final List<Session> _allSessions = [];
  bool _isLoading = false;
  Timer? _timer;
  DateTime _currentTime = DateTime.now();
  final ScrollController _scrollController = ScrollController();
  bool _hasAutoScrolled = false;

  @override
  void initState() {
    super.initState();
    _loadAllSessions();
    _startTimer();
  }

  void _startTimer() {
    // Calculate delay until the next minute starts
    final now = DateTime.now();
    final secondsUntilNextMinute = 60 - now.second;

    // Wait until the next minute, then update every minute
    Future.delayed(Duration(seconds: secondsUntilNextMinute), () {
      if (mounted) {
        // Save scroll position before updating
        final scrollPosition = _scrollController.hasClients
            ? _scrollController.offset
            : 0.0;

        setState(() {
          _currentTime = DateTime.now();
        });

        // Restore scroll position after rebuild
        if (_scrollController.hasClients && scrollPosition > 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.jumpTo(scrollPosition);
            }
          });
        }

        // Now start the periodic timer that runs every minute
        _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
          if (mounted) {
            // Save scroll position before updating
            final scrollPos = _scrollController.hasClients
                ? _scrollController.offset
                : 0.0;

            setState(() {
              _currentTime = DateTime.now();
            });

            // Restore scroll position after rebuild
            if (_scrollController.hasClients && scrollPos > 0) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  _scrollController.jumpTo(scrollPos);
                }
              });
            }
          }
        });
      }
    });
  }

  @override
  void didUpdateWidget(_FavoritesScreenContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload if the date changed
    if (widget.selectedDate != oldWidget.selectedDate) {
      _loadAllSessions();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentTime(List<Session> sessions) {
    if (_hasAutoScrolled || !_scrollController.hasClients) return;

    // Wait for the list to be built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;

      final now = _currentTime;
      final sortedSessions = List<Session>.from(sessions)
        ..sort((a, b) => a.startTime.compareTo(b.startTime));

      double scrollPosition = 0;
      const double cardHeight = 130.0; // Approximate height including margin
      const double indicatorHeight = 56.0; // Height of time indicator

      for (int i = 0; i < sortedSessions.length; i++) {
        final session = sortedSessions[i];
        final indicatorPosition = _getIndicatorPosition(session, now);

        if (indicatorPosition != null) {
          // Current time is inside this session - scroll to it
          scrollPosition += cardHeight / 2; // Center the card
          break;
        }

        final sessionTime = DateTime(
          now.year,
          now.month,
          now.day,
          session.startTime.hour,
          session.startTime.minute,
        );
        final currentTime = DateTime(
          now.year,
          now.month,
          now.day,
          now.hour,
          now.minute,
        );

        if (currentTime.isBefore(sessionTime)) {
          // Current time is before this session - scroll to show indicator
          scrollPosition += indicatorHeight / 2;
          break;
        }

        scrollPosition += cardHeight;
      }

      // Scroll to the calculated position with animation
      if (scrollPosition > 0) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final targetScroll = (scrollPosition - 200).clamp(0.0, maxScroll);

        _scrollController.animateTo(
          targetScroll,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }

      _hasAutoScrolled = true;
    });
  }

  Future<void> _loadAllSessions() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    final halls = ['hall A', 'hall B', 'workshops'];
    final allSessions = <Session>[];

    for (final hall in halls) {
      if (!mounted) return;

      final cubit = context.read<SessionsCubit>();
      await cubit.loadSessions(hall, date: widget.selectedDate);

      final state = cubit.state;
      state.whenOrNull(
        loaded: (sessions) => allSessions.addAll(sessions),
      );
    }

    if (!mounted) return;

    setState(() {
      _allSessions.clear();
      _allSessions.addAll(allSessions);
      _isLoading = false;
    });
  }

  TimeIndicatorPosition? _getIndicatorPosition(Session session, DateTime currentTime) {
    final sessionStart = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      session.startTime.hour,
      session.startTime.minute,
    );
    final sessionEnd = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      session.endTime.hour,
      session.endTime.minute,
    );
    final now = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      currentTime.hour,
      currentTime.minute,
    );

    // Check if current time is within this session (inclusive of start, exclusive of end)
    if ((now.isAtSameMomentAs(sessionStart) || now.isAfter(sessionStart)) && now.isBefore(sessionEnd)) {
      final sessionDuration = sessionEnd.difference(sessionStart).inMinutes;
      final elapsedTime = now.difference(sessionStart).inMinutes;

      // If within first 5 minutes or first 20% of session, show at start
      if (elapsedTime <= 5 || elapsedTime < sessionDuration * 0.2) {
        return TimeIndicatorPosition.start;
      }
      // If within last 5 minutes or last 20% of session, show at end
      else if ((sessionEnd.difference(now).inMinutes <= 5) ||
               (elapsedTime > sessionDuration * 0.8)) {
        return TimeIndicatorPosition.end;
      }
      // Otherwise show in middle
      else {
        return TimeIndicatorPosition.middle;
      }
    }

    return null;
  }

  List<Widget> _buildSessionListWithTimeIndicator(List<Session> sessions) {
    final widgets = <Widget>[];
    final now = _currentTime;

    // Sort sessions by start time
    final sortedSessions = List<Session>.from(sessions)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    bool indicatorAdded = false;

    for (int i = 0; i < sortedSessions.length; i++) {
      final session = sortedSessions[i];

      // Check if indicator should be shown inside this session
      final indicatorPosition = _getIndicatorPosition(session, now);

      if (indicatorPosition != null) {
        // Show indicator inside the session card
        widgets.add(
          SessionCard(
            session: session,
            showTimeIndicator: indicatorPosition,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<FavoritesCubit>(),
                    child: SessionDetailScreen(session: session),
                  ),
                ),
              );
            },
          ),
        );
        indicatorAdded = true;
      } else {
        // Check if we should add the time indicator before this session
        if (!indicatorAdded) {
          final sessionTime = DateTime(
            now.year,
            now.month,
            now.day,
            session.startTime.hour,
            session.startTime.minute,
          );
          final currentTime = DateTime(
            now.year,
            now.month,
            now.day,
            now.hour,
            now.minute,
          );

          if (currentTime.isBefore(sessionTime)) {
            widgets.add(const CurrentTimeIndicator());
            indicatorAdded = true;
          }
        }

        widgets.add(
          SessionCard(
            session: session,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<FavoritesCubit>(),
                    child: SessionDetailScreen(session: session),
                  ),
                ),
              );
            },
          ),
        );
      }
    }

    // If indicator wasn't added yet, add it at the end
    if (!indicatorAdded && sortedSessions.isNotEmpty) {
      widgets.add(const CurrentTimeIndicator());
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, favState) {
        if (_isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (favState.favoriteIds.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.star_border,
                  size: 64,
                  color: Colors.white38,
                ),
                const SizedBox(height: 16),
                Text(
                  'No favorite sessions yet',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white60,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the star icon on any session to add it to favorites',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final favoriteSessions = _allSessions
            .where((session) => favState.favoriteIds.contains(session.id))
            .toList();

        // Sort by start time
        favoriteSessions.sort((a, b) => a.startTime.compareTo(b.startTime));

        if (favoriteSessions.isEmpty && _allSessions.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.refresh,
                  size: 64,
                  color: Colors.white38,
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading favorite sessions...',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white60,
                      ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadAllSessions,
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        // Auto-scroll to current time on first load
        if (favoriteSessions.isNotEmpty) {
          _scrollToCurrentTime(favoriteSessions);
        }

        final sessionWidgets = favoriteSessions.isNotEmpty
            ? _buildSessionListWithTimeIndicator(favoriteSessions)
            : <Widget>[];

        return RefreshIndicator(
          onRefresh: _loadAllSessions,
          child: favoriteSessions.isEmpty
              ? ListView(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: Text(
                          'Pull to refresh',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white60,
                              ),
                        ),
                      ),
                    ),
                  ],
                )
              : ListView(
                  key: ValueKey('${_currentTime.hour}:${_currentTime.minute}'),
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: sessionWidgets,
                ),
        );
      },
    );
  }
}
