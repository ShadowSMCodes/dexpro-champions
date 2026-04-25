import 'package:dexpro/core/models/pokemon.dart';
import 'package:dexpro/core/models/pokemon_list_item.dart';
import 'package:dexpro/core/utils/local_date_formatter.dart';
import 'package:flutter/material.dart';

class Season {
  const Season({
    required this.name,
    required this.startDate,
    this.endDate,
    this.headerImageAssetPath,
    required this.availablePokemonList,
    required this.rewards,
  });

  final String name;
  final DateTime startDate;
  final DateTime? endDate;
  final String? headerImageAssetPath;
  final List<PokemonListItem> availablePokemonList;
  final List<SeasonReward> rewards;

  String get dateLabel => formatLocalDateTimeRange(startDate, endDate);

  bool get isUpcoming {
    final DateTime now = DateTime.now();
    return now.isBefore(startDate);
  }

  bool get isActive {
    final DateTime now = DateTime.now();
    return !now.isBefore(startDate) &&
        (endDate == null || !now.isAfter(endDate!));
  }

  bool get isElapsed {
    if (endDate == null) {
      return false;
    }

    final DateTime now = DateTime.now();
    return now.isAfter(endDate!);
  }

  SeasonStatus get status {
    if (isUpcoming) {
      return SeasonStatus.upcoming;
    }

    if (isActive) {
      return SeasonStatus.active;
    }

    return SeasonStatus.elapsed;
  }
}

enum SeasonStatus {
  upcoming(label: 'Upcoming', color: Color(0xFFFACC15)),
  active(label: 'Active', color: Color(0xFF22C55E)),
  elapsed(label: 'Elapsed', color: Color(0xFFEF4444));

  const SeasonStatus({required this.label, required this.color});

  final String label;
  final Color color;
}

class SeasonReward {
  const SeasonReward({
    required this.rank,
    required this.name,
    required this.pointsRequired,
    required this.isPremium,
    this.imageAssetPath,
    this.icon = Icons.card_giftcard_rounded,
  });

  final int rank;
  final String name;
  final int pointsRequired;
  final bool isPremium;
  final String? imageAssetPath;
  final IconData icon;
}

SeasonReward _seasonPokemonReward({
  required int rank,
  required String name,
  required String pokemonSlug,
}) {
  return SeasonReward(
    rank: rank,
    name: name,
    pointsRequired: rank * 100,
    isPremium: rank >= 2 && rank <= 30 && rank.isEven,
    imageAssetPath: pokemonList[pokemonSlug]?.imageURL,
  );
}

SeasonReward _seasonAssetReward({
  required int rank,
  required String name,
  required String imageAssetPath,
}) {
  return SeasonReward(
    rank: rank,
    name: name,
    pointsRequired: rank * 100,
    isPremium: rank >= 2 && rank <= 30 && rank.isEven,
    imageAssetPath: imageAssetPath,
  );
}

SeasonReward _seasonIconReward({
  required int rank,
  required String name,
  required IconData icon,
}) {
  return SeasonReward(
    rank: rank,
    name: name,
    pointsRequired: rank * 100,
    isPremium: rank >= 2 && rank <= 30 && rank.isEven,
    icon: icon,
  );
}

