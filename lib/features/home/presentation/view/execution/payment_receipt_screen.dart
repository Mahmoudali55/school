import 'dart:io';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class PaymentReceiptScreen extends StatefulWidget {
  final String studentName;
  final String studentCode;
  final num amount;
  final String paymentMethod;
  final String transactionId;
  final DateTime? date;

  const PaymentReceiptScreen({
    super.key,
    required this.studentName,
    required this.studentCode,
    required this.amount,
    required this.paymentMethod,
    required this.transactionId,
    this.date,
  });

  @override
  State<PaymentReceiptScreen> createState() => _PaymentReceiptScreenState();
}

class _PaymentReceiptScreenState extends State<PaymentReceiptScreen> {
  final GlobalKey _globalKey = GlobalKey();
  bool _isSharing = false;

  Future<void> _captureAndShareReceipt() async {
    setState(() {
      _isSharing = true;
    });

    try {
      // Small delay to ensure any layout updates finish
      await Future.delayed(const Duration(milliseconds: 100));

      final RenderRepaintBoundary boundary =
          _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/receipt_${widget.transactionId}.png');
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles([XFile(file.path)], text: AppLocalKay.paymentReceiptShareText.tr().replaceAll('{studentName}', widget.studentName));
    } catch (e) {
      if (mounted) {
        CommonMethods.showToast( message: AppLocalKay.shareError.tr().replaceAll('{error}', e.toString()));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor(context),
      appBar: CustomAppBar(
        context,
        title: Text(AppLocalKay.paymentReceipt.tr(), style: AppTextStyle.titleLarge(context)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Center(
                child: RepaintBoundary(
                  key: _globalKey,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor(context),
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.blackColor(context).withValues(alpha: (0.05)),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// Success Icon
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 64.sp,
                          ),
                        ),
                        Gap(16.h),

                        /// Title
                        Text(
                          AppLocalKay.paymentSuccess.tr(),
                          style: AppTextStyle.titleLarge(context).copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                        Gap(8.h),

                        /// Amount
                        Text(
                          '${widget.amount} ${AppLocalKay.sarCurrency.tr()}',
                          style: AppTextStyle.displayMedium(context).copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryColor(context),
                          ),
                        ),
                        Gap(24.h),

                        /// Divider with dashes
                        Row(
                          children: List.generate(
                            30,
                            (index) => Expanded(
                              child: Container(
                                color: index % 2 == 0 ? AppColor.greyColor(context).withValues(alpha: (0.3)) : Colors.transparent,
                                height: 2,
                              ),
                            ),
                          ),
                        ),
                        Gap(24.h),

                        /// Details Section
                        _buildDetailRow(context, AppLocalKay.studentName.tr(), widget.studentName),
                        Gap(16.h),
                        _buildDetailRow(context, AppLocalKay.studentCode.tr(), widget.studentCode),
                        Gap(16.h),
                        _buildDetailRow(
                          context,
                          AppLocalKay.paymentMethod.tr(),
                          widget.paymentMethod,
                          isHighlight: true,
                        ),
                        Gap(16.h),
                        _buildDetailRow(context, AppLocalKay.transactionId.tr(), widget.transactionId),
                        Gap(16.h),
                        _buildDetailRow(
                          context,
                          AppLocalKay.paymentDateTime.tr(),
                          DateFormat('yyyy/MM/dd hh:mm a', 'en').format(widget.date ?? DateTime.now()),
                        ),
                        Gap(32.h),

                        /// Footer or Logo
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.school_rounded, color: AppColor.greyColor(context).withValues(alpha: (0.4)), size: 24.sp),
                            Gap(8.w),
                            Text(
                              AppLocalKay.schoolManagementSystem.tr(),
                              style: AppTextStyle.bodySmall(context).copyWith(
                                color: AppColor.greyColor(context).withValues(alpha: (0.4)),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// Share Action Button
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColor.whiteColor(context),
              boxShadow: [
                BoxShadow(
                  color: AppColor.blackColor(context).withValues(alpha: (0.05)),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 54.h,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor(context),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                  elevation: 0,
                ),
                onPressed: _isSharing ? null : _captureAndShareReceipt,
                icon: _isSharing
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child:  CircularProgressIndicator(
                          color: AppColor.whiteColor(context),
                          strokeWidth: 2,
                        ),
                      )
                    :  Icon(Icons.share_rounded, color: AppColor.whiteColor(context)),
                label: Text(
                  AppLocalKay.share.tr(),
                  style: AppTextStyle.titleMedium(context).copyWith(
                    color: AppColor.whiteColor(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String title, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyle.bodyMedium(context).copyWith(color: AppColor.greyColor(context).withValues(alpha: (0.6))),
        ),
        Text(
          value,
          style: AppTextStyle.bodyMedium(context).copyWith(
            fontWeight: FontWeight.bold,
            color: isHighlight ? AppColor.primaryColor(context) : AppColor.greyColor(context).withValues(alpha: (0.8)),
          ),
        ),
      ],
    );
  }
}
