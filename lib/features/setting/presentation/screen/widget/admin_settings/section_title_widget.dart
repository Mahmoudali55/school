import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class SectionTitleWidget extends StatelessWidget {
  const SectionTitleWidget({super.key, required this.title});

  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyle.headlineMedium(
        context,
        color: const Color(0xFF1F2937),
      ).copyWith(fontWeight: FontWeight.bold),
    );
  }
}
