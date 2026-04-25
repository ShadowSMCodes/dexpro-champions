enum Ability {
  chlorophyll('Boosts the Pokémon\'s Speed stat in harsh sunlight.'),
  overgrow('Powers up Grass-type moves when the Pokémon\'s HP is low.'),
  thickFat(
    'The Pokémon is protected by a layer of thick fat, which halves the damage taken from Fire- and Ice-type moves.',
  ),
  blaze('Powers up Fire-type moves when the Pokémon\'s HP is low.'),
  solarPower(
    'In harsh sunlight, the Pokémon\'s Sp. Atk stat is boosted, but its HP decreases every turn.',
  ),
  toughClaws('Powers up moves that make direct contact.'),
  drought('Turns the sunlight harsh when the Pokémon enters a battle.'),
  torrent('Powers up Water-type moves when the Pokémon\'s HP is low.'),
  rainDish('The Pokémon gradually regains HP in rain.'),
  megaLauncher('Powers up pulse moves.'),
  swarm('Powers up Bug-type moves when the Pokémon\'s HP is low.'),
  sniper(
    'If the Pokémon\'s attack lands a critical hit, the attack is powered up even further.',
  ),
  bigPecks('Prevents the Pokémon from having its Defense stat lowered.'),
  keenEye('The Pokémon\'s keen eyes prevent its accuracy from being lowered.'),
  noGuard(
    'The accuracy of all moves known by this Pokémon and all Pokémon targeting this Pokémon raises to 100%',
  ),
  intimidate(
    'When the Pokémon enters a battle, it intimidates opposing Pokémon and makes them cower, lowering their Attack stats.',
  ),
  shedSkin(
    'The Pokémon may cure its own status conditions by shedding its skin.',
  ),
  unnerve('Unnerves opposing Pokémon and makes them unable to eat Berries.'),
  static(
    'The Pokémon is charged with static electricity and may paralyze attackers that make direct contact with it.',
  ),
  lightningRod(
    'The Pokémon draws in all Electric-type moves. Instead of taking damage from them, its Sp. Atk stat is boosted.',
  ),
  cuteCharm(
    'The Pokémon may infatuate attackers that make direct contact with it.',
  ),
  magicGuard('The Pokémon only takes damage from attacks.'),
  unaware('When attacking, the Pokémon ignores the target\'s stat changes.'),
  flashFire(
    'If hit by a Fire-type move, the Pokémon absorbs the flames and uses them to power up its own Fire-type moves.',
  ),
  justified(
    'When the Pokémon is hit by a Dark-type attack, its Attack stat is boosted by its sense of justice.',
  ),
  synchronize(
    'If the Pokémon is burned, paralyzed, or poisoned by another Pokémon, that Pokémon will be inflicted with the same status condition.',
  ),
  innerFocus(
    'The Pokémon\'s intense focus prevents it from flinching or being affected by Intimidate.',
  ),
  guts(
    'It\'s so gutsy that having a status condition boosts the Pokémon\'s Attack stat.',
  ),
  steadfast(
    'The Pokémon\'s determination boosts its Speed stat every time it flinches.',
  ),
  gluttony(
    'If the Pokémon is holding a Berry to be eaten when its HP is low, it will instead eat the Berry when its HP drops to half or less.',
  ),
  oblivious(
    'The Pokémon is oblivious, keeping it from being infatuated, falling for taunts, or being affected by Intimidate.',
  ),
  ownTempo(
    'The Pokémon sticks to its own tempo, preventing it from becoming confused or being affected by Intimidate.',
  ),
  regenerator(
    'The Pokémon has a little of its HP restored when withdrawn from battle.',
  ),
  cursedBody('May disable a move that has dealt damage to the Pokémon.'),
  earlyBird('The Pokémon awakens from sleep twice as fast as other Pokémon.'),
  scrappy(
    'The Pokémon can hit Ghost-type Pokémon with Normal- and Fighting-type moves. It is also unaffected by Intimidate.',
  ),
  illuminate(
    'By illuminating its surroundings, the Pokémon prevents its accuracy from being lowered.',
  ),
  naturalCure(
    'The Pokémon\'s status conditions are cured when it switches out.',
  ),
  analytic(
    'Boosts the power of the Pokémon\'s move if it is the last to act that turn.',
  ),
  adaptability('Increases the Same Type Attack Bonus from *1.5 to *2.'),
  hyperCutter(
    'The Pokémon\'s prized, mighty pincers prevent other Pokémon from lowering its Attack stat.',
  ),
  moldBreaker(
    'The Pokémon\'s moves are not affected by foe’s abilities during battle',
  ),
  moxie(
    'When the Pokémon knocks out a target, it shows moxie, which boosts its Attack stat.',
  ),
  angerPoint(
    'The Pokémon is angered when it takes a critical hit, and that maxes its Attack stat.',
  ),
  sheerForce(
    'Removes any additional effects from the Pokémon\'s moves, but increases the moves\' power.',
  ),
  limber('The Pokémon\'s limber body prevents it from being paralyzed.'),
  waterAbsorb(
    'If hit by a Water-type move, the Pokémon has its HP restored instead of taking damage.',
  ),
  imposter('The Pokémon transforms itself into the Pokémon it\'s facing.'),
  hydration('Cures the Pokémon\'s status conditions in rain.'),
  voltAbsorb(
    'If hit by an Electric-type move, the Pokémon has its HP restored instead of taking damage.',
  ),
  quickFeet('Boosts the Speed stat if the Pokémon has a status condition.'),
  rockHead('Protects the Pokémon from recoil damage.'),
  pressure(
    'Puts other Pokémon under pressure, causing them to expend more PP to use their moves.',
  ),
  immunity('The Pokémon\'s immune system prevents it from being poisoned.'),
  multiscale('Reduces damage afflicted to the Pokémon by 50% if at maximum HP'),
  leafGuard('Prevents status conditions in harsh sunlight.'),
  insomnia('The Pokémon\'s insomnia prevents it from falling asleep.'),
  plus(
    'Boosts the Sp. Atk stat of the Pokémon if an ally with the Plus or Minus Ability is also in battle.',
  ),
  hugePower('The Pokémon\'s Attack stat is doubled while it has this ability.'),
  sapSipper(
    'The Pokémon takes no damage when hit by Grass-type moves. Instead, its Attack stat is boosted.',
  ),
  drizzle('The Pokémon makes it rain when it enters a battle.'),
  damp(
    'The Pokémon dampens its surroundings, preventing all Pokémon from using explosive moves such as Self-Destruct.',
  ),
  sturdy(
    'The Pokémon cannot be knocked out by a single hit as long as its HP is full. One-hit KO moves will also fail to knock it out.',
  ),
  magicBounce(
    'Reflects non-attacking moves used on the Pokémon back to the attacking Pokémon',
  ),
  overcoat(
    'The Pokémon takes no damage from sandstorms. It is also protected from the effects of powders and spores.',
  ),
  technician(
    'Powers up weak moves so the Pokémon can deal more damage with them.',
  ),
  lightMetal('Halves the Pokémon\'s weight.'),
  sandStream('The Pokémon summons a sandstorm when it enters a battle.'),
  weakArmor(
    'The Pokémon\'s Defense stat is lowered when it takes damage from physical moves, but its Speed stat is sharply boosted.',
  ),
  trace(
    'Ability becomes the same as that of the opponent. Switching this Pokémon out of battle restores its original ability. In a Double Battle, a random opponent’s ability will be copied.',
  ),
  telepathy('The Pokémon anticipates and dodges the attacks of its allies.'),
  stall('The Pokémon is always the last to use its moves.'),
  prankster('Gives priority to the Pokémon\'s status moves.'),
  heavyMetal('Doubles the Pokémon\'s weight.'),
  purePower('Using its pure power, the Pokémon doubles its Attack stat.'),
  minus(
    'Boosts the Sp. Atk stat of the Pokémon if an ally with the Plus or Minus Ability is also in battle.',
  ),
  roughSkin(
    'The Pokémon\'s rough skin damages attackers that make direct contact with it.',
  ),
  speedBoost('The Pokémon\'s Speed stat is boosted every turn.'),
  magmaArmor('The Pokémon’s hot magma coating prevents it from being frozen.'),
  solidRock(
    'Reduces the power of supereffective attacks that hit the Pokémon.',
  ),
  shellArmor('A hard shell protects the Pokémon from critical hits.'),
  whiteSmoke(
    'The Pokémon is protected by its white smoke, which prevents other Pokémon from lowering its stats.',
  ),
  cloudNine('Eliminates the effects of weather.'),
  marvelScale(
    'The Pokémon\'s marvelous scales boost its Defense stat if it has a status condition.',
  ),
  competitive(
    'Boosts the Pokémon\'s Sp. Atk stat sharply when its stats are lowered by an opposing Pokémon.',
  ),
  forecast(
    'The Pokémon transforms with the weather to change its type to Water, Fire, or Ice.',
  ),
  frisk(
    'When it enters a battle, the Pokémon can check an opposing Pokémon\'s held item.',
  ),
  levitate(
    'Damage dealing Ground-type moves have no effect on this Pokémon. Cannot be trapped by Arena Trap ability. Takes no damage from Spikes.',
  ),
  superLuck(
    'The Pokémon is so lucky that the critical-hit ratios of its moves are boosted.',
  ),
  iceBody('The Pokémon gradually regains HP in snow.'),
  moody(
    'Every turn, one of the Pokémon\'s stats will be boosted sharply but another stat will be lowered.',
  ),
  ironFist('The power of punching moves is increased by 20%. This stacks with'),
  defiant(
    'If the Pokémon has any stat lowered by an opposing Pokémon, its Attack stat will be boosted sharply.',
  ),
  rivalry(
    'The Pokémon\'s competitive spirit makes it deal more damage to Pokémon of the same gender, but less damage to Pokémon of the opposite gender.',
  ),
  poisonPoint('Contact with the Pokémon may poison the attacker.'),
  soundproof(
    'Soundproofing gives the Pokémon full immunity to all sound-based moves.',
  ),
  klutz('The Pokémon can\'t use any held items.'),
  infiltrator(
    'The protections and stat boosts caused by the moves Substitute, Reflect, Light Screen and Safeguard by the opponent are ignored.',
  ),
  sandVeil('Boosts the Pokémon\'s evasiveness in a sandstorm.'),
  sandForce(
    'Boosts the power of Rock-, Ground-, and Steel-type moves in a sandstorm.',
  ),
  anticipation('The Pokémon can sense an opposing Pokémon\'s dangerous moves.'),
  drySkin(
    'Restores the Pokémon\'s HP in rain or when it is hit by Water-type moves. Reduces HP in harsh sunlight, and increases the damage received from Fire-type moves.',
  ),
  poisonTouch('May poison a target when the Pokémon makes contact.'),
  snowWarning('Snowstorm blows when the Pokémon enters battle. As of X '),
  pickpocket(
    'The Pokémon steals the held item from attackers that made direct contact with it.',
  ),
  reckless('Powers up moves that have recoil damage.'),
  snowCloak('Boosts the Pokémon\'s evasiveness in snow.'),
  poisonHeal(
    'If poisoned, the Pokémon has its HP restored instead of taking damage.',
  ),
  contrary(
    'Reverses any stat changes affecting the Pokémon so that attempts to boost its stats instead lower them—and attempts to lower its stats will boost them.',
  ),
  unburden(
    'Boosts the Speed stat if the Pokémon\'s held item is used or lost.',
  ),
  sandRush('Boosts the Pokémon\'s Speed stat in a sandstorm.'),
  healer('Sometimes cures the status conditions of the Pokémon\'s allies.'),
  mummy('Contact with the Pokémon changes the attacker’s Ability to Mummy.'),
  stench(
    'By releasing a stench when attacking, the Pokémon may cause the target to flinch.',
  ),
  aftermath(
    'Damages the attacker if it knocks out the Pokémon with a move that makes direct contact.',
  ),
  illusion(
    'The Pokémon fools opponents by entering battle disguised as the last Pokémon in its Trainer\'s party.',
  ),
  motorDrive(
    'The Pokémon takes no damage when hit by Electric-type moves. Instead, its Speed stat is boosted.',
  ),
  flameBody('Contact with the Pokémon may burn the attacker.'),
  slushRush('Boosts the Pokémon\'s Speed stat in snow.'),
  swiftSwim('Boosts the Pokémon\'s Speed stat in rain.'),
  bulletproof('Protects the Pokémon from some ball and bomb moves.'),
  magician(
    'The Pokémon steals the held item from any target it hits with a move.',
  ),
  protean(
    'Before the Pokémon uses a move, it becomes a pure Pokémon of that type. This only works once per switch in.',
  ),
  pickup(
    'The Pokémon may pick up an item another Pokémon used during a battle. It may pick up items outside of battle, too.',
  ),
  cheekPouch(
    'The Pokémon\'s HP is restored when it eats any Berry, in addition to the Berry\'s usual effect.',
  ),
  galeWings(
    'Gives priority to the Pokémon\'s Flying-type moves while its HP is full.',
  ),
  shieldDust(
    'Protective dust shields the Pokémon from the additional effects of moves.',
  ),
  compoundEyes('The Pokémon\'s compound eyes boost its accuracy.'),
  friendGuard('Reduces damage dealt to allies.'),
  flowerVeil(
    'Ally Grass-type Pokémon are protected from status conditions and the lowering of their stats.',
  ),
  symbiosis(
    'The Pokémon passes its held item to an ally that has used up an item.',
  ),
  furCoat('Halves the damage from physical moves.'),
  stanceChange(
    'The Pokémon changes its form to Blade Forme when it uses an attack move and changes to Shield Forme when it uses King’s Shield.',
  ),
  aromaVeil(
    'Protects the Pokémon and its allies from effects that prevent the use of moves.',
  ),
  sweetVeil('Prevents the Pokémon and its allies from falling asleep.'),
  strongJaw('The Pokémon\'s strong jaw boosts the power of its biting moves.'),
  refrigerate(
    'Normal-type moves become Ice-type moves. The power of those moves is boosted a little.',
  ),
  pixilate(
    'Normal-type moves become Fairy-type moves. The power of those moves is boosted a little.',
  ),
  gooey('Contact with the Pokémon lowers the attacker\'s Speed stat.'),
  harvest('May create another Berry after one is used.'),
  longReach(
    'The Pokémon uses its moves without making contact with the target.',
  ),
  liquidVoice('Sound-based moves become Water-type moves.'),
  skillLink('Maximizes the number of times multistrike moves hit.'),
  merciless(
    'The Pokémon\'s attacks become critical hits if the target is poisoned.',
  ),
  stamina('Boosts the Defense stat when the Pokémon is hit by an attack.'),
  waterBubble(
    'Lowers the power of Fire-type moves that hit the Pokémon and prevents it from being burned.',
  ),
  corrosion(
    'The Pokémon can poison the target even if it\'s a Steel or Poison type.',
  ),
  queenlyMajesty(
    'When the Pokémon uses Surf or Dive, it will come back with prey. When it takes damage, it will spit out the prey to attack.',
  ),
  receiver('The Pokémon copies the Ability of a defeated ally.'),
  disguise(
    'Once per battle, the shroud that covers the Pokémon can protect it from an attack.',
  ),
  berserk(
    'Boosts the Pokémon\'s Sp. Atk stat when it takes a  hit that causes its HP to become half or less.',
  ),
  mirrorArmor(
    'Bounces back only the stat-lowering effects that the Pokémon receives.',
  ),
  ripen('Ripens Berries and doubles their effect.'),
  hustle('Boosts the Pokémon\'s Attack stat but lowers its accuracy.'),
  stalwart(
    'Ignores the effects of opposing Pokémon\'s Abilities and moves that draw in moves.',
  ),
  tangledFeet('Boosts the Pokémon\'s evasiveness if it is confused.'),
  screenCleaner(
    'When the Pokémon enters a battle, the effects of Light Screen, Reflect, and Aurora Veil are nullified for both opposing and ally Pokémon.',
  ),
  wanderingSpirit(
    'The Pokémon exchanges Abilities with a Pokémon that hits it with a move that makes direct contact.',
  ),
  hungerSwitch(
    'The Pokémon changes its form, alternating between its Full Belly Mode and Hangry Mode after the end of every turn.',
  ),
  clearBody(
    'Prevents other Pokémon\'s moves or Abilities from lowering the Pokémon\'s stats.',
  ),
  sharpness('Powers up slicing moves.'),
  rattled(
    'The Pokémon gets scared when hit by a Dark-, Ghost-, or Bug-type attack or if intimidated, which boosts its Speed stat.',
  ),
  purifyingSalt(
    'The Pokémon\'s pure salt protects it from status conditions and halves the damage taken from Ghost-type moves.',
  ),
  cudChew(
    'When the Pokémon eats a Berry, it will regurgitate that Berry at the end of the next turn and eat it one more time.',
  ),
  armorTail(
    'The mysterious tail covering the Pokémon\'s head makes opponents unable to use priority moves against the Pokémon or its allies.',
  ),
  supremeOverlord(
    'When the Pokémon enters a battle, its Attack and Sp. Atk stats are slightly boosted for each of the allies in its party that have already been defeated.',
  ),
  hospitality(
    'When the Pokémon enters a battle, it showers its ally with hospitality, restoring a small amount of the ally\'s HP',
  ),
  heatproof(
    'The Pokémon\'s heatproof body halves the damage taken from Fire-type moves.',
  ),
  supersweetSyrup(
    'Lowers the evasion of opposing Pokémon by 1 stage when first sent into battle',
  ),
  shadowTag(
    'The Pokémon steps on the opposing Pokémon\'s shadows to prevent them from fleeing or switching out.',
  ),
  parentalBond('Parent and child each attacks.'),
  aerilate(
    'Normal-type moves become Flying-type moves. The power of those moves is boosted a little.',
  ),
  opportunist(
    'If an opponent\'s stat is boosted, the Pokémon seizes the opportunity to boost the same stat for itself.',
  ),
  electromorphosis(
    'The Pokémon becomes charged when it takes damage, boosting the power of the next Electric-type move the Pokémon uses.',
  ),
  zeroToHero('The Pokémon transforms into its Hero Form when it switches out.'),
  earthEater(
    'If hit by a Ground-type move, the Pokémon has its HP restored instead of taking damage.',
  ),
  toxicDebris(
    'Scatters poison spikes at the feet of the opposing team when the Pokémon takes damage from physical moves.',
  ),
  surgeSurfer('Doubles the Pokémon\'s Speed stat on Electric Terrain.'),
  quickDraw('Enables the Pokémon to move first occasionally.'),
  curiousMedicine(
    'When the Pokémon enters a battle, it scatters medicine from its shell, which removes all stat changes from allies.',
  ),
  mimicry('Changes the Pokémon’s type depending on the terrain.'),
  vitalSpirit(
    'The Pokémon is full of vitality, and that prevents it from falling asleep.',
  ),
  sandSpit('The Pokémon creates a sandstorm when it\'s hit by an attack.'),
  innardsOut(
    'Damages the attacker landing the finishing hit by the amount equal to its last HP.',
  ),
  megaSol(
    'Even when the sunlight has not turned harsh, the Pokémon can use its moves as if the weather were harsh sunlight.',
  ),
  dragonize(
    'The Pokémon\'s Normal-type moves become Dragon-type moves and their power is boosted by 20%.',
  ),
  filter('Reduces the power of supereffective attacks that hit the Pokémon.'),
  piercingDrill(
    'When the Pokémon uses contact moves, it can hit even targets that are protecting themselves, dealing 1/4 of the damage that the move would otherwise deal. Everything aside from the target\'s protective effects is still triggered.',
  ),
  unseenFist(
    'The Pokémon can deal damage with moves that make physical contact, even if the target is protected.',
  ),
  fairyAura('Powers up every Pokémon in play\'s Fairy-type moves by 33%'),
  spicySpray(
    'When the Pokémon takes damage from a move, it burns the attacker.',
  );

  const Ability(this.description);

  final String description;
}
