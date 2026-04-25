import 'package:dexpro/app/routing/app_navigation.dart';
import 'package:dexpro/core/models/mystery_gift_event.dart';
import 'package:flutter/material.dart';

class MysteryGiftDetailsPage extends StatelessWidget {
  const MysteryGiftDetailsPage({super.key, required this.event});

  final MysteryGiftEvent event;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final MysteryGiftStatus status = event.status;

    return SingleChildScrollView(
      key: ValueKey<String>('mystery-gift-${event.title}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: () => goBackOrReplace(context, '/events'),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Back to Events'),
          ),
          const SizedBox(height: 12),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(event.imagePath, fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              event.title,
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontFamily: 'RobotoCondensed',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle, size: 12, color: status.color),
                              const SizedBox(width: 8),
                              Text(
                                status.label,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: status.color,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'RobotoCondensed',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        event.dateLabel,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontFamily: 'RobotoCondensed',
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        event.description,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          fontFamily: 'RobotoCondensed',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
