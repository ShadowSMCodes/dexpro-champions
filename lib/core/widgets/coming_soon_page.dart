import 'package:dexpro/core/models/pokemon.dart' as dex;
import 'package:dexpro/core/models/pokemon_list_item.dart';
import 'package:flutter/material.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<PokemonListItem> featuredPokemon = _featuredPokemon();

    return Column(
      key: ValueKey<String>('coming-soon-$title'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            fontFamily: 'RobotoCondensed',
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'More tools are being prepared for competitive planning.',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontFamily: 'RobotoCondensed',
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children: featuredPokemon
                      .map(
                        (PokemonListItem entry) => Container(
                          width: 116,
                          height: 116,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            color: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.28),
                          ),
                          child: Image.asset(
                            '${entry.assetImagePath}.png',
                            fit: BoxFit.contain,
                            errorBuilder:
                                (
                                  BuildContext context,
                                  Object error,
                                  StackTrace? stackTrace,
                                ) => Icon(
                                  Icons.catching_pokemon_rounded,
                                  size: 48,
                                  color: theme.colorScheme.primary,
                                ),
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
                const SizedBox(height: 28),
                Text(
                  'Coming Soon',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontFamily: 'RobotoCondensed',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<PokemonListItem> _featuredPokemon() {
    const List<String> preferredSlugs = <String>[
      'pikachu',
      'charizard',
      'lucario',
    ];

    final List<PokemonListItem> preferred = preferredSlugs
        .where(dex.pokemonList.containsKey)
        .map(
          (String slug) =>
              PokemonListItem(slug: slug, pokemon: dex.pokemonList[slug]!),
        )
        .toList(growable: false);

    if (preferred.isNotEmpty) {
      return preferred;
    }

    return dex.pokemonList.entries
        .take(3)
        .map(
          (MapEntry<String, dex.Pokemon> entry) =>
              PokemonListItem(slug: entry.key, pokemon: entry.value),
        )
        .toList(growable: false);
  }
}
