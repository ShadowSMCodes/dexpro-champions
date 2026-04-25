import 'package:flutter/material.dart';

class AccentOption {
  const AccentOption({
    required this.name,
    required this.color,
    required this.lightBackgroundColor,
    required this.hex,
  });

  final String name;
  final Color color;
  final Color lightBackgroundColor;
  final String hex;
}

