import 'package:dexpro/app/routing/app_route_data.dart';
import 'package:flutter/material.dart';

class AppDetailsProvider extends ChangeNotifier {
  AppRouteData _routeData = AppRouteData.parse('/events');
  bool _isCompact = false;

  AppRouteData get routeData => _routeData;
  bool get isCompact => _isCompact;

  void setRouteData(AppRouteData value) {
    if (_routeData.location == value.location &&
        _routeData.originalLocation == value.originalLocation) {
      return;
    }

    _routeData = value;
    notifyListeners();
  }

  void navigateTo(AppRouteData value) {
    if (_routeData.location == value.location) {
      return;
    }

    _routeData = value;
    notifyListeners();
  }

  void navigateToPath(String path) {
    navigateTo(AppRouteData.parse(path));
  }

  void updateIsCompact(bool value) {
    if (_isCompact == value) {
      return;
    }

    _isCompact = value;
    notifyListeners();
  }
}
