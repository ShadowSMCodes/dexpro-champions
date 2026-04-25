import 'package:dexpro/app/routing/app_navigation.dart';
import 'package:dexpro/core/models/online_competition.dart';
import 'package:dexpro/core/models/pokemon_list_item.dart';
import 'package:flutter/material.dart';

class OnlineCompetitionDetailsPage extends StatelessWidget {
  const OnlineCompetitionDetailsPage({super.key, required this.competition});

  final OnlineCompetition competition;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isCompact = MediaQuery.sizeOf(context).width < 900;

    return LayoutBuilder(
      key: ValueKey<String>('online-competition-${competition.name}'),
      builder: (BuildContext context, BoxConstraints constraints) {
        final OnlineCompetitionStatus status = competition.status;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () => goBackOrReplace(context, '/events'),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Back to Events'),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          competition.name,
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: isCompact ? 26 : null,
                            letterSpacing: 1,
                            fontFamily: 'RobotoCondensed',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 12, color: status.color),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              status.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: isCompact ? 18 : null,
                                color: status.color,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'RobotoCondensed',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (isCompact)
                Column(
                  children: [
                    SizedBox(
                      height: 620,
                      child: _CompetitionInfoSection(
                        competition: competition,
                        isCompact: isCompact,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 520,
                      child: _AllowedPokemonSection(
                        competition: competition,
                        isCompact: isCompact,
                        maxWidth: constraints.maxWidth,
                      ),
                    ),
                  ],
                )
              else
                SizedBox(
                  height: 700,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _CompetitionInfoSection(
                          competition: competition,
                          isCompact: isCompact,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _AllowedPokemonSection(
                          competition: competition,
                          isCompact: isCompact,
                          maxWidth: constraints.maxWidth / 2,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _CompetitionInfoSection extends StatelessWidget {
  const _CompetitionInfoSection({
    required this.competition,
    required this.isCompact,
  });

  final OnlineCompetition competition;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 260,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: double.infinity,
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.28,
                  ),
                  child: competition.imageAssetPath == null
                      ? Icon(
                          Icons.emoji_events_rounded,
                          size: 86,
                          color: theme.colorScheme.primary,
                        )
                      : Image.asset(
                          competition.imageAssetPath!,
                          fit: isCompact ? BoxFit.fitWidth : BoxFit.fitHeight,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: LayoutBuilder(
                builder:
                    (BuildContext context, BoxConstraints detailConstraints) {
                      return SingleChildScrollView(
                        child: SizedBox(
                          width: detailConstraints.maxWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Competition Details',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'RobotoCondensed',
                                ),
                              ),
                              const SizedBox(height: 12),
                              _DetailLine(
                                label: 'Battle Format',
                                value: competition.battleFormat,
                              ),
                              const SizedBox(height: 8),
                              _DetailLine(
                                label: 'Registration',
                                value: competition.registrationDateLabel,
                              ),
                              const SizedBox(height: 8),
                              _DetailLine(
                                label: 'Battles',
                                value: competition.battleDateLabel,
                              ),
                              const SizedBox(height: 8),
                              _DetailLine(
                                label: 'Description',
                                value: competition.description,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Gifts',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'RobotoCondensed',
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: competition.gifts
                                    .map(
                                      (CompetitionGift gift) =>
                                          _GiftTile(gift: gift),
                                    )
                                    .toList(growable: false),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w800,
            fontFamily: 'RobotoCondensed',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontFamily: 'RobotoCondensed',
          ),
        ),
      ],
    );
  }
}

class _GiftTile extends StatelessWidget {
  const _GiftTile({required this.gift});

  final CompetitionGift gift;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: 130,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 58,
            height: 58,
            child: gift.imageAssetPath == null
                ? Icon(
                    Icons.card_giftcard_rounded,
                    size: 34,
                    color: theme.colorScheme.primary,
                  )
                : Image.asset(
                    gift.imageAssetPath!,
                    fit: BoxFit.contain,
                    errorBuilder:
                        (
                          BuildContext context,
                          Object error,
                          StackTrace? stackTrace,
                        ) => Icon(
                          Icons.card_giftcard_rounded,
                          size: 34,
                          color: theme.colorScheme.primary,
                        ),
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            gift.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontFamily: 'RobotoCondensed',
            ),
          ),
        ],
      ),
    );
  }
}

class _AllowedPokemonSection extends StatelessWidget {
  const _AllowedPokemonSection({
    required this.competition,
    required this.isCompact,
    required this.maxWidth,
  });

  final OnlineCompetition competition;
  final bool isCompact;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Allowed Pokémon',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: isCompact ? 24 : null,
                fontFamily: 'RobotoCondensed',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Eligible Pokémon and Mega forms for this competition.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontFamily: 'RobotoCondensed',
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: competition.allowedPokemon.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: maxWidth < 520
                      ? 4
                      : maxWidth < 760
                      ? 5
                      : maxWidth < 980
                      ? 6
                      : 7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return _CompetitionPokemonTile(
                    entry: competition.allowedPokemon[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompetitionPokemonTile extends StatelessWidget {
  const _CompetitionPokemonTile({required this.entry});

  final PokemonListItem entry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.26,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              entry.pokemon.imageURL,
              fit: BoxFit.contain,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                    return Icon(
                      Icons.catching_pokemon_rounded,
                      size: 20,
                      color: theme.colorScheme.primary,
                    );
                  },
            ),
          ),
          const SizedBox(height: 4),
          Text(
            entry.displayName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontFamily: 'RobotoCondensed',
            ),
          ),
        ],
      ),
    );
  }
}
