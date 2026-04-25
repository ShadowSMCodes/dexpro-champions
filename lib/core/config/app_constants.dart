import 'package:dexpro/core/models/accent_option.dart';
import 'package:dexpro/core/models/navigation_item.dart';
import 'package:flutter/material.dart';

const List<NavigationItem> navigationItems = [
  NavigationItem(
    label: 'Seasons & Events',
    path: '/events',
    icon: Icons.event_outlined,
    activeIcon: Icons.event_rounded,
  ),
  NavigationItem(
    label: 'Pokémon Dex',
    path: '/pokemon',
    icon: Icons.catching_pokemon_outlined,
    activeIcon: Icons.catching_pokemon_rounded,
  ),
  NavigationItem(
    label: 'Ability Dex',
    path: '/ability-dex',
    icon: Icons.auto_awesome_outlined,
    activeIcon: Icons.auto_awesome_rounded,
  ),
  NavigationItem(
    label: 'Move Dex',
    path: '/move-dex',
    icon: Icons.bolt_outlined,
    activeIcon: Icons.bolt_rounded,
  ),
  NavigationItem(
    label: 'Item Dex',
    path: '/item-dex',
    icon: Icons.inventory_2_outlined,
    activeIcon: Icons.inventory_2_rounded,
  ),
  NavigationItem(
    label: 'Weakness Chart',
    path: '/weakness-chart',
    icon: Icons.grid_on_outlined,
    activeIcon: Icons.grid_on_rounded,
  ),
  NavigationItem(
    label: 'Team Builder',
    path: '/team-builder',
    icon: Icons.groups_outlined,
    activeIcon: Icons.groups_rounded,
  ),
  NavigationItem(
    label: 'EVs to Champion Stats',
    path: '/evs-to-champion-stats',
    icon: Icons.calculate_outlined,
    activeIcon: Icons.calculate_rounded,
  ),
  NavigationItem(
    label: 'Speed Comparator',
    path: '/speed-comparator',
    icon: Icons.speed_outlined,
    activeIcon: Icons.speed_rounded,
  ),
];

const List<AccentOption> accentOptions = [
  AccentOption(
    name: 'Ocean',
    color: Color(0xFF1D4ED8),
    lightBackgroundColor: Color(0xFFEFF5FF),
    hex: '#1D4ED8',
  ),
  AccentOption(
    name: 'Emerald',
    color: Color(0xFF059669),
    lightBackgroundColor: Color(0xFFECFDF5),
    hex: '#059669',
  ),
  AccentOption(
    name: 'Amber',
    color: Color(0xFFD97706),
    lightBackgroundColor: Color(0xFFFFF7ED),
    hex: '#D97706',
  ),
  AccentOption(
    name: 'Rose',
    color: Color(0xFFE11D48),
    lightBackgroundColor: Color(0xFFFFF1F2),
    hex: '#E11D48',
  ),
  AccentOption(
    name: 'Violet',
    color: Color(0xFF7C3AED),
    lightBackgroundColor: Color(0xFFF5F3FF),
    hex: '#7C3AED',
  ),
  AccentOption(
    name: 'Coral',
    color: Color(0xFFEA580C),
    lightBackgroundColor: Color(0xFFFFF7ED),
    hex: '#EA580C',
  ),
  AccentOption(
    name: 'Sky',
    color: Color(0xFF0284C7),
    lightBackgroundColor: Color(0xFFF0F9FF),
    hex: '#0284C7',
  ),
  AccentOption(
    name: 'Mint',
    color: Color(0xFF0F766E),
    lightBackgroundColor: Color(0xFFF0FDFA),
    hex: '#0F766E',
  ),
  AccentOption(
    name: 'Ruby',
    color: Color(0xFFBE123C),
    lightBackgroundColor: Color(0xFFFFF1F2),
    hex: '#BE123C',
  ),
  AccentOption(
    name: 'Slate',
    color: Color(0xFF475569),
    lightBackgroundColor: Color(0xFFF8FAFC),
    hex: '#475569',
  ),
  AccentOption(
    name: 'Indigo',
    color: Color(0xFF4338CA),
    lightBackgroundColor: Color(0xFFEEF2FF),
    hex: '#4338CA',
  ),
  AccentOption(
    name: 'Lime',
    color: Color(0xFF65A30D),
    lightBackgroundColor: Color(0xFFF7FEE7),
    hex: '#65A30D',
  ),
  AccentOption(
    name: 'Magenta',
    color: Color(0xFFC026D3),
    lightBackgroundColor: Color(0xFFFDF4FF),
    hex: '#C026D3',
  ),
  AccentOption(
    name: 'Teal',
    color: Color(0xFF0D9488),
    lightBackgroundColor: Color(0xFFF0FDFA),
    hex: '#0D9488',
  ),
  AccentOption(
    name: 'Gold',
    color: Color(0xFFCA8A04),
    lightBackgroundColor: Color(0xFFFEFCE8),
    hex: '#CA8A04',
  ),
];
