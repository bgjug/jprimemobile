import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jprimemobile/core/theme/app_theme.dart';
import 'package:jprimemobile/data/models/session.dart';
import 'package:jprimemobile/presentation/cubits/favorites_cubit.dart';
import 'package:jprimemobile/presentation/widgets/current_time_indicator.dart';

enum TimeIndicatorPosition { start, middle, end }

class SessionCard extends StatelessWidget {
  final Session session;
  final VoidCallback? onTap;
  final TimeIndicatorPosition? showTimeIndicator;

  const SessionCard({
    super.key,
    required this.session,
    this.onTap,
    this.showTimeIndicator,
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
    final startTime = timeFormat.format(session.startTime);
    final endTime = timeFormat.format(session.endTime);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Show indicator at start if needed
              if (showTimeIndicator == TimeIndicatorPosition.start)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: CurrentTimeIndicator(),
                ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      session.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.accentPurple,
                          ),
                    ),
                  ),
                  // Only show favorite icon for real talks
                  if (_isRealTalk(session.title))
                    BlocBuilder<FavoritesCubit, FavoritesState>(
                      builder: (context, state) {
                        final isFavorite = state.favoriteIds.contains(session.id);
                        return IconButton(
                          icon: Icon(
                            isFavorite ? Icons.star : Icons.star_border,
                            color: isFavorite
                                ? AppTheme.accentPurple
                                : Colors.white60,
                          ),
                          onPressed: () {
                            context.read<FavoritesCubit>().toggleFavorite(session.id);
                          },
                        );
                      },
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$startTime - $endTime',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    session.hallName,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              // Show indicator in middle if needed
              if (showTimeIndicator == TimeIndicatorPosition.middle)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: CurrentTimeIndicator(),
                ),
              if (session.lectorName != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 16,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        session.lectorName!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ],
              if (session.talkDescription != null) ...[
                const SizedBox(height: 8),
                Text(
                  session.talkDescription!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              // Show indicator at end if needed
              if (showTimeIndicator == TimeIndicatorPosition.end)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: CurrentTimeIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
