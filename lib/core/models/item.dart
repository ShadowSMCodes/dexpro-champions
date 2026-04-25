class Item {
  const Item({
    required this.name,
    required this.category,
    required this.imageURL,
    required this.description,
  });

  final String name;
  final ItemCategory category;
  final String imageURL;
  final String description;
}

enum ItemCategory {
  megaStone,
  berry,
  heldItem;

  String get displayName {
    return switch (this) {
      ItemCategory.megaStone => 'Mega Evolution',
      ItemCategory.berry => 'Berry',
      ItemCategory.heldItem => 'Held Item',
    };
  }
}

const Item abomasite = Item(
  name: 'Abomasite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/IU0uEoAq8ZjQUbgRUYLLo.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. An Abomasnow holding this stone will be able to Mega Evolve during battle.',
);

const Item absolite = Item(
  name: 'Absolite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/rZS1vbhO6JhimmiYXjuRF.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. An Absol holding this stone will be able to Mega Evolve during battle.',
);

const Item aerodactylite = Item(
  name: 'Aerodactylite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/alXIfsqLb7mheAX0qEjlz.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. An Aerodactyl holding this stone will be able to Mega Evolve during battle.',
);

const Item aggronite = Item(
  name: 'Aggronite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/G7258c0KPBmeFyDBipIqE.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. An Aggron holding this stone will be able to Mega Evolve during battle.',
);

const Item alakazite = Item(
  name: 'Alakazite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/sH1YMssWcvCKUgpc5kMt_.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. An Alakazam holding this stone will be able to Mega Evolve during battle.',
);

const Item altarianite = Item(
  name: 'Altarianite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/aGMj9Xd29YKGj5hv0bcrc.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. An Altaria holding this stone will be able to Mega Evolve during battle.',
);

const Item ampharosite = Item(
  name: 'Ampharosite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/ZnSr-GoxRNVFnSnzVXG0x.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. An Ampharos holding this stone will be able to Mega Evolve during battle.',
);

const Item aspearBerry = Item(
  name: 'Aspear Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/DDzvCBb_DBaK-azhjujZ7.png?width=64&height=64',
  description:
      'A Berry to be consumed by Pokemon. If a Pokemon holds one, it can recover from being frozen on its own in battle.',
);

const Item audinite = Item(
  name: 'Audinite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/F8LHP5lBxDU7hJL7xt0pC.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. An Audino holding this stone will be able to Mega Evolve during battle.',
);

const Item babiriBerry = Item(
  name: 'Babiri Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/GjnzhcASoECuJVGykvUsF.png?width=64&height=64',
  description:
      'If held by a Pokemon, this Berry will lessen the damage taken from one supereffective Steel-type attack.',
);

const Item banettite = Item(
  name: 'Banettite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/UhEz4oMiN0W8e-4hPhZVD.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Banette holding this stone will be able to Mega Evolve during battle.',
);

const Item beedrillite = Item(
  name: 'Beedrillite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/LOD3ENL2TuXryuK_RKBGB.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Beedrill holding this stone will be able to Mega Evolve during battle.',
);

const Item blackBelt = Item(
  name: 'Black Belt',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/_kA5JDuW0_ORfFMzLKnzW.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. This belt helps the wearer to focus and boosts the power of Fighting-type moves.',
);

const Item blackGlasses = Item(
  name: 'Black Glasses',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/jKvpHOY-0O16GAeIYQvkD.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. It\'s a pair of shady-looking glasses that boost the power of Dark-type moves.',
);

const Item blastoisinite = Item(
  name: 'Blastoisinite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/Nt5kdVP-icY7C-OKwZk7w.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Blastoise holding this stone will be able to Mega Evolve during battle.',
);

const Item brightPowder = Item(
  name: 'Bright Powder',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/ihn9c_g4VPwGCHQWyPbxl.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. It casts a tricky glare that lowers the opposing Pokemon\'s accuracy.',
);

const Item cameruptite = Item(
  name: 'Cameruptite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/MOUtdZOakuJ7wHiRH1l1X.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Camerupt holding this stone will be able to Mega Evolve during battle.',
);

