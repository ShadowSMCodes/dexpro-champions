import 'package:dexpro/core/models/pokemon.dart' as dex;
import 'package:dexpro/core/models/pokemon_list_item.dart';
import 'package:dexpro/core/utils/local_date_formatter.dart';
import 'package:flutter/material.dart';

class OnlineCompetition {
  const OnlineCompetition({
    required this.name,
    required this.battleFormat,
    required this.description,
    required this.registrationStart,
    required this.registrationEnd,
    required this.battleStart,
    required this.battleEnd,
    this.imageAssetPath,
    this.gifts = const <CompetitionGift>[],
    this.allowedPokemon = const <PokemonListItem>[],
  });

  final String name;
  final String battleFormat;
  final String description;
  final DateTime registrationStart;
  final DateTime registrationEnd;
  final DateTime battleStart;
  final DateTime battleEnd;
  final String? imageAssetPath;
  final List<CompetitionGift> gifts;
  final List<PokemonListItem> allowedPokemon;

  DateTime get sortDate => registrationStart;

  String get registrationDateLabel =>
      formatLocalDateTimeRange(registrationStart, registrationEnd);

  String get battleDateLabel =>
      formatLocalDateTimeRange(battleStart, battleEnd);

  OnlineCompetitionStatus get status {
    final DateTime now = DateTime.now();

    if (now.isBefore(registrationStart)) {
      return OnlineCompetitionStatus.upcoming;
    }

    if (!now.isBefore(battleStart) && !now.isAfter(battleEnd)) {
      return OnlineCompetitionStatus.battlesActive;
    }

    if (!now.isAfter(registrationEnd)) {
      return OnlineCompetitionStatus.registrationActive;
    }

    return OnlineCompetitionStatus.elapsed;
  }
}

class CompetitionGift {
  const CompetitionGift({required this.name, this.imageAssetPath});

  final String name;
  final String? imageAssetPath;
}

enum OnlineCompetitionStatus {
  upcoming(label: 'Upcoming', color: Color(0xFFFACC15)),
  registrationActive(label: 'Registration Active', color: Color(0xFF22C55E)),
  battlesActive(label: 'Battles Active', color: Color(0xFF38BDF8)),
  elapsed(label: 'Elapsed', color: Color(0xFFEF4444));

  const OnlineCompetitionStatus({required this.label, required this.color});

  final String label;
  final Color color;
}

const Set<int> _championsChallengeAllowedDexIds = <int>{
  3,
  6,
  9,
  15,
  18,
  24,
  25,
  26,
  36,
  38,
  59,
  65,
  68,
  71,
  80,
  94,
  115,
  121,
  127,
  128,
  130,
  132,
  134,
  135,
  136,
  142,
  143,
  149,
  154,
  157,
  160,
  168,
  181,
  184,
  186,
  196,
  197,
  199,
  205,
  208,
  212,
  214,
  227,
  229,
  248,
  279,
  282,
  302,
  306,
  308,
  310,
  319,
  323,
  324,
  350,
  351,
  354,
  358,
  359,
  362,
  389,
  392,
  395,
  405,
  407,
  409,
  411,
  428,
  442,
  445,
  448,
  450,
  454,
  460,
  461,
  464,
  470,
  471,
  472,
  473,
  475,
  478,
  479,
  497,
  500,
  503,
  504,
  510,
  512,
  514,
  516,
  530,
  531,
  534,
  547,
  553,
  563,
  569,
  571,
  579,
  584,
  587,
  609,
  614,
  618,
  623,
  635,
  637,
  652,
  655,
  658,
  660,
  663,
  666,
  670,
  671,
  675,
  676,
  678,
  681,
  683,
  685,
  693,
  697,
  699,
  700,
  701,
  702,
  706,
  707,
  709,
  711,
  713,
  715,
  724,
  727,
  730,
  733,
  740,
  745,
  748,
  750,
  752,
  758,
  763,
  765,
  766,
  778,
  780,
  784,
  823,
  841,
  842,
  844,
  855,
  858,
  866,
  867,
  869,
  877,
  887,
  899,
  900,
  902,
  903,
  908,
  911,
  914,
  925,
  934,
  936,
  937,
  939,
  952,
  956,
  959,
  964,
  968,
  970,
  981,
  983,
  1013,
  1018,
  1019,
};

List<PokemonListItem> _allowedPokemonByNationalDexIds(Set<int> dexIds) {
  final List<PokemonListItem> entries = dex.pokemonList.entries
      .where((MapEntry<String, dex.Pokemon> entry) {
        return dexIds.contains(entry.value.id);
      })
      .expand((MapEntry<String, dex.Pokemon> entry) {
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

final List<OnlineCompetition> onlineCompetitions = <OnlineCompetition>[
  OnlineCompetition(
    name: 'Warm-Up Challenge',
    battleFormat: 'Doubles',
    description:
        'The Warm-Up Challenge is the first online competition and runs standard Regulation M-A rules',
    registrationStart: DateTime.utc(2026, 4, 8, 2),
    registrationEnd: DateTime.utc(2026, 4, 13, 1, 59),
    battleStart: DateTime.utc(2026, 4, 10, 2),
    battleEnd: DateTime.utc(2026, 4, 13, 1, 59),
    imageAssetPath: 'assets/seasons/warm-upchallenge.jpg',
    gifts: <CompetitionGift>[
      CompetitionGift(
        name: 'Gardevoir',
        imageAssetPath: dex.pokemonList['gardevoir']?.imageURL,
      ),
      CompetitionGift(
        name: 'Quick Coupons x100',
        imageAssetPath: 'assets/seasons/quickcoupon.png',
      ),
    ],
    allowedPokemon: _warmUpAndGlobalChallengePokemon,
  ),
  OnlineCompetition(
    name: 'Global Challenge 2026 I',
    battleFormat: 'Doubles',
    description:
        'The Global Challenge 2026 I is the second online competition\nThis competition will allow for players in Japan and Korea to earn placement for their National Championships to then win a place towards the 2025 Pokémon World Championships. The top 120 players in Japan will receive an invite to the qualifiers in May',
    registrationStart: DateTime.utc(2026, 4, 23, 2),
    registrationEnd: DateTime.utc(2026, 5, 4, 1, 59),
    battleStart: DateTime.utc(2026, 5, 1, 2),
    battleEnd: DateTime.utc(2026, 5, 4, 1, 59),
    imageAssetPath: 'assets/seasons/global_challenge_i_en.jpg',
    gifts: <CompetitionGift>[
      CompetitionGift(
        name: 'Venusaur',
        imageAssetPath: dex.pokemonList['venusaur']?.imageURL,
      ),
      CompetitionGift(
        name: 'Quick Coupons x100',
        imageAssetPath: 'assets/seasons/quickcoupon.png',
      ),
    ],
    allowedPokemon: _warmUpAndGlobalChallengePokemon,
  ),
];

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

final List<PokemonListItem> _warmUpAndGlobalChallengePokemon =
    _allowedPokemonByNationalDexIds(_championsChallengeAllowedDexIds);
