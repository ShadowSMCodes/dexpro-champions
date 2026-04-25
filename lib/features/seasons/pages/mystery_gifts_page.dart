import 'package:dexpro/app/routing/app_route_data.dart';
import 'package:dexpro/core/models/mystery_gift_event.dart';
import 'package:dexpro/core/models/pokemon_list_item.dart';
import 'package:dexpro/core/models/type.dart' as dex_type;
import 'package:flutter/material.dart';

class MysteryGiftsPage extends StatelessWidget {
  const MysteryGiftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<MysteryGiftEvent> events = mysteryGiftEvents;

    return LayoutBuilder(
      key: const ValueKey('mystery-gifts-page'),
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 15,
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Mystery Gifts',
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontFamily: 'RobotoCondensed',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Track current gift campaigns, code windows, and redemption notes.',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontFamily: 'RobotoCondensed',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 85,
              child: GridView.builder(
                itemCount: events.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth < 720
                      ? 1
                      : constraints.maxWidth < 1080
                      ? 3
                      : 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: constraints.maxWidth < 720 ? 296 : 312,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return _EventCard(event: events[index]);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MysteryGiftCardState {
  const _MysteryGiftCardState({required this.label, required this.color});

  final String label;
  final Color color;
}

class _MysteryGiftCardStateResolver {
  const _MysteryGiftCardStateResolver();

  _MysteryGiftCardState resolve(MysteryGiftEvent event) {
    return _MysteryGiftCardState(
      label: event.status.label,
      color: event.status.color,
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});

  final MysteryGiftEvent event;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final _MysteryGiftCardState state = const _MysteryGiftCardStateResolver()
        .resolve(event);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => showDialog<void>(
          context: context,
          builder: (BuildContext context) => MysteryGiftDialog(event: event),
        ),
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Image.asset(event.imagePath, fit: BoxFit.fitWidth),
              ),
            ),
            SizedBox(
              height: 116,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.redeem_rounded,
                          size: 20,
                          color: state.color,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            event.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontFamily: 'RobotoCondensed',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.circle, size: 10, color: state.color),
                        const SizedBox(width: 8),
                        Text(
                          state.label,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: state.color,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'RobotoCondensed',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.dateLabel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontFamily: 'RobotoCondensed',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MysteryGiftDialog extends StatelessWidget {
  const MysteryGiftDialog({super.key, required this.event});

  final MysteryGiftEvent event;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<PokemonListItem> featuredPokemon = _featuredPokemonEntries(
      event.featuredPokemonSlugs,
    );

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      title: Text(
        event.title,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          fontFamily: 'RobotoCondensed',
        ),
      ),
      content: SizedBox(
        width: 760,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 700),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date: ${event.dateLabel}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'RobotoCondensed',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  event.description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontFamily: 'RobotoCondensed',
                    height: 1.5,
                  ),
                ),
                if (featuredPokemon.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    event.title == 'Global Challenge 2026 | Special Roster'
                        ? 'Special Roster'
                        : 'Featured Pokémon',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontFamily: 'RobotoCondensed',
                    ),
                  ),
                  const SizedBox(height: 14),
                  _FeaturedPokemonGrid(pokemon: featuredPokemon),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

List<PokemonListItem> _featuredPokemonEntries(List<String> slugs) {
  return slugs
      .map(_pokemonEntryFromSlug)
      .whereType<PokemonListItem>()
      .toList(growable: false);
}

PokemonListItem? _pokemonEntryFromSlug(String slug) {
  return pokemonRouteTargetFromSlug(slug)?.entry;
}

class _FeaturedPokemonGrid extends StatelessWidget {
  const _FeaturedPokemonGrid({required this.pokemon});

  final List<PokemonListItem> pokemon;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columns = constraints.maxWidth < 520
            ? 3
            : constraints.maxWidth < 760
            ? 4
            : 5;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pokemon.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 112,
          ),
          itemBuilder: (BuildContext context, int index) {
            return _FeaturedPokemonTile(entry: pokemon[index]);
          },
        );
      },
    );
  }
}

class _FeaturedPokemonTile extends StatelessWidget {
  const _FeaturedPokemonTile({required this.entry});

  final PokemonListItem entry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<dex_type.Type> types = <dex_type.Type>[
      entry.pokemon.type1,
      if (entry.pokemon.type2 != null) entry.pokemon.type2!,
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.26,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            flex: 8,
            child: Center(
              child: Image.asset(entry.pokemon.imageURL, fit: BoxFit.contain),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: types
                  .map(
                    (dex_type.Type type) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Image.asset(type.imageURL, width: 24, height: 24),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        ],
      ),
    );
  }
}
