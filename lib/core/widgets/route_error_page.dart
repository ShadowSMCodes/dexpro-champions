import 'package:flutter/material.dart';

class RouteErrorPage extends StatelessWidget {
  const RouteErrorPage({super.key, required this.invalidPath});

  final String invalidPath;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '400 Error',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontFamily: 'RobotoCondensed',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'This URL link does not exist.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontFamily: 'RobotoCondensed',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  invalidPath,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontFamily: 'RobotoCondensed',
                  ),
                ),
                const SizedBox(height: 24),
                Image.asset(
                  'assets/pokemon/120px-Menu_CP_0149-Mega.png',
                  width: 132,
                  height: 132,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Text(
                  'Mega Dragonite could not find that route.\nUse the drawer to jump to another tab and keep exploring DexPro.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                    fontFamily: 'RobotoCondensed',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
