import 'package:dexpro/core/models/item.dart';
import 'package:flutter/material.dart';

class ItemDexPage extends StatefulWidget {
  const ItemDexPage({super.key});

  @override
  State<ItemDexPage> createState() => _ItemDexPageState();
}

class _ItemDexPageState extends State<ItemDexPage> {
  late final TextEditingController _searchController;
  String _query = '';
  ItemCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()
      ..addListener(() {
        setState(() {
          _query = _searchController.text.trim().toLowerCase();
        });
      });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<Item> filteredItems = itemList
        .where(
          (Item item) =>
              (_query.isEmpty ||
                  item.name.toLowerCase().contains(_query) ||
                  item.description.toLowerCase().contains(_query)) &&
              (_selectedCategory == null || item.category == _selectedCategory),
        )
        .toList(growable: false);

    return Column(
      key: const ValueKey('item-dex-page'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Item Dex',
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w800,
            fontFamily: 'RobotoCondensed',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Browse Pokemon Champions items, Mega Stones, berries, and held items.',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontFamily: 'RobotoCondensed',
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: SearchBar(
            controller: _searchController,
            hintText: 'Search items or descriptions',
            textStyle: WidgetStatePropertyAll<TextStyle?>(
              theme.textTheme.bodyLarge?.copyWith(
                fontFamily: 'RobotoCondensed',
              ),
            ),
            leading: const Icon(Icons.search_rounded),
            trailing: <Widget>[
              IconButton(
                onPressed: _searchController.clear,
                icon: const Icon(Icons.close_rounded),
                tooltip: 'Clear search',
              ),
            ],
            elevation: const WidgetStatePropertyAll<double>(0),
            backgroundColor: WidgetStatePropertyAll<Color>(
              theme.cardTheme.color ??
                  (theme.brightness == Brightness.dark
                      ? const Color(0xFF141414)
                      : Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _ItemCategoryFilterButton(
          selectedCategory: _selectedCategory,
          onChanged: (ItemCategory? category) {
            setState(() => _selectedCategory = category);
          },
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            itemCount: filteredItems.length,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 12),
            itemBuilder: (BuildContext context, int index) {
              return _ItemDexTile(item: filteredItems[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _ItemCategoryFilterButton extends StatelessWidget {
  const _ItemCategoryFilterButton({
    required this.selectedCategory,
    required this.onChanged,
  });

  final ItemCategory? selectedCategory;
  final ValueChanged<ItemCategory?> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ItemCategory?>(
      tooltip: 'Filter by item category',
      onSelected: onChanged,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ItemCategory?>>[
        _menuItem(context, null, selectedCategory == null),
        ...ItemCategory.values.map(
          (ItemCategory category) =>
              _menuItem(context, category, selectedCategory == category),
        ),
      ],
      child: _FilterButtonShell(
        icon: Icon(_categoryIcon(selectedCategory), size: 18),
        label: selectedCategory?.displayName ?? 'All Categories',
      ),
    );
  }

  PopupMenuItem<ItemCategory?> _menuItem(
    BuildContext context,
    ItemCategory? category,
    bool selected,
  ) {
    return PopupMenuItem<ItemCategory?>(
      value: category,
      child: Row(
        children: [
          Icon(_categoryIcon(category), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              category?.displayName ?? 'All Categories',
              style: const TextStyle(fontFamily: 'RobotoCondensed'),
            ),
          ),
          if (selected) const Icon(Icons.check_rounded, size: 18),
        ],
      ),
    );
  }
}

class _FilterButtonShell extends StatelessWidget {
  const _FilterButtonShell({required this.icon, required this.label});

  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              fontFamily: 'RobotoCondensed',
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
        ],
      ),
    );
  }
}

class _ItemDexTile extends StatelessWidget {
  const _ItemDexTile({required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showItemDetailsDialog(context, item),
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.36,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ItemImage(item: item, size: 64, padding: 8),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontFamily: 'RobotoCondensed',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        _ItemBadge(label: item.category.displayName),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.45,
                        fontFamily: 'RobotoCondensed',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemImage extends StatelessWidget {
  const _ItemImage({
    required this.item,
    required this.size,
    required this.padding,
  });

  final Item item;
  final double size;
  final double padding;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        color: theme.colorScheme.surface.withValues(alpha: 0.72),
      ),
      child: Image.network(
        item.imageURL,
        fit: BoxFit.contain,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
              return Icon(
                Icons.inventory_2_rounded,
                color: theme.colorScheme.primary,
              );
            },
      ),
    );
  }
}

void _showItemDetailsDialog(BuildContext context, Item item) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) => _ItemDetailsDialog(item: item),
  );
}

class _ItemDetailsDialog extends StatelessWidget {
  const _ItemDetailsDialog({required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ItemImage(item: item, size: 84, padding: 10),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.name,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            fontFamily: 'RobotoCondensed',
                          ),
                        ),
                        const SizedBox(height: 8),
                        _ItemBadge(label: item.category.displayName),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    tooltip: 'Close',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Description',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontFamily: 'RobotoCondensed',
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    item.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.45,
                      fontFamily: 'RobotoCondensed',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemBadge extends StatelessWidget {
  const _ItemBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: theme.colorScheme.primary.withValues(alpha: 0.15),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.35),
        ),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
          fontFamily: 'RobotoCondensed',
        ),
      ),
    );
  }
}

IconData _categoryIcon(ItemCategory? category) {
  return switch (category) {
    ItemCategory.megaStone => Icons.auto_awesome_rounded,
    ItemCategory.berry => Icons.spa_rounded,
    ItemCategory.heldItem => Icons.backpack_rounded,
    null => Icons.tune_rounded,
  };
}
