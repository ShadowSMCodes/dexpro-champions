import 'package:dexpro/core/models/ability.dart';

enum Type {
  normal,
  fire,
  water,
  grass,
  electric,
  ice,
  fighting,
  poison,
  ground,
  flying,
  psychic,
  bug,
  rock,
  ghost,
  dragon,
  steel,
  dark,
  fairy;

  String get imageURL => 'assets/types/$name.png';

  String get displayName => name[0].toUpperCase() + name.substring(1);

  List<Type> get weaknesses {
    return switch (this) {
      Type.normal => <Type>[Type.fighting],
      Type.fire => <Type>[Type.water, Type.ground, Type.rock],
      Type.water => <Type>[Type.electric, Type.grass],
      Type.grass => <Type>[
        Type.fire,
        Type.ice,
        Type.poison,
        Type.flying,
        Type.bug,
      ],
      Type.electric => <Type>[Type.ground],
      Type.ice => <Type>[Type.fire, Type.fighting, Type.rock, Type.steel],
      Type.fighting => <Type>[Type.flying, Type.psychic, Type.fairy],
      Type.poison => <Type>[Type.ground, Type.psychic],
      Type.ground => <Type>[Type.water, Type.grass, Type.ice],
      Type.flying => <Type>[Type.electric, Type.ice, Type.rock],
      Type.psychic => <Type>[Type.bug, Type.ghost, Type.dark],
      Type.bug => <Type>[Type.fire, Type.flying, Type.rock],
      Type.rock => <Type>[
        Type.water,
        Type.grass,
        Type.fighting,
        Type.ground,
        Type.steel,
      ],
      Type.ghost => <Type>[Type.ghost, Type.dark],
      Type.dragon => <Type>[Type.ice, Type.dragon, Type.fairy],
      Type.steel => <Type>[Type.fire, Type.fighting, Type.ground],
      Type.dark => <Type>[Type.fighting, Type.bug, Type.fairy],
      Type.fairy => <Type>[Type.poison, Type.steel],
    };
  }

  List<Type> get resistances {
    return switch (this) {
      Type.normal => <Type>[],
      Type.fire => <Type>[
        Type.fire,
        Type.grass,
        Type.ice,
        Type.bug,
        Type.steel,
        Type.fairy,
      ],
      Type.water => <Type>[Type.fire, Type.water, Type.ice, Type.steel],
      Type.grass => <Type>[Type.water, Type.electric, Type.grass, Type.ground],
      Type.electric => <Type>[Type.electric, Type.flying, Type.steel],
      Type.ice => <Type>[Type.ice],
      Type.fighting => <Type>[Type.bug, Type.rock, Type.dark],
      Type.poison => <Type>[
        Type.grass,
        Type.fighting,
        Type.poison,
        Type.bug,
        Type.fairy,
      ],
      Type.ground => <Type>[Type.poison, Type.rock],
      Type.flying => <Type>[Type.grass, Type.fighting, Type.bug],
      Type.psychic => <Type>[Type.fighting, Type.psychic],
      Type.bug => <Type>[Type.grass, Type.fighting, Type.ground],
      Type.rock => <Type>[Type.normal, Type.fire, Type.poison, Type.flying],
      Type.ghost => <Type>[Type.poison, Type.bug],
      Type.dragon => <Type>[Type.fire, Type.water, Type.electric, Type.grass],
      Type.steel => <Type>[
        Type.normal,
        Type.grass,
        Type.ice,
        Type.flying,
        Type.psychic,
        Type.bug,
        Type.rock,
        Type.dragon,
        Type.steel,
        Type.fairy,
      ],
      Type.dark => <Type>[Type.ghost, Type.dark],
      Type.fairy => <Type>[Type.fighting, Type.bug, Type.dark],
    };
  }

  List<Type> get immunities {
    return switch (this) {
      Type.normal => <Type>[Type.ghost],
      Type.fire => <Type>[],
      Type.water => <Type>[],
      Type.grass => <Type>[],
      Type.electric => <Type>[],
      Type.ice => <Type>[],
      Type.fighting => <Type>[],
      Type.poison => <Type>[],
      Type.ground => <Type>[Type.electric],
      Type.flying => <Type>[Type.ground],
      Type.psychic => <Type>[],
      Type.bug => <Type>[],
      Type.rock => <Type>[],
      Type.ghost => <Type>[Type.normal, Type.fighting],
      Type.dragon => <Type>[],
      Type.steel => <Type>[Type.poison],
      Type.dark => <Type>[Type.psychic],
      Type.fairy => <Type>[Type.dragon],
    };
  }

  double effectivenessAgainst(Type defender) {
    if (defender.immunities.contains(this)) {
      return 0;
    }
    if (defender.weaknesses.contains(this)) {
      return 2;
    }
    if (defender.resistances.contains(this)) {
      return 0.5;
    }
    return 1;
  }

  static double combinedEffectivenessAgainst(
    Type attacker,
    Type primaryDefender,
    Type? secondaryDefender,
  ) {
    final double primary = attacker.effectivenessAgainst(primaryDefender);
    final double secondary = secondaryDefender == null
        ? 1
        : attacker.effectivenessAgainst(secondaryDefender);
    return primary * secondary;
  }

  static double combinedEffectivenessAgainstWithAbility(
    Type attacker,
    Type primaryDefender,
    Type? secondaryDefender,
    Ability ability,
  ) {
    final double baseMultiplier = combinedEffectivenessAgainst(
      attacker,
      primaryDefender,
      secondaryDefender,
    );

    if (_isAbilityImmunity(ability, attacker)) {
      return 0;
    }

    if ((ability == Ability.solidRock || ability == Ability.filter) &&
        baseMultiplier > 1) {
      return baseMultiplier * 0.75;
    }

    if ((ability == Ability.waterBubble || ability == Ability.heatproof) &&
        attacker == Type.fire) {
      return baseMultiplier / 2;
    }

    return baseMultiplier;
  }

  static bool modifiesDefensiveMultiplier(Ability ability) {
    return switch (ability) {
      Ability.levitate ||
      Ability.lightningRod ||
      Ability.voltAbsorb ||
      Ability.motorDrive ||
      Ability.flashFire ||
      Ability.waterAbsorb ||
      Ability.sapSipper ||
      Ability.earthEater ||
      Ability.solidRock ||
      Ability.filter ||
      Ability.waterBubble ||
      Ability.heatproof => true,
      _ => false,
    };
  }

  static Type? immunityTypeFromAbility(Ability ability) {
    return switch (ability) {
      Ability.levitate || Ability.earthEater => Type.ground,
      Ability.lightningRod || Ability.voltAbsorb || Ability.motorDrive =>
        Type.electric,
      Ability.flashFire => Type.fire,
      Ability.waterAbsorb => Type.water,
      Ability.sapSipper => Type.grass,
      _ => null,
    };
  }

  static bool _isAbilityImmunity(Ability ability, Type attacker) {
    return immunityTypeFromAbility(ability) == attacker;
  }

  static String formatMultiplier(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value
        .toStringAsFixed(2)
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }
}
