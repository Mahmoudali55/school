import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/data/models/student_balance_model.dart';
import 'package:my_template/features/home/presentation/view/execution/payment_receipt_screen.dart';

class CreditCardBottomSheet extends StatefulWidget {
  final StudentBalanceModel student;
  
  const CreditCardBottomSheet({super.key, required this.student});

  @override
  State<CreditCardBottomSheet> createState() => _CreditCardBottomSheetState();
}

class _CreditCardBottomSheetState extends State<CreditCardBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _processPayment() {
    if (!_formKey.currentState!.validate()) return;

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
        'paymentMethod': AppLocalKay.creditCard.tr(),
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
            paymentMethod: AppLocalKay.creditCard.tr(),
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
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColor.greyColor(context).withValues(alpha: (0.3)),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              Gap(20.h),
              Text(
                AppLocalKay.creditCardPayment.tr(),
                style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
              ),
              Gap(16.h),
              
              // Mock Credit Card visual
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColor.primaryColor(context), AppColor.primaryColor(context).withValues(alpha: (0.8))],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.primaryColor(context).withValues(alpha: (0.3)),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.credit_card, color: AppColor.whiteColor(context), size: 30.sp),
                        Text('VISA', style: AppTextStyle.titleMedium(context).copyWith(color: AppColor.whiteColor(context), fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                      ],
                    ),
                    Gap(20.h),
                    Text('**** **** **** ****', style: AppTextStyle.titleLarge(context).copyWith(color: AppColor.whiteColor(context), letterSpacing: 2)),
                    Gap(16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('CARDHOLDER NAME', style: AppTextStyle.labelSmall(context).copyWith(color: Colors.white70)),
                        Text('MM/YY', style: AppTextStyle.labelSmall(context).copyWith(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ),
              Gap(24.h),

              // Inputs
              CustomFormField(
                title: AppLocalKay.cardNumber.tr(),
                prefixIcon: const Icon(Icons.credit_card),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? AppLocalKay.enterCardNumber.tr() : null,
              ),
              Gap(16.h),
              Row(
                children: [
                  Expanded(
                    child: CustomFormField(
                       title : AppLocalKay.expiryDate.tr(),
                        hintText: 'MM/YY',
                        prefixIcon: const Icon(Icons.calendar_today),
                      keyboardType: TextInputType.datetime,
                      validator: (value) => value == null || value.isEmpty ? AppLocalKay.requiredField.tr() : null,
                    ),
                  ),
                  Gap(16.w),
                  Expanded(
                    child: CustomFormField(
                        isPassword: true,
                        title: AppLocalKay.cvv.tr(),
                        prefixIcon: const Icon(Icons.security),
                      keyboardType: TextInputType.number,
                      
                      validator: (value) => value == null || value.isEmpty ? AppLocalKay.requiredField.tr() : null,
                    ),
                  ),
                ],
              ),
              Gap(16.h),
              CustomFormField(
                title: AppLocalKay.cardHolderName.tr(),
                prefixIcon: const Icon(Icons.person),
                validator: (value) => value == null || value.isEmpty ? AppLocalKay.enterCardHolderName.tr() : null,
              ),
              Gap(24.h),

              CustomButton(
                radius: 12.r,
                onPressed: _isLoading ? null : _processPayment,
                child: _isLoading
                    ? SizedBox(width: 20.w, height: 20.w, child:  CustomLoading(color: AppColor.whiteColor(context)))
                    : Text(
                        '${AppLocalKay.pay_now.tr()} (${widget.student.balance}${AppLocalKay.sarCurrency.tr()})',
                        style: AppTextStyle.bodyMedium(context).copyWith(color: AppColor.whiteColor(context), fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
