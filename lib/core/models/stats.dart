class Stats {
  const Stats({
    required this.hp,
    required this.att,
    required this.def,
    required this.spa,
    required this.spd,
    required this.spe,
  });

  final int hp, att, def, spa, spd, spe;

  int get totalBST => hp + att + def + spa + spd + spe;

  static int championHpValue({required int baseStat, required int spValue}) =>
      baseStat + spValue + 75;

  static int championOtherStatValue({
    required int baseStat,
    required int spValue,
    double alignment = 1.0,
  }) => ((baseStat + spValue + 20) * alignment).floor();

  static int championSpFromEv(int ev) => ev == 0 ? 0 : ((ev - 4) ~/ 8) + 1;

  static int championMinEvForSp(int sp) =>
      sp == 0 ? 0 : (sp == 32 ? 252 : (sp * 8) - 4);

  static int championMaxEvForSp(int sp) =>
      sp == 0 ? 0 : (sp == 32 ? 252 : sp * 8);

  static int championCanonicalEvForSp(int sp) => championMinEvForSp(sp);

  static double stageMultiplier(int stage) {
    return switch (stage) {
      -6 => 2 / 8,
      -5 => 2 / 7,
      -4 => 2 / 6,
      -3 => 2 / 5,
      -2 => 2 / 4,
      -1 => 2 / 3,
      0 => 1.0,
      1 => 3 / 2,
      2 => 4 / 2,
      3 => 5 / 2,
      4 => 6 / 2,
      5 => 7 / 2,
      6 => 8 / 2,
      _ => 1.0,
    };
  }

  static int championSpeedValue({
    required int baseSpeed,
    required int spValue,
    double alignment = 1.0,
    int stage = 0,
    bool hasAbilityBoost = false,
    bool hasChoiceScarf = false,
    bool hasTailwind = false,
    bool hasParalysis = false,
  }) {
    double speed = championOtherStatValue(
      baseStat: baseSpeed,
      spValue: spValue,
      alignment: alignment,
    ).toDouble();
    speed *= stageMultiplier(stage);
    if (hasAbilityBoost) {
      speed *= 2;
    }
    if (hasChoiceScarf) {
      speed *= 2;
    }
    if (hasTailwind) {
      speed *= 2;
    }
    if (hasParalysis) {
      speed *= 0.5;
    }
    return speed.floor();
  }
}