const Item chandelurite = Item(
  name: 'Chandelurite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/_sYYBGO8tg3GUfLdaiYUf.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Chandelure holding this stone will be able to Mega Evolve during battle.',
);

const Item charcoal = Item(
  name: 'Charcoal',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/riZRqhhp6xj-eogF47DwX.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. It\'s a combustible fuel that boosts the power of Fire-type moves.',
);

const Item charizarditeX = Item(
  name: 'Charizardite X',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/h_c_fbKkIxl4tN8_58YSD.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Charizard holding this stone will be able to Mega Evolve during battle.',
);

const Item charizarditeY = Item(
  name: 'Charizardite Y',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/JZQenaKvNs5FUZerbYqvc.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Charizard holding this stone will be able to Mega Evolve during battle.',
);

const Item chartiBerry = Item(
  name: 'Charti Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/jrEP0ADV8YLuipA_rxNqH.png?width=64&height=64',
  description:
      'If held by a Pokemon, this Berry will lessen the damage taken from one supereffective Rock-type attack.',
);

const Item cheriBerry = Item(
  name: 'Cheri Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/U0x7VCMPrccrUrp0kI1Rj.png?width=64&height=64',
  description:
      'A Berry to be consumed by Pokemon. If a Pokemon holds one, it can recover from paralysis on its own in battle.',
);

const Item chesnaughtite = Item(
  name: 'Chesnaughtite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/VqjXSDJqDfjLkHegRxMMz.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Chesnaught holding this stone will be able to Mega Evolve during battle.',
);

const Item chestoBerry = Item(
  name: 'Chesto Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/GZr-gK4-wkPthO6nNc1eC.png?width=64&height=64',
  description:
      'A Berry to be consumed by Pokemon. If a Pokemon holds one, it can recover from sleep on its own in battle.',
);

const Item chilanBerry = Item(
  name: 'Chilan Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/rV2EE-uWWnfnCW6ZfwV53.png?width=64&height=64',
  description:
      'If held by a Pokemon, this Berry will lessen the damage taken from one Normal-type attack.',
);

const Item chimechite = Item(
  name: 'Chimechite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/hTXZd1CfK3ZJ8ku34yy2g.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Chimecho holding this stone will be able to Mega Evolve during battle.',
);

const Item choiceScarf = Item(
  name: 'Choice Scarf',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/TtV-9T3hWkm5Mpl_K8Jay.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. This curious scarf boosts Speed but only allows the use of one move.',
);

const Item chopleBerry = Item(
  name: 'Chople Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/NLm51HmIuV_mEgbV8MuAn.png?width=64&height=64',
  description:
      'If held by a Pokemon, this Berry will lessen the damage taken from one supereffective Fighting-type attack.',
);

const Item clefablite = Item(
  name: 'Clefablite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/0WTNWWCPsgGy22tdH9Qt7.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Clefable holding this stone will be able to Mega Evolve during battle.',
);

const Item cobaBerry = Item(
  name: 'Coba Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/yJGXOTtML6PLZhiKhy47X.png?width=64&height=64',
  description:
      'If held by a Pokemon, this Berry will lessen the damage taken from one supereffective Flying-type attack.',
);

const Item colburBerry = Item(
  name: 'Colbur Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/yZoD99er-EERMAzgJ6cEi.png?width=64&height=64',
  description:
      'If held by a Pokemon, this Berry will lessen the damage taken from one supereffective Dark-type attack.',
);

const Item crabominite = Item(
  name: 'Crabominite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/7pxksvTIc9Gwz-WH6nDuS.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Crabominable holding this stone will be able to Mega Evolve during battle.',
);

const Item delphoxite = Item(
  name: 'Delphoxite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/1lk7pXPm5Sbadw_UOzVH5.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Delphox holding this stone will be able to Mega Evolve during battle.',
);

const Item dragonFang = Item(
  name: 'Dragon Fang',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/qS6BRjO8ZmBzzufdXzQas.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. This hard and sharp fang boosts the power of Dragon-type moves.',
);

