import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jprimemobile/core/di/injection.dart';
import 'package:jprimemobile/presentation/cubits/sessions_cubit.dart';
import 'package:jprimemobile/presentation/screens/session_detail_screen.dart';
import 'package:jprimemobile/presentation/widgets/session_card.dart';

class HallSessionsScreen extends StatelessWidget {
  final String hallName;

  const HallSessionsScreen({
    super.key,
    required this.hallName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SessionsCubit>()..loadSessions(hallName),
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
                        'No sessions found for $hallName',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white60,
                            ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<SessionsCubit>().loadSessions(hallName);
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    return SessionCard(
                      session: session,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SessionDetailScreen(session: session),
                          ),
                        );
                      },
                    );
                  },
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
                      context.read<SessionsCubit>().loadSessions(hallName);
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
