import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/get_T_home_work_model.dart';
import 'package:my_template/features/class/presentation/screen/widget/teacher/teacher_lessons_sheet_widgets/attachment_button_widget.dart';

class HomeworkCard extends StatelessWidget {
  final THomeWorkItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const HomeworkCard({super.key, required this.item, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 30, left: 8, right: 8),
        decoration: BoxDecoration(
          color: AppColor.whiteColor(context),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColor.blackColor(context).withValues(alpha: 0.1),
              blurRadius: 25,
              spreadRadius: 0,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top accent bar
            Container(
              height: 5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFf093fb)],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course name with badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFF667eea).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFF667eea).withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.school, size: 16, color: Color(0xFF667eea)),
                        const Gap(8),
                        Text(
                          item.courseName,
                          style: TextStyle(
                            color: Color(0xFF667eea),
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Gap(20),

                  // Homework title
                  Text(
                    "📝 ${item.hw}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),

                  const Gap(16),

                  // Notes section
                  if (item.notes.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFfff5f7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFFfed7e2)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.sticky_note_2, color: Color(0xFFed64a6), size: 20),
                          const Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalKay.note.tr(),
                                  style: TextStyle(
                                    color: Color(0xFFb83280),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                                const Gap(4),
                                Text(
                                  item.notes,
                                  style: TextStyle(color: Color(0xFF702459), fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                  ],

                  // Date and actions row
                  Row(
                    children: [
                      // Date
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFFf0fff4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, size: 16, color: Color(0xFF38a169)),
                            const Gap(8),
                            Text(
                              item.hwDate,
                              style: TextStyle(
                                color: Color(0xFF38a169),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Action buttons
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            _buildModernButton(
                              icon: Icons.edit,
                              label: AppLocalKay.edit.tr(),
                              color: AppColor.primaryColor(context),
                              onTap: onEdit,
                            ),
                            const Gap(5),
                            _buildModernButton(
                              icon: Icons.delete,
                              label: AppLocalKay.delete.tr(),
                              color: AppColor.errorColor(context),
                              onTap: onDelete,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gap(10.h),
                  AttachmentButton(lessonPath: item.hW_path),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 18),
              const Gap(6),
              Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
