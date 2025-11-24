import 'package:flutter/material.dart';

BoxDecoration cardStyle() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
  ],
);