const Item dragoninite = Item(
  name: 'Dragoninite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/UP1p0Vur2n_c0m0aLY0vk.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Dragonite holding this stone will be able to Mega Evolve during battle.',
);

const Item drampanite = Item(
  name: 'Drampanite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/r3LlDIMvHOK-McZqWWimc.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Drampa holding this stone will be able to Mega Evolve during battle.',
);

const Item emboarite = Item(
  name: 'Emboarite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/bK_ygK8Zk9srcFbQgyilp.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. An Emboar holding this stone will be able to Mega Evolve during battle.',
);

const Item excadrite = Item(
  name: 'Excadrite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/2r1CDnWwnI_8xu_ou0eTM.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. An Excadrill holding this stone will be able to Mega Evolve during battle.',
);

const Item feraligite = Item(
  name: 'Feraligite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/HO_LGu18RFgGZwnmhGRww.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Feraligatr holding this stone will be able to Mega Evolve during battle.',
);

const Item fairyFeather = Item(
  name: 'Fairy Feather',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/x2NwRdU_fjkvWAx0bctWJ.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. This feather boosts the power of Fairy-type moves.',
);

const Item floettite = Item(
  name: 'Floettite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/DPmFJBuJ0cwx-Vty_9xM7.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A special Floette holding this stone will be able to Mega Evolve during battle.',
);

const Item focusBand = Item(
  name: 'Focus Band',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/VbWTTjYILXsnhKOcOqLnE.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. The holder may endure a potential KO attack, leaving it with just 1 HP.',
);

const Item focusSash = Item(
  name: 'Focus Sash',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/Oq1-A9_VSx8rfSz-Y5GWa.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. If the holder has full HP, it will endure a potential KO attack with 1 HP. The item then disappears.',
);

const Item froslassite = Item(
  name: 'Froslassite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/khT6zigoeP9xKq8skA6an.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Froslass holding this stone will be able to Mega Evolve during battle.',
);

const Item galladite = Item(
  name: 'Galladite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/gViOdqO1r5XuFuZwJ-Asw.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Gallade holding this stone will be able to Mega Evolve during battle.',
);

const Item garchompite = Item(
  name: 'Garchompite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/3dDoUKrEV7RxZYNNxOe3e.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Garchomp holding this stone will be able to Mega Evolve during battle.',
);

const Item gardevoirite = Item(
  name: 'Gardevoirite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/kifa04DERoLoxUfx_WGTR.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Gardevoir holding this stone will be able to Mega Evolve during battle.',
);

const Item gengarite = Item(
  name: 'Gengarite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/c73DjsAEZ_kaoVQ1MYMaj.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Gengar holding this stone will be able to Mega Evolve during battle.',
);

const Item glalitite = Item(
  name: 'Glalitite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/bFka8RELrTdljeGxMTXo_.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Glalie holding this stone will be able to Mega Evolve during battle.',
);

const Item glimmoranite = Item(
  name: 'Glimmoranite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/iqVAdHwJmwbJQSnL1ZDHI.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Glimmora holding this stone will be able to Mega Evolve during battle.',
);

const Item golurkite = Item(
  name: 'Golurkite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/h9Hk18_YS-1g9wb4LgAmb.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Golurk holding this stone will be able to Mega Evolve during battle.',
);

const Item greninjite = Item(
  name: 'Greninjite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/1dgaNWc_0X7Da5KHmLJqE.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Greninja holding this stone will be able to Mega Evolve during battle.',
);

const Item gyaradosite = Item(
  name: 'Gyaradosite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/SXmkaqzKfkDnLGYDnuR7b.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Gyarados holding this stone will be able to Mega Evolve during battle.',
);

const Item habanBerry = Item(
  name: 'Haban Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/qkU8-AByMY9o_OuQY0V9Q.png?width=64&height=64',
  description:
      'If held by a Pokemon, this Berry will lessen the damage taken from one supereffective Dragon-type attack.',
);

const Item hardStone = Item(
  name: 'Hard Stone',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/9j1RuWK_57k2OToWuQpcE.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. It\'s a durable stone that boosts the power of Rock-type moves.',
);

