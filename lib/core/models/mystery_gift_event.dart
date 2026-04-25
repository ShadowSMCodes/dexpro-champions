import 'package:flutter/material.dart';
import 'package:dexpro/core/utils/local_date_formatter.dart';

class MysteryGiftEvent {
  const MysteryGiftEvent({
    required this.title,
    required this.start,
    this.end,
    required this.imagePath,
    required this.description,
    this.featuredPokemonSlugs = const <String>[],
  });

  final String title;
  final DateTime start;
  final DateTime? end;
  final String imagePath;
  final String description;
  final List<String> featuredPokemonSlugs;

  String get dateLabel => formatLocalDateTimeRange(start, end);

  bool get isActive {
    final DateTime now = DateTime.now();
    return !now.isBefore(start) && (end == null || !now.isAfter(end!));
  }

  bool get isUpcoming {
    final DateTime now = DateTime.now();
    return now.isBefore(start);
  }

  MysteryGiftStatus get status {
    if (isUpcoming) {
      return MysteryGiftStatus.upcoming;
    }

    if (isActive) {
      return MysteryGiftStatus.active;
    }

    return MysteryGiftStatus.elapsed;
  }
}

enum MysteryGiftStatus {
  upcoming(label: 'Upcoming', color: Color(0xFFFACC15)),
  active(label: 'Active', color: Color(0xFF22C55E)),
  elapsed(label: 'Elapsed', color: Color(0xFFEF4444));

  const MysteryGiftStatus({required this.label, required this.color});

  final String label;
  final Color color;
}

final List<MysteryGiftEvent> mysteryGiftEvents = <MysteryGiftEvent>[
  MysteryGiftEvent(
    title: 'Global Challenge 2026 | Special Roster',
    start: DateTime.utc(2026, 4, 24, 2),
    end: DateTime.utc(2026, 5, 4, 1, 59),
    imagePath: 'assets/seasons/global_challenge_special_roster.jpg',
    description:
        'This update introduces a new special roster of 31 Pokémon to the Recruit Ranch in conjunction with the Global Challenge 2026 I. This list of pokémon would be in conjunction with the active VGC regulation M-A.',
    featuredPokemonSlugs: <String>[
      'venusaur',
      'charizard',
      'ninetales',
      'ninetales_alola',
      'meganium',
      'feraligatr',
      'politoed',
      'tyranitar',
      'pelipper',
      'torkoal',
      'hippowdon',
      'abomasnow',
      'emboar',
      'excadrill',
      'whimsicott',
      'vanilluxe',
      'volcarona',
      'talonflame',
      'meowstic',
      'meowstic_female',
      'aurorus',
      'incineroar',
      'lycanroc',
      'oranguru',
      'sandaconda',
      'basculegion',
      'basculegion_female',
      'maushold',
      'farigiraf',
      'archaludon',
    ],
  ),
  MysteryGiftEvent(
    title: 'JP Newsletter - Gift Machamp',
    start: DateTime.utc(2026, 4, 8, 2),
    end: DateTime.utc(2026, 8, 31, 1, 59),
    imagePath: 'assets/events/machampevent.jpg',
    description:
        'A special distribution was given in the Japanese Nintendo Newsletter. This code gives all players a Machamp. It is obtained with the code CHAMP10N',
    featuredPokemonSlugs: <String>['machamp'],
  ),
  MysteryGiftEvent(
    title: 'Launch Event - Gift Dragonite',
    start: DateTime.utc(2026, 4, 8, 2),
    end: DateTime.utc(2026, 8, 31, 1, 59),
    imagePath: 'assets/events/dragoniteevent.jpg',
    description:
        'If you play the game before August 31st 2026 on either mobile or Nintendo Switch, you will be given a special Dragonite for your collection. Players will also receive 100 Quick Coupons',
    featuredPokemonSlugs: <String>['dragonite'],
  ),
  MysteryGiftEvent(
    title: 'Legends ZA - Deposit Bonus',
    start: DateTime.utc(2026, 4, 8, 2),
    imagePath: 'assets/events/zabonuses.jpg',
    description:
        'If you deposit a Chesnaught, Delphox, Greninja or Eternal Flower Floette into Pokémon Champions that were obtained in Pokémon Legends: Z-A, you will get given the Chesnaughtite, Delphoxite, Greninjite and Floettite for free.',
  ),
];
