import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jprimemobile/core/di/injection.dart';
import 'package:jprimemobile/data/models/session.dart';
import 'package:jprimemobile/presentation/cubits/sessions_cubit.dart';
import 'package:jprimemobile/presentation/screens/session_detail_screen.dart';
import 'package:jprimemobile/presentation/widgets/current_time_indicator.dart';
import 'package:jprimemobile/presentation/widgets/session_card.dart';

class HallSessionsScreen extends StatefulWidget {
  final String hallName;
  final DateTime? selectedDate;

  const HallSessionsScreen({
    super.key,
    required this.hallName,
    this.selectedDate,
  });

  @override
  State<HallSessionsScreen> createState() => _HallSessionsScreenState();
}

class _HallSessionsScreenState extends State<HallSessionsScreen> {
  Timer? _timer;
  DateTime _currentTime = DateTime.now();
  final ScrollController _scrollController = ScrollController();
  bool _hasAutoScrolled = false;

  @override
  void initState() {
    super.initState();
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
                  builder: (_) => SessionDetailScreen(session: session),
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
                  builder: (_) => SessionDetailScreen(session: session),
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
    return BlocProvider(
      create: (context) => getIt<SessionsCubit>()..loadSessions(widget.hallName, date: widget.selectedDate),
      child: BlocBuilder<SessionsCubit, SessionsState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(
              child: Text('Pull to refresh'),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loaded: (sessions) {
              if (sessions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.event_busy,
                        size: 64,
                        color: Colors.white38,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No sessions found for ${widget.hallName}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white60,
                            ),
                      ),
                    ],
                  ),
                );
              }

              // Auto-scroll to current time on first load
              _scrollToCurrentTime(sessions);

              final sessionWidgets = _buildSessionListWithTimeIndicator(sessions);

              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<SessionsCubit>().loadSessions(widget.hallName, date: widget.selectedDate);
                },
                child: ListView(
                  key: ValueKey('${_currentTime.hour}:${_currentTime.minute}'),
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: sessionWidgets,
                ),
              );
            },
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading sessions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      message,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SessionsCubit>().loadSessions(widget.hallName, date: widget.selectedDate);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