const Item hawluchanite = Item(
  name: 'Hawluchanite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/VjzuHu1tnLVrHcLMcGvf1.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Hawlucha holding this stone will be able to Mega Evolve during battle.',
);

const Item heracronite = Item(
  name: 'Heracronite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/T71AGvaz_59kfOh4pUWWz.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Heracross holding this stone will be able to Mega Evolve during battle.',
);

const Item houndoominite = Item(
  name: 'Houndoominite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/FItucT0aIANiOodQQzwry.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Houndoom holding this stone will be able to Mega Evolve during battle.',
);

const Item kangaskhanite = Item(
  name: 'Kangaskhanite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/yPlFY3jetNpgCoXR1QN06.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Kangaskhan holding this stone will be able to Mega Evolve during battle.',
);

const Item kasibBerry = Item(
  name: 'Kasib Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/rwfWRDsWKwsBUhoixl7hL.png?width=64&height=64',
  description:
      'If held by a Pokemon, this Berry will lessen the damage taken from one supereffective Ghost-type attack.',
);

const Item kebiaBerry = Item(
  name: 'Kebia Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/Go8VK_2o8Gzut_JFNJtr-.png?width=64&height=64',
  description:
      'If held by a Pokemon, this Berry will lessen the damage taken from one supereffective Poison-type attack.',
);

const Item kingsRock = Item(
  name: 'King\'s Rock',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/na1pobRX9zccpVdPmr4Tu.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. When the holder successfully inflicts damage, the target may also flinch.',
);

const Item leftovers = Item(
  name: 'Leftovers',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/jDYS-THAqHkZq7F7EEr1Y.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. The holder\'s HP is slowly but steadily restored throughout every battle.',
);

const Item leppaBerry = Item(
  name: 'Leppa Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/alCQhsgoEv3-pXR6w61AN.png?width=64&height=64',
  description:
      'A Berry to be consumed by Pokemon. If a Pokemon holds one, it can restore 10 PP to a depleted move during battle.',
);

const Item lightBall = Item(
  name: 'Light Ball',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/w4PqJ_DC0lIWn0fyYfaDz.png?width=64&height=64',
  description:
      'An item to be held by Pikachu. It\'s a puzzling orb that boosts its Attack and Sp. Atk stats.',
);

const Item lopunnite = Item(
  name: 'Lopunnite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/cb-DdQUu_jDg7aaVOZzfT.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Lopunny holding this stone will be able to Mega Evolve during battle.',
);

const Item lucarionite = Item(
  name: 'Lucarionite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/Qfp7DZ9g0_uADZdj_d7lL.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Lucario holding this stone will be able to Mega Evolve during battle.',
);

const Item lumBerry = Item(
  name: 'Lum Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/llhxuhYf0iJqFy7LEUpyx.png?width=64&height=64',
  description:
      'A Berry to be consumed by Pokemon. If a Pokemon holds one, it can recover from any status condition during battle.',
);

const Item magnet = Item(
  name: 'Magnet',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/0olVYZxGaRcwLHPTA-OYQ.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. It\'s a powerful magnet that boosts the power of Electric-type moves.',
);

const Item manectite = Item(
  name: 'Manectite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/cn76l3mqYn2hv07dgh-hE.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Manectric holding this stone will be able to Mega Evolve during battle.',
);

const Item medichamite = Item(
  name: 'Medichamite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/KAN7EQx-OFjlmEi_dK41C.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Medicham holding this stone will be able to Mega Evolve during battle.',
);

const Item meganiumite = Item(
  name: 'Meganiumite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/e2va4wDdwwz2XanLvVIGp.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Meganium holding this stone will be able to Mega Evolve during battle.',
);

const Item mentalHerb = Item(
  name: 'Mental Herb',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/H-afonJsWEVD10OPcapJx.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. The holder shakes off move-binding effects to move freely. It can be used only once.',
);

const Item meowsticite = Item(
  name: 'Meowsticite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/WGU3ng7H0D3iDFmzFc_1L.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Meowstic holding this stone will be able to Mega Evolve during battle.',
);

