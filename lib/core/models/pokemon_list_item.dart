import 'package:dexpro/core/models/pokemon.dart' as dex;

class PokemonListItem {
  const PokemonListItem({
    required this.slug,
    required this.pokemon,
    this.displayNameOverride,
    this.familyBase,
  });

  final String slug;
  final dex.Pokemon pokemon;
  final String? displayNameOverride;
  final PokemonListItem? familyBase;

  PokemonListItem variant(dex.Pokemon variantPokemon) {
    final String formSegment = (variantPokemon.form ?? 'mega').toLowerCase();
    final PokemonListItem baseEntry = familyBase ?? this;

    return PokemonListItem(
      slug: '${slug}_$formSegment',
      pokemon: variantPokemon,
      displayNameOverride:
          '$displayName${variantPokemon.form == null ? ' Mega' : ' ${_formatSegment(variantPokemon.form!)}'}',
      familyBase: baseEntry,
    );
  }

  PokemonListItem get familyBaseEntry => familyBase ?? this;

  String get displayName {
    if (displayNameOverride != null) {
      return displayNameOverride!;
    }

    return slug
        .split(RegExp(r'[_-]'))
        .where((String part) => part.isNotEmpty)
        .map(_formatSegment)
        .join(' ');
  }

  String get assetImagePath {
    final String paddedId = pokemon.id.toString().padLeft(4, '0');
    return 'assets/pokemon/120px-Menu_CP_$paddedId${(pokemon.form == null ? '' : '-${pokemon.form}')}';
  }

  String get assetShinyImagePath => '${assetImagePath}_shiny';

  String _formatSegment(String part) {
    if (part.isEmpty) {
      return part;
    }

    return part[0].toUpperCase() + part.substring(1);
  }
}
