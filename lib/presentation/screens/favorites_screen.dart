import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jprimemobile/core/di/injection.dart';
import 'package:jprimemobile/data/models/session.dart';
import 'package:jprimemobile/presentation/cubits/favorites_cubit.dart';
import 'package:jprimemobile/presentation/cubits/sessions_cubit.dart';
import 'package:jprimemobile/presentation/screens/session_detail_screen.dart';
import 'package:jprimemobile/presentation/widgets/session_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<SessionsCubit>(),
        ),
      ],
      child: const _FavoritesScreenContent(),
    );
  }
}

class _FavoritesScreenContent extends StatefulWidget {
  const _FavoritesScreenContent();

  @override
  State<_FavoritesScreenContent> createState() => _FavoritesScreenContentState();
}

class _FavoritesScreenContentState extends State<_FavoritesScreenContent> {
  final List<Session> _allSessions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAllSessions();
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
      await cubit.loadSessions(hall);
      
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
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: favoriteSessions.length,
                  itemBuilder: (context, index) {
                    final session = favoriteSessions[index];
                    return SessionCard(
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
                    );
                  },
                ),
        );
      },
    );
  }
}