const Item metalCoat = Item(
  name: 'Metal Coat',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/8AN4QZsahRp1uym9Xp2Vd.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. It\'s a special metallic film that can boost the power of Steel-type moves.',
);

const Item miracleSeed = Item(
  name: 'Miracle Seed',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/nDAULgTrzrfMze74MWfFs.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. It\'s a seed imbued with life-force that boosts the power of Grass-type moves.',
);

const Item mysticWater = Item(
  name: 'Mystic Water',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/9zZmAVxO9hR1pd12r3Mm-.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. This teardrop-shaped gem boosts the power of Water-type moves.',
);

const Item neverMeltIce = Item(
  name: 'Never-Melt Ice',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/dBDj4YISwiv3quT6Cs7Q-.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. It\'s a heat- repelling piece of ice that boosts the power of Ice-type moves.',
);

const Item occaBerry = Item(
  name: 'Occa Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/NXgGW39qxfVGdvlx9ejLj.png?width=64&height=64',
  description:
      'If held by a Pokemon, this Berry will lessen the damage taken from one supereffective Fire-type attack.',
);

const Item oranBerry = Item(
  name: 'Oran Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/vqm2ldn_Mdh29wfBmNXM2.png?width=64&height=64',
  description:
      'A Berry to be consumed by Pokemon. If a Pokemon holds one, it can restore its own HP by 10 points during battle.',
);

const Item passhoBerry = Item(
  name: 'Passho Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/48sxDULIhS_9EJ1YWITQt.png?width=64&height=64',
  description:
      'If held by a Pokemon, this Berry will lessen the damage taken from one supereffective Water-type attack.',
);

const Item payapaBerry = Item(
  name: 'Payapa Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/Y5krB6jXjPKqk_G1gu6hE.png?width=64&height=64',
  description:
      'If held by a Pokemon, this Berry will lessen the damage taken from one supereffective Psychic-type attack.',
);

const Item pechaBerry = Item(
  name: 'Pecha Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/V7dWJOZ4jf-A6CGX-5wA5.png?width=64&height=64',
  description:
      'A Berry to be consumed by Pokemon. If a Pokemon holds one, it can recover from poisoning on its own in battle.',
);

const Item persimBerry = Item(
  name: 'Persim Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/RucXq67zHbbu11LT046Wm.png?width=64&height=64',
  description:
      'A Berry to be consumed by Pokemon. If a Pokemon holds one, it can recover from confusion on its own in battle.',
);

const Item pidgeotite = Item(
  name: 'Pidgeotite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/tHJ2SwtTmr09O9RMK9lBY.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Pidgeot holding this stone will be able to Mega Evolve during battle.',
);

const Item pinsirite = Item(
  name: 'Pinsirite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/8216Sn0RAIC4Vt37Jjqfn.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Pinsir holding this stone will be able to Mega Evolve during battle.',
);

const Item poisonBarb = Item(
  name: 'Poison Barb',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/5QQucStpfSLtFLW32p-4J.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. This small, poisonous barb boosts the power of Poison-type moves.',
);

const Item quickClaw = Item(
  name: 'Quick Claw',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/aAOJxg-HcRxPSktJpJUVE.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. This light, sharp claw lets the bearer move first occasionally.',
);

const Item rawstBerry = Item(
  name: 'Rawst Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/vnvfERC72UsjO0zUYy620.png?width=64&height=64',
  description:
      'A Berry to be consumed by Pokemon. If a Pokemon holds one, it can recover from a burn on its own in battle.',
);

const Item rindoBerry = Item(
  name: 'Rindo Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/eLVmyy1mQBp-8IO4-JgSc.png?width=64&height=64',
  description:
      'If held by a Pokemon, this Berry will lessen the damage taken from one supereffective Grass-type attack.',
);

const Item roseliBerry = Item(
  name: 'Roseli Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/E8CV3UQmWBTDjLzC4pI7R.png?width=64&height=64',
  description:
      'If held by a Pokemon, this Berry will lessen the damage taken from one supereffective Fairy-type attack.',
);

