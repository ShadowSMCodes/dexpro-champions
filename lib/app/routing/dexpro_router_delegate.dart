import 'package:dexpro/app/routing/app_route_data.dart';
import 'package:dexpro/app/shell/dexpro_shell.dart';
import 'package:dexpro/core/providers/app_details_provider.dart';
import 'package:flutter/material.dart';

class DexProRouterDelegate extends RouterDelegate<AppRouteData>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRouteData> {
  DexProRouterDelegate(this._appDetailsProvider) {
    _appDetailsProvider.addListener(notifyListeners);
  }

  final AppDetailsProvider _appDetailsProvider;

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  AppRouteData? get currentConfiguration => _appDetailsProvider.routeData;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: <Page<void>>[
        MaterialPage<void>(
          key: const ValueKey<String>('dexpro-shell'),
          child: DexProShell(routeData: _appDetailsProvider.routeData),
        ),
      ],
      onDidRemovePage: (Page<Object?> page) {},
    );
  }

  @override
  Future<void> setNewRoutePath(AppRouteData configuration) async {
    _appDetailsProvider.setRouteData(configuration);
  }

  @override
  void dispose() {
    _appDetailsProvider.removeListener(notifyListeners);
    super.dispose();
  }
}
