import 'package:flutter/material.dart';

class NavigationItem {
  const NavigationItem({
    required this.label,
    required this.path,
    required this.icon,
    this.activeIcon,
  });

  final String label;
  final String path;
  final IconData icon;
  final IconData? activeIcon;
}