final List<SeasonReward> seasonM1Rewards = <SeasonReward>[
  _seasonAssetReward(
    rank: 1,
    name: 'Dragoninite',
    imageAssetPath: 'assets/seasons/dragoninite.png',
  ),
  _seasonPokemonReward(rank: 2, name: 'Emboar', pokemonSlug: 'emboar'),
  _seasonAssetReward(
    rank: 3,
    name: 'Quick Coupon x12',
    imageAssetPath: 'assets/seasons/quickcoupon.png',
  ),
  _seasonAssetReward(
    rank: 4,
    name: 'Emboarite',
    imageAssetPath: 'assets/seasons/emboarite.png',
  ),
  _seasonAssetReward(
    rank: 5,
    name: 'Teammate Ticket x1',
    imageAssetPath: 'assets/seasons/teammateticket.png',
  ),
  _seasonAssetReward(
    rank: 6,
    name: 'Emboar Icon',
    imageAssetPath: 'assets/seasons/emboaricon.png',
  ),
  _seasonAssetReward(
    rank: 7,
    name: 'Training Ticket x1',
    imageAssetPath: 'assets/seasons/trainingticket.png',
  ),
  _seasonAssetReward(
    rank: 8,
    name: 'Teammate Ticket x6',
    imageAssetPath: 'assets/seasons/teammateticket.png',
  ),
  _seasonAssetReward(
    rank: 9,
    name: 'Quick Coupon x12',
    imageAssetPath: 'assets/seasons/quickcoupon.png',
  ),
  _seasonPokemonReward(rank: 10, name: 'Feraligatr', pokemonSlug: 'feraligatr'),
  _seasonAssetReward(
    rank: 11,
    name: 'Teammate Ticket x1',
    imageAssetPath: 'assets/seasons/teammateticket.png',
  ),
  _seasonAssetReward(
    rank: 12,
    name: 'Feraligite',
    imageAssetPath: 'assets/seasons/feraligite.png',
  ),
  _seasonAssetReward(
    rank: 13,
    name: 'Training Ticket x1',
    imageAssetPath: 'assets/seasons/trainingticket.png',
  ),
  _seasonAssetReward(
    rank: 14,
    name: 'Feraligatr Icon',
    imageAssetPath: 'assets/seasons/feraligatricon.png',
  ),
  _seasonAssetReward(
    rank: 15,
    name: 'Quick Coupon x12',
    imageAssetPath: 'assets/seasons/quickcoupon.png',
  ),
  _seasonAssetReward(
    rank: 16,
    name: 'Training Ticket x6',
    imageAssetPath: 'assets/seasons/trainingticket.png',
  ),
  _seasonAssetReward(
    rank: 17,
    name: 'Teammate Ticket x1',
    imageAssetPath: 'assets/seasons/teammateticket.png',
  ),
  _seasonAssetReward(
    rank: 18,
    name: 'Half-Up Chignon',
    imageAssetPath: 'assets/seasons/half-upchignon.png',
  ),
  _seasonAssetReward(
    rank: 19,
    name: 'Training Ticket x1',
    imageAssetPath: 'assets/seasons/trainingticket.png',
  ),
  _seasonAssetReward(
    rank: 20,
    name: 'Canvas Sneakers Blue',
    imageAssetPath: 'assets/seasons/canvassneakersblue.png',
  ),
  _seasonAssetReward(
    rank: 21,
    name: 'Teammate Ticket x1',
    imageAssetPath: 'assets/seasons/teammateticket.png',
  ),
  _seasonAssetReward(
    rank: 22,
    name: 'Simple Quarter Socks White',
    imageAssetPath: 'assets/seasons/simplequartersockswhite.png',
  ),
  _seasonAssetReward(
    rank: 23,
    name: 'Training Ticket x1',
    imageAssetPath: 'assets/seasons/trainingticket.png',
  ),
  _seasonAssetReward(
    rank: 24,
    name: 'Wide-Leg Jeans Black',
    imageAssetPath: 'assets/seasons/wide-legjeansblack.png',
  ),
  _seasonPokemonReward(rank: 25, name: 'Meganium', pokemonSlug: 'meganium'),
  _seasonAssetReward(
    rank: 26,
    name: 'Off-shoulder Shirt White',
    imageAssetPath: 'assets/seasons/off-shouldershirtwhite.png',
  ),
  _seasonAssetReward(
    rank: 27,
    name: 'Meganiumite',
    imageAssetPath: 'assets/seasons/meganiumite.png',
  ),
  _seasonAssetReward(
    rank: 28,
    name: 'Blouson Jacket Team MZ Logo',
    imageAssetPath: 'assets/seasons/blousonjacketteammzlogo.png',
  ),
  _seasonAssetReward(
    rank: 29,
    name: 'Meganium Icon',
    imageAssetPath: 'assets/seasons/meganiumicon.png',
  ),
  _seasonAssetReward(
    rank: 30,
    name: 'Striped Trilby White',
    imageAssetPath: 'assets/seasons/stripedtrilbywhite.png',
  ),
  ...List<SeasonReward>.generate(
    20,
    (int index) => _seasonAssetReward(
      rank: index + 31,
      name: 'VP x500',
      imageAssetPath: 'assets/seasons/vp.png',
    ),
    growable: false,
  ),
];

