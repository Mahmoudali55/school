import 'package:flutter/material.dart';

class NavItemData {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final Widget screen;
  final bool showBadge;

  NavItemData({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.screen,
    this.showBadge = false,
  });
}
