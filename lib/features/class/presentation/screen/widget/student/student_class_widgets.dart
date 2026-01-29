import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class StudentClassCard extends StatelessWidget {
  final String className;
  final String notes;

  final VoidCallback onEnter;

  const StudentClassCard({
    super.key,
    required this.className,
    required this.notes,
    required this.onEnter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade50),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onEnter,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon Container with gradient
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF2E3192).withValues(alpha: 0.1),
                          const Color(0xFF1BFFFF).withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.menu_book_rounded, color: Color(0xFF2E3192), size: 28),
                  ),
                  const SizedBox(width: 16),
                  // Class Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          className,
                          style: AppTextStyle.titleMedium(
                            context,
                          ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF2E3192)),
                        ),
                        if (notes.isNotEmpty && notes != "null") ...[
                          const SizedBox(height: 4),
                          Text(
                            notes,
                            style: AppTextStyle.bodySmall(
                              context,
                            ).copyWith(color: Colors.grey.shade600),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Action Icon
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(color: Colors.grey.shade50, shape: BoxShape.circle),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: Color(0xFF2E3192),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