const Item sablenite = Item(
  name: 'Sablenite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/pqUGVxQ3boIdLpZEbNkXz.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Sableye holding this stone will be able to Mega Evolve during battle.',
);

const Item scizorite = Item(
  name: 'Scizorite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/eO7m1NCHhF6IkBMV7ypzJ.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Scizor holding this stone will be able to Mega Evolve during battle.',
);

const Item scopeLens = Item(
  name: 'Scope Lens',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/GZhSA3WSTsUQfCT_UqChd.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. It\'s a lens for scoping out weak points. It boosts the holder\'s critical-hit ratio.',
);

const Item scovillainite = Item(
  name: 'Scovillainite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/T--qjJdMpvt--_hC6zlRS.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Scovillain holding this stone will be able to Mega Evolve during battle.',
);

const Item sharpBeak = Item(
  name: 'Sharp Beak',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/f3uKicgeEVk81Z4SAFqk0.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. It\'s a long, sharp beak that boosts the power of Flying-type moves.',
);

const Item sharpedonite = Item(
  name: 'Sharpedonite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/oVlDDeoEa2WHHPkxjidBd.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Sharpedo holding this stone will be able to Mega Evolve during battle.',
);

const Item shellBell = Item(
  name: 'Shell Bell',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/ccCGX1Q89p2KWQ3oTxEMn.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. The holder restores a little HP every time it inflicts damage on others.',
);

const Item shucaBerry = Item(
  name: 'Shuca Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/bbzu8aIH40Fp6Tu6usXB6.png?width=64&height=64',
  description:
      'If held by a Pokemon, this Berry will lessen the damage taken from one supereffective Ground-type attack.',
);

const Item silkScarf = Item(
  name: 'Silk Scarf',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/3Guyh8n93_BSxYWhP1qwg.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. It\'s a sumptuous scarf that boosts the power of Normal-type moves.',
);

const Item silverPowder = Item(
  name: 'Silver Powder',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/xxcl_XA-qbZ2MxO5rPvy0.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. It\'s a shiny silver powder that will boost the power of Bug-type moves.',
);

const Item sitrusBerry = Item(
  name: 'Sitrus Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/xOhNwz4angOyH3iQ17Cv-.png?width=64&height=64',
  description:
      'A Berry to be consumed by Pokemon. If a Pokemon holds one, it can restore its own HP by a small amount during battle.',
);

const Item skarmorite = Item(
  name: 'Skarmorite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/s6GdulTsO_C3iZvheUIjw.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Skarmory holding this stone will be able to Mega Evolve during battle.',
);

const Item slowbronite = Item(
  name: 'Slowbronite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/sDEJN5drrUHqXCSINcX5k.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Slowbro holding this stone will be able to Mega Evolve during battle.',
);

const Item softSand = Item(
  name: 'Soft Sand',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/yvPQpebtJgYtF2nmc88cg.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. It\'s a loose, silky sand that boosts the power of Ground-type moves.',
);

const Item spellTag = Item(
  name: 'Spell Tag',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/LHUk9QrW3a-aOsjy9G4dF.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. It\'s a sinister, eerie tag that boosts the power of Ghost-type moves.',
);

const Item starminite = Item(
  name: 'Starminite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/eqdTtGFXxklv7pthbfHvu.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Starmie holding this stone will be able to Mega Evolve during battle.',
);

const Item steelixite = Item(
  name: 'Steelixite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/wwwIxC77aGAFWAq2U7XOi.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Steelix holding this stone will be able to Mega Evolve during battle.',
);

const Item tangaBerry = Item(
  name: 'Tanga Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/gzod2Fe5RAlD0buszhTYB.png?width=64&height=64',
  description:
      'If held by a Pokemon, this Berry will lessen the damage taken from one supereffective Bug-type attack.',
);

const Item twistedSpoon = Item(
  name: 'Twisted Spoon',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/2fxucz95DicwkDET25dVH.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. This spoon is imbued with telekinetic power and boosts Psychic-type moves.',
);