final List<SeasonReward> seasonM2Rewards = <SeasonReward>[
  _seasonAssetReward(
    rank: 1,
    name: 'Quick Coupon x12',
    imageAssetPath: 'assets/seasons/quickcoupon.png',
  ),
  _seasonPokemonReward(rank: 2, name: 'Skarmory', pokemonSlug: 'skarmory'),
  _seasonAssetReward(
    rank: 3,
    name: 'Teammate Ticket x1',
    imageAssetPath: 'assets/seasons/teammateticket.png',
  ),
  _seasonIconReward(
    rank: 4,
    name: 'Skarmorite',
    icon: Icons.image_not_supported_rounded,
  ),
  _seasonAssetReward(
    rank: 5,
    name: 'Training Ticket x1',
    imageAssetPath: 'assets/seasons/trainingticket.png',
  ),
  _seasonIconReward(
    rank: 6,
    name: 'Skarmory Icon',
    icon: Icons.account_box_rounded,
  ),
  _seasonAssetReward(
    rank: 7,
    name: 'Quick Coupon x12',
    imageAssetPath: 'assets/seasons/quickcoupon.png',
  ),
  _seasonAssetReward(
    rank: 8,
    name: 'Training Ticket x3',
    imageAssetPath: 'assets/seasons/trainingticket.png',
  ),
  _seasonAssetReward(
    rank: 9,
    name: 'Teammate Ticket x1',
    imageAssetPath: 'assets/seasons/teammateticket.png',
  ),
  _seasonPokemonReward(rank: 10, name: 'Kangaskhan', pokemonSlug: 'kangaskhan'),
  _seasonAssetReward(
    rank: 11,
    name: 'Training Ticket x1',
    imageAssetPath: 'assets/seasons/trainingticket.png',
  ),
  _seasonIconReward(
    rank: 12,
    name: 'Kangaskhanite',
    icon: Icons.image_not_supported_rounded,
  ),
  _seasonAssetReward(
    rank: 13,
    name: 'Quick Coupon x12',
    imageAssetPath: 'assets/seasons/quickcoupon.png',
  ),
  _seasonIconReward(
    rank: 14,
    name: 'Kangaskhan Icon',
    icon: Icons.account_box_rounded,
  ),
  _seasonAssetReward(
    rank: 15,
    name: 'Teammate Ticket x1',
    imageAssetPath: 'assets/seasons/teammateticket.png',
  ),
  _seasonAssetReward(
    rank: 16,
    name: 'Teammate Ticket x6',
    imageAssetPath: 'assets/seasons/teammateticket.png',
  ),
  _seasonAssetReward(
    rank: 17,
    name: 'Training Ticket x1',
    imageAssetPath: 'assets/seasons/trainingticket.png',
  ),
  _seasonAssetReward(
    rank: 18,
    name: 'Training Ticket x6',
    imageAssetPath: 'assets/seasons/trainingticket.png',
  ),
  _seasonAssetReward(
    rank: 19,
    name: 'Quick Coupon x12',
    imageAssetPath: 'assets/seasons/quickcoupon.png',
  ),
  _seasonIconReward(
    rank: 20,
    name: 'Flyaway Short Cut',
    icon: Icons.content_cut_rounded,
  ),
  _seasonAssetReward(
    rank: 21,
    name: 'Teammate Ticket x1',
    imageAssetPath: 'assets/seasons/teammateticket.png',
  ),
  _seasonIconReward(
    rank: 22,
    name: 'Mid-Top Sneakers',
    icon: Icons.checkroom_rounded,
  ),
  _seasonAssetReward(
    rank: 23,
    name: 'Training Ticket x1',
    imageAssetPath: 'assets/seasons/trainingticket.png',
  ),
  _seasonIconReward(
    rank: 24,
    name: 'Skinny Jeans',
    icon: Icons.checkroom_rounded,
  ),
  _seasonPokemonReward(rank: 25, name: 'Gengar', pokemonSlug: 'gengar'),
  _seasonIconReward(
    rank: 26,
    name: 'V-Neck T-Shirt',
    icon: Icons.checkroom_rounded,
  ),
  _seasonIconReward(
    rank: 27,
    name: 'Gengarite',
    icon: Icons.image_not_supported_rounded,
  ),
  _seasonIconReward(
    rank: 28,
    name: 'Blouson Jacket',
    icon: Icons.checkroom_rounded,
  ),
  _seasonIconReward(
    rank: 29,
    name: 'Gengar Icon',
    icon: Icons.account_box_rounded,
  ),
  _seasonIconReward(
    rank: 30,
    name: 'Striped Trilby',
    icon: Icons.checkroom_rounded,
  ),
  ...List<SeasonReward>.generate(
    20,
    (int index) => _seasonAssetReward(
      rank: index + 31,
      name: 'VP x500',
      imageAssetPath: 'assets/seasons/vp.png',
    ),
    growable: false,
  ),
];

