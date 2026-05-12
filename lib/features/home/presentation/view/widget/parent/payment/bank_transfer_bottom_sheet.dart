import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/home/data/models/student_balance_model.dart';
import 'package:my_template/features/home/presentation/view/execution/payment_receipt_screen.dart';

class BankTransferBottomSheet extends StatefulWidget {
  final StudentBalanceModel student;
  
  const BankTransferBottomSheet({super.key, required this.student});

  @override
  State<BankTransferBottomSheet> createState() => _BankTransferBottomSheetState();
}

class _BankTransferBottomSheetState extends State<BankTransferBottomSheet> {
  File? _receiptImage;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _receiptImage = File(image.path);
      });
    }
  }

  void _processTransfer() {
    if (_receiptImage == null) {
      CommonMethods.showToast(message: AppLocalKay.attachReceiptFirst.tr());
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Mock processing delay
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      final transactionId = 'TRX${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
      final dateStr = DateTime.now().toIso8601String();

      // Save receipt locally
      HiveMethods.savePaymentReceipt({
        'studentName': widget.student.studentName,
        'studentCode': widget.student.studentCode.toString(),
        'amount': widget.student.balance,
        'paymentMethod': AppLocalKay.bankTransfer.tr(),
        'transactionId': transactionId,
        'date': dateStr,
      });

      Navigator.pop(context); // Close bottom sheet
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentReceiptScreen(
            studentName: widget.student.studentName,
            studentCode: widget.student.studentCode.toString(),
            amount: widget.student.balance,
            paymentMethod: AppLocalKay.bankTransfer.tr(),
            transactionId: transactionId,
            date: DateTime.now(),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColor.greyColor(context).withValues(alpha: (0.3)) ,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          Gap(20.h),
          Text(
            AppLocalKay.bankTransferConfirmation.tr(),
            style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
          ),
          Gap(8.h),
          Text(
            AppLocalKay.bankTransferInstruction.tr(),
            style: AppTextStyle.bodyMedium(context).copyWith(color: AppColor.greyColor(context).withValues(alpha: (0.6))),
          ),
          Gap(24.h),

          // Upload Area
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: double.infinity,
              height: 180.h,
              decoration: BoxDecoration(
                color: AppColor.greyColor(context).withValues(alpha: (0.1)),
                border: Border.all(
                  color: _receiptImage != null ? AppColor.primaryColor(context) : AppColor.greyColor(context).withValues(alpha: (0.3)),
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: _receiptImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(14.r),
                      child: Image.file(_receiptImage!, fit: BoxFit.cover),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload_rounded, size: 48.sp, color: AppColor.greyColor(context).withValues(alpha: (0.4))),
                        Gap(12.h),
                        Text(
                          AppLocalKay.uploadReceiptImage.tr(),
                          style: AppTextStyle.bodyMedium(context).copyWith(
                            color: AppColor.greyColor(context).withValues(alpha: (0.6)),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          Gap(24.h),

          CustomButton(
            radius: 12.r,
            onPressed: _isLoading ? null : _processTransfer,
            child: _isLoading
                ? SizedBox(width: 20.w, height: 20.w, child:  CustomLoading(color: AppColor.whiteColor(context), ))
                : Text(
                    AppLocalKay.sendAndConfirmPayment.tr(),
                    style: AppTextStyle.bodyMedium(context).copyWith(color: AppColor.whiteColor(context), fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
    );
  }
}
