import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jprimemobile/core/theme/app_theme.dart';
import 'package:jprimemobile/data/models/session.dart';
import 'package:jprimemobile/presentation/cubits/favorites_cubit.dart';

class SessionDetailScreen extends StatelessWidget {
  final Session session;

  const SessionDetailScreen({
    super.key,
    required this.session,
  });

  bool _isRealTalk(String title) {
    final nonTalkKeywords = [
      'break',
      'breakfast',
      'opening',
      'lunch',
      'coffee',
      'closing',
      'registration',
      'beer and networking',
      'raffle',
    ];

    final lowerTitle = title.toLowerCase();
    return !nonTalkKeywords.any((keyword) => lowerTitle.contains(keyword));
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('EEEE, MMMM d, y');
    final startTime = timeFormat.format(session.startTime);
    final endTime = timeFormat.format(session.endTime);
    final date = dateFormat.format(session.startTime);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Details'),
        actions: [
          // Only show favorite icon for real talks
          if (_isRealTalk(session.title))
            BlocBuilder<FavoritesCubit, FavoritesState>(
              builder: (context, state) {
                final isFavorite = state.favoriteIds.contains(session.id);
                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color: isFavorite ? AppTheme.accentPurple : Colors.white,
                  ),
                  onPressed: () {
                    context.read<FavoritesCubit>().toggleFavorite(session.id);
                  },
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              session.title,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppTheme.accentPurple,
                  ),
            ),
            const SizedBox(height: 24),

            // Date & Time Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.white70),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            date,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.white70),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '$startTime - $endTime',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white70),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            session.hallName,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Lector
            if (session.lectorName != null) ...[
              const SizedBox(height: 24),
              Text(
                'Speaker',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.lightPurple,
                    ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Colors.white70, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          session.lectorName!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Description
            if (session.talkDescription != null) ...[
              const SizedBox(height: 24),
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.lightPurple,
                    ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    session.talkDescription!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ],

            // TBA Notice
            if (session.lectorName == null && session.talkDescription == null) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.white70),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'No details for this session as of right now.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
