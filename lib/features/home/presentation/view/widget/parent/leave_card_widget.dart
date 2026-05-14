import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/data/models/get_permissions_mobile_model.dart';

class LeaveCard extends StatelessWidget {
  const LeaveCard({required this.request, required this.onEdit});

  final PermissionItem request;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColor.primaryColor(context).withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor:
                      AppColor.primaryColor(context).withValues(alpha: 0.15),
                  child: Text(
                    request.studentName.isNotEmpty
                        ? request.studentName[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: AppColor.primaryColor(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Text(
                    request.studentName,
                    style: AppTextStyle.bodyLarge(context).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _EditButton(onTap: onEdit),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(
                  icon: Icons.description_outlined,
                  label: AppLocalKay.REASON.tr(),
                  value: request.reason,
                ),
                if (request.notes.isNotEmpty) ...[
                  const Gap(10),
                  _InfoRow(
                    icon: Icons.notes_rounded,
                    label: AppLocalKay.NOTES.tr(),
                    value: request.notes,
                  ),
                ],
                const Gap(10),
                _InfoRow(
                  icon: Icons.calendar_month_outlined,
                  label: AppLocalKay.REQUEST_DATE.tr(),
                  value: request.requestDate,
                  valueColor: AppColor.infoColor(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[500]),
        const Gap(8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: AppTextStyle.bodySmall(context).copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: AppTextStyle.bodySmall(context).copyWith(
                    color: valueColor ?? Colors.grey[800],
                    fontWeight: valueColor != null ? FontWeight.w600 : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
class _EditButton extends StatelessWidget {
  const _EditButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColor.warningColor(context).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColor.warningColor(context).withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.edit_rounded,
              size: 14,
              color: AppColor.warningColor(context),
            ),
            const Gap(4),
            Text(
              AppLocalKay.edit.tr(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColor.warningColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