List<PokemonListItem> _expandSeasonPokemon() {
  final List<PokemonListItem> entries = pokemonList.entries
      .expand((MapEntry<String, Pokemon> entry) {
        final PokemonListItem base = PokemonListItem(
          slug: entry.key,
          pokemon: entry.value,
        );

        return <PokemonListItem>[
          base,
          if (entry.value.mega != null) base.variant(entry.value.mega!),
          if (entry.value.mega2 != null) base.variant(entry.value.mega2!),
        ];
      })
      .toList(growable: false);

  entries.sort((PokemonListItem a, PokemonListItem b) {
    final int idComparison = a.pokemon.id.compareTo(b.pokemon.id);
    if (idComparison != 0) {
      return idComparison;
    }

    final int formComparison = _formSortOrder(a).compareTo(_formSortOrder(b));
    if (formComparison != 0) {
      return formComparison;
    }

    return a.displayName.compareTo(b.displayName);
  });
  return entries;
}

int _formSortOrder(PokemonListItem entry) {
  final String? form = entry.pokemon.form?.toLowerCase();
  if (form == null) {
    return 0;
  }

  if (form.contains('x')) {
    return 1;
  }

  if (form.contains('y')) {
    return 2;
  }

  return 1;
}

final List<PokemonListItem> seasonPokemonList = _expandSeasonPokemon();

final List<Season> seasons = <Season>[
  Season(
    name: 'Season M-1',
    startDate: DateTime.utc(2026, 4, 8, 2),
    endDate: DateTime.utc(2026, 5, 13, 1, 59),
    headerImageAssetPath: 'assets/seasons/seasonm-1.jpg',
    availablePokemonList: seasonPokemonList,
    rewards: seasonM1Rewards,
  ),
  Season(
    name: 'Season M-2',
    startDate: DateTime.utc(2026, 5, 13, 2),
    endDate: DateTime.utc(2026, 6, 17, 1, 59),
    headerImageAssetPath: 'assets/seasons/seasonm-2.jpg',
    availablePokemonList: seasonPokemonList,
    rewards: seasonM2Rewards,
  ),
];
