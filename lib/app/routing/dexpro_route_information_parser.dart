import 'package:dexpro/app/routing/app_route_data.dart';
import 'package:flutter/material.dart';

class DexProRouteInformationParser
    extends RouteInformationParser<AppRouteData> {
  @override
  Future<AppRouteData> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final Uri uri = routeInformation.uri;
    final String location = uri.toString().isEmpty ? '/' : uri.toString();
    return AppRouteData.parse(location);
  }

  @override
  RouteInformation? restoreRouteInformation(AppRouteData configuration) {
    return RouteInformation(uri: Uri.parse(configuration.location));
  }
}
