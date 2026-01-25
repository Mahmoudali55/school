import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/data/models/home_models.dart';

class ParentChildrenSelection extends StatelessWidget {
  final List<StudentMiniInfo> children;
  final int selectedIndex;
  final Function(int) onSelected;

  const ParentChildrenSelection({
    super.key,
    required this.children,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalKay.select_child.tr(),
          style: AppTextStyle.bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: children.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, index) {
              final c = children[index];
              final selected = selectedIndex == index;
              return GestureDetector(
                onTap: () => onSelected(index),
                child: _childChip(
                  context,
                  name: c.name,
                  grade: c.studentCode,
                  isSelected: selected,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _childChip(
    BuildContext context, {
    required String name,
    required int grade,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? Colors.blue[50] : AppColor.whiteColor(context),
        border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: Icon(Icons.person, color: Colors.blue[700]),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.bodySmall(context).copyWith(
                    color: isSelected ? Colors.blue[700] : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  int.tryParse(grade.toString())?.toString() ?? '',
                  style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
