import 'package:dexpro/app/routing/dexpro_route_information_parser.dart';
import 'package:dexpro/app/routing/dexpro_router_delegate.dart';
import 'package:dexpro/core/config/app_theme.dart';
import 'package:dexpro/core/providers/app_details_provider.dart';
import 'package:dexpro/core/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DexProApp extends StatelessWidget {
  const DexProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<AppDetailsProvider>(
          create: (_) => AppDetailsProvider(),
        ),
      ],
      child: const _DexProAppView(),
    );
  }
}

class _DexProAppView extends StatefulWidget {
  const _DexProAppView();

  @override
  State<_DexProAppView> createState() => _DexProAppViewState();
}

class _DexProAppViewState extends State<_DexProAppView> {
  DexProRouterDelegate? _routerDelegate;
  late final DexProRouteInformationParser _routeInformationParser;

  @override
  void initState() {
    super.initState();
    _routeInformationParser = DexProRouteInformationParser();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = context.watch<ThemeProvider>();
    final AppDetailsProvider appDetailsProvider = context
        .watch<AppDetailsProvider>();
    _routerDelegate ??= DexProRouterDelegate(appDetailsProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'DexPro – Champions',
      routerDelegate: _routerDelegate!,
      routeInformationParser: _routeInformationParser,
      themeMode: themeProvider.themeMode,
      theme: buildThemeData(
        brightness: Brightness.light,
        accent: themeProvider.accent,
      ),
      darkTheme: buildThemeData(
        brightness: Brightness.dark,
        accent: themeProvider.accent,
      ),
    );
  }
}
