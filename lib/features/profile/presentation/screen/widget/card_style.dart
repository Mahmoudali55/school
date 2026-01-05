import 'package:flutter/material.dart';

BoxDecoration cardStyle() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withAlpha((0.05 * 255).round()),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ],
);
