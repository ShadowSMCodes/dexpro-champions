import 'package:dexpro/app/routing/app_navigation.dart';
import 'package:dexpro/core/models/season.dart';
import 'package:dexpro/core/models/pokemon_list_item.dart';
import 'package:flutter/material.dart';

class SeasonDetailsPage extends StatelessWidget {
  const SeasonDetailsPage({super.key, required this.season});

  final Season season;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isCompact = MediaQuery.sizeOf(context).width < 900;

    return LayoutBuilder(
      key: ValueKey('season-details-${season.name}'),
      builder: (BuildContext context, BoxConstraints constraints) {
        final SeasonStatus seasonStatus = season.status;
        final Color statusColor = seasonStatus.color;

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
                          season.name,
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: isCompact ? 26 : null,
                            letterSpacing: 1,
                            fontFamily: 'RobotoCondensed',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          season.dateLabel,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: isCompact ? 18 : null,
                            color: theme.colorScheme.onSurfaceVariant,
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
                          Icon(Icons.circle, size: 12, color: statusColor),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              seasonStatus.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: isCompact ? 18 : null,
                                color: statusColor,
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
                      height: 460,
                      child: _AvailablePokemonSection(
                        season: season,
                        isCompact: isCompact,
                        maxWidth: constraints.maxWidth,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 520,
                      child: _SeasonRewardsSection(
                        season: season,
                        isCompact: isCompact,
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
                        child: _SeasonRewardsSection(
                          season: season,
                          isCompact: isCompact,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _AvailablePokemonSection(
                          season: season,
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

class _AvailablePokemonSection extends StatelessWidget {
  const _AvailablePokemonSection({
    required this.season,
    required this.isCompact,
    required this.maxWidth,
  });

  final Season season;
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
              'Available Pokémon List',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: isCompact ? 24 : null,
                fontFamily: 'RobotoCondensed',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              season.availablePokemonList.isEmpty
                  ? 'TBD'
                  : 'All available Pokémon and Mega forms in this season roster.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontFamily: 'RobotoCondensed',
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: season.availablePokemonList.isEmpty
                  ? Center(
                      child: Text(
                        'TBD',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurfaceVariant,
                          fontFamily: 'RobotoCondensed',
                        ),
                      ),
                    )
                  : GridView.builder(
                      itemCount: season.availablePokemonList.length,
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
                        return _SeasonPokemonTile(
                          entry: season.availablePokemonList[index],
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

class _SeasonRewardsSection extends StatelessWidget {
  const _SeasonRewardsSection({required this.season, required this.isCompact});

  final Season season;
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
            Text(
              'Season Pass Details',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: isCompact ? 24 : null,
                fontFamily: 'RobotoCondensed',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Each rank unlocks every 100 points. Premium checkpoints are marked separately.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontFamily: 'RobotoCondensed',
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LayoutBuilder(
                builder:
                    (BuildContext context, BoxConstraints rewardConstraints) {
                      final double minTileWidth = isCompact ? 98 : 118;
                      final int crossAxisCount =
                          (rewardConstraints.maxWidth / minTileWidth)
                              .floor()
                              .clamp(2, 10);

                      return GridView.builder(
                        itemCount: season.rewards.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          mainAxisExtent: isCompact ? 150 : 174,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return _SeasonRewardTile(
                            reward: season.rewards[index],
                            isCompact: isCompact,
                          );
                        },
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

class _SeasonPokemonTile extends StatelessWidget {
  const _SeasonPokemonTile({required this.entry});

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

class _SeasonRewardTile extends StatelessWidget {
  const _SeasonRewardTile({required this.reward, required this.isCompact});

  final SeasonReward reward;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(isCompact ? 8 : 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: reward.isPremium
            ? const Color(0xFFF59E0B).withValues(alpha: 0.14)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.34),
        border: Border.all(
          color: reward.isPremium
              ? const Color(0xFFF59E0B)
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '#${reward.rank}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: isCompact ? 12 : null,
                    fontFamily: 'RobotoCondensed',
                  ),
                ),
              ),
              if (reward.isPremium)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: const Color(0xFFF59E0B),
                  ),
                  child: Text(
                    'P',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontSize: isCompact ? 9 : 10,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'RobotoCondensed',
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: isCompact ? 42 : 54,
            height: isCompact ? 42 : 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: theme.colorScheme.surface,
            ),
            child: reward.imageAssetPath != null
                ? Padding(
                    padding: const EdgeInsets.all(4),
                    child: Image.asset(
                      reward.imageAssetPath!,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (
                            BuildContext context,
                            Object error,
                            StackTrace? stackTrace,
                          ) => Icon(reward.icon, size: 24),
                    ),
                  )
                : Icon(reward.icon, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            reward.name,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: isCompact ? 11 : null,
              fontFamily: 'RobotoCondensed',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${reward.pointsRequired} pts',
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: isCompact ? 10 : null,
              color: theme.colorScheme.onSurfaceVariant,
              fontFamily: 'RobotoCondensed',
            ),
          ),
        ],
      ),
    );
  }
}
