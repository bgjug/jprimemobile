import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jprimemobile/core/theme/app_theme.dart';

class CurrentTimeIndicator extends StatelessWidget {
  const CurrentTimeIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timeFormat = DateFormat('HH:mm');
    final currentTime = timeFormat.format(now);

    return Material(
      elevation: 10, // High elevation to appear on top
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        height: 40,
        child: Row(
          children: [
            // Glassy line on the left - full width
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Glow effect
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.accentPurple.withValues(alpha: 0.0),
                          AppTheme.accentPurple.withValues(alpha: 0.5),
                          AppTheme.accentPurple.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Solid line
                  Container(
                    height: 1.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.accentPurple.withValues(alpha: 0.0),
                          AppTheme.accentPurple,
                          AppTheme.accentPurple,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(0.75),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentPurple.withValues(alpha: 0.6),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Time label with glassy background on the right
            Container(
              margin: const EdgeInsets.only(right: 56),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.accentPurple.withValues(alpha: 0.95),
                    AppTheme.primaryPurple.withValues(alpha: 0.95),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.accentPurple.withValues(alpha: 0.8),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentPurple.withValues(alpha: 0.6),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    currentTime,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

