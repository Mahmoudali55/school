import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/payment/chip_painter_widget.dart';

class CardFront extends StatelessWidget {
  final String formattedNumber;
  final String displayHolder;
  final String displayExpiry;

  const CardFront({
    required this.formattedNumber,
    required this.displayHolder,
    required this.displayExpiry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 195.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          colors: [
            AppColor.primaryColor(context),
            AppColor.primaryColor(context).withValues(alpha: (0.75)),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryColor(context).withValues(alpha: (0.35)),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          _buildDecorativeCircles(context),
          Padding(
            padding: EdgeInsets.all(22.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildChip(),
                    _buildCardTypeLabel(context),
                  ],
                ),

                const Spacer(),

                // ── Card Number ──────────────────────────
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    formattedNumber,
                    key: ValueKey(formattedNumber),
                    style: TextStyle(
                      color: AppColor.whiteColor(context),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.5,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),

                Gap(16.h),

                // ── Bottom Row ───────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoColumn(
                      context,
                      label: AppLocalKay.CARDHOLDER.tr(),
                      value: displayHolder,
                    ),
                    _buildInfoColumn(
                      context,
                      label: AppLocalKay.EXPIRY.tr(),
                      value: displayExpiry,
                      crossAxisAlignment: CrossAxisAlignment.end,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip() {
    return Container(
      width: 42.w,
      height: 30.h,
      decoration: BoxDecoration(
        color: Colors.amber.shade300,
        borderRadius: BorderRadius.circular(6.r),
        gradient: LinearGradient(
          colors: [Colors.amber.shade200, Colors.amber.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: CustomPaint(painter: ChipPainter()),
    );
  }

  Widget _buildCardTypeLabel(BuildContext context) {
    return Text(
      'VISA',
      style: TextStyle(
        color: Colors.white,
        fontSize: 22.sp,
        fontWeight: FontWeight.w800,
        fontStyle: FontStyle.italic,
        letterSpacing: 1.5,
        shadows: const [
          Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(1, 1)),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(
    BuildContext context,
    {required String label,
    required String value,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white60,
            fontSize: 8.sp,
            letterSpacing: 1.2,
          ),
        ),
        Gap(3.h),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            value,
            key: ValueKey(value),
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDecorativeCircles(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -40,
          right: -40,
          child: Container(
            width: 160.w,
            height: 160.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.whiteColor(context).withValues(alpha: (0.06)),
            ),
          ),
        ),
        Positioned(
          bottom: -30,
          right: 40.w,
          child: Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.whiteColor(context).withValues(alpha: (0.08)),
            ),
          ),
        ),
      ],
    );
  }
}

