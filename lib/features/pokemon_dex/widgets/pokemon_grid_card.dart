import 'package:dexpro/core/models/pokemon_list_item.dart';
import 'package:flutter/material.dart';

class PokemonGridCard extends StatelessWidget {
  const PokemonGridCard({
    super.key,
    required this.entry,
    required this.onTap,
  });

  final PokemonListItem entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(
                      '${entry.assetImagePath}.png',
                      fit: BoxFit.contain,
                      errorBuilder:
                          (
                            BuildContext context,
                            Object error,
                            StackTrace? stackTrace,
                          ) {
                            return Icon(
                              Icons.catching_pokemon_rounded,
                              size: 52,
                              color: theme.colorScheme.primary,
                            );
                          },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                entry.displayName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