const Item tyranitarite = Item(
  name: 'Tyranitarite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/BpkT107iSBlktf62qH8_B.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Tyranitar holding this stone will be able to Mega Evolve during battle.',
);

const Item venusaurite = Item(
  name: 'Venusaurite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/Xs8lNI_oFspm1WfOeXigy.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Venusaur holding this stone will be able to Mega Evolve during battle.',
);

const Item victreebelite = Item(
  name: 'Victreebelite',
  category: ItemCategory.megaStone,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/Fo_5YiIP6kEZmhCb6VS2d.png?width=64&height=64',
  description:
      'One of a variety of mysterious Mega Stones. A Victreebel holding this stone will be able to Mega Evolve during battle.',
);

const Item wacanBerry = Item(
  name: 'Wacan Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/rX-k8lgaPaFv208Og8AOT.png?width=64&height=64',
  description:
      'If held by a Pokemon, this Berry will lessen the damage taken from one supereffective Electric-type attack.',
);

const Item whiteHerb = Item(
  name: 'White Herb',
  category: ItemCategory.heldItem,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/9t7p9ViyW7ou9KaNdy_Pp.png?width=64&height=64',
  description:
      'An item to be held by a Pokemon. It will restore any lowered stat in battle. It can be used only once.',
);

const Item yacheBerry = Item(
  name: 'Yache Berry',
  category: ItemCategory.berry,
  imageURL:
      'https://i.pokebase.app/pokemon-champions/0nE_eowYj33e-8QgL8bDP.png?width=64&height=64',
  description:
      'If held by a Pokemon, this Berry will lessen the damage taken from one supereffective Ice-type attack.',
);

const List<Item> itemList = <Item>[
  abomasite,
  absolite,
  aerodactylite,
  aggronite,
  alakazite,
  altarianite,
  ampharosite,
  aspearBerry,
  audinite,
  babiriBerry,
  banettite,
  beedrillite,
  blackBelt,
  blackGlasses,
  blastoisinite,
  brightPowder,
  cameruptite,
  chandelurite,
  charcoal,
  charizarditeX,
  charizarditeY,
  chartiBerry,
  cheriBerry,
  chesnaughtite,
  chestoBerry,
  chilanBerry,
  chimechite,
  choiceScarf,
  chopleBerry,
  clefablite,
  cobaBerry,
  colburBerry,
  crabominite,
  delphoxite,
  dragonFang,
  dragoninite,
  drampanite,
  emboarite,
  excadrite,
  fairyFeather,
  feraligite,
  floettite,
  focusBand,
  focusSash,
  froslassite,
  galladite,
  garchompite,
  gardevoirite,
  gengarite,
  glalitite,
  glimmoranite,
  golurkite,
  greninjite,
  gyaradosite,
  habanBerry,
  hardStone,
  hawluchanite,
  heracronite,
  houndoominite,
  kangaskhanite,
  kasibBerry,
  kebiaBerry,
  kingsRock,
  leftovers,
  leppaBerry,
  lightBall,
  lopunnite,
  lucarionite,
  lumBerry,
  magnet,
  manectite,
  medichamite,
  meganiumite,
  mentalHerb,
  meowsticite,
  metalCoat,
  miracleSeed,
  mysticWater,
  neverMeltIce,
  occaBerry,
  oranBerry,
  passhoBerry,
  payapaBerry,
  pechaBerry,
  persimBerry,
  pidgeotite,
  pinsirite,
  poisonBarb,
  quickClaw,
  rawstBerry,
  rindoBerry,
  roseliBerry,
  sablenite,
  scizorite,
  scopeLens,
  scovillainite,
  sharpBeak,
  sharpedonite,
  shellBell,
  shucaBerry,
  silkScarf,
  silverPowder,
  sitrusBerry,
  skarmorite,
  slowbronite,
  softSand,
  spellTag,
  starminite,
  steelixite,
  tangaBerry,
  twistedSpoon,
  tyranitarite,
  venusaurite,
  victreebelite,
  wacanBerry,
  whiteHerb,
  yacheBerry,
];
