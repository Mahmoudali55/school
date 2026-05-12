// ─── credit_card_bottom_sheet.dart ──────────────────────────────

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/credit_card_validators.dart';
import 'package:my_template/features/home/data/models/student_balance_model.dart';
import 'package:my_template/features/home/presentation/view/execution/payment_receipt_screen.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/payment/animated_credit_card_widget.dart';

class CreditCardBottomSheet extends StatefulWidget {
  final StudentBalanceModel student;

  const CreditCardBottomSheet({super.key, required this.student});

  @override
  State<CreditCardBottomSheet> createState() => _CreditCardBottomSheetState();
}

class _CreditCardBottomSheetState extends State<CreditCardBottomSheet> {
  // ─── Keys & State ────────────────────────────────────────────

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isFlipped = false;

  // ─── Controllers ─────────────────────────────────────────────

  final _cardNumberCtrl = TextEditingController();
  final _cardHolderCtrl = TextEditingController();
  final _expiryCtrl     = TextEditingController();
  final _cvvCtrl        = TextEditingController();

  // ─── Lifecycle ───────────────────────────────────────────────

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _cardHolderCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  // ─── Payment ─────────────────────────────────────────────────

  void _processPayment() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      final transactionId =
          'TRX${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
      final dateStr = DateTime.now().toIso8601String();

      HiveMethods.savePaymentReceipt({
        'studentName': widget.student.studentName,
        'studentCode': widget.student.studentCode.toString(),
        'amount': widget.student.balance,
        'paymentMethod': AppLocalKay.creditCard.tr(),
        'transactionId': transactionId,
        'date': dateStr,
      });

      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentReceiptScreen(
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

  // ─── Build ───────────────────────────────────────────────────

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
              _buildHandle(context),
              Gap(20.h),
              _buildTitle(context),
              Gap(20.h),

              // ── Animated Card ─────────────────────────────
              AnimatedCreditCard(
                cardNumber: _cardNumberCtrl.text,
                cardHolder: _cardHolderCtrl.text,
                expiry: _expiryCtrl.text,
                cvv: _cvvCtrl.text,
                isFlipped: _isFlipped,
              ),

              Gap(28.h),
              _buildForm(context),
              Gap(24.h),
              _buildPayButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Widgets ─────────────────────────────────────────────────

  Widget _buildHandle(BuildContext context) {
    return Center(
      child: Container(
        width: 40.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: AppColor.greyColor(context).withOpacity(0.3),
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      AppLocalKay.creditCardPayment.tr(),
      style: AppTextStyle.titleLarge(context)
          .copyWith(fontWeight: FontWeight.bold),
    );
  }

  // ─── في _buildForm داخل credit_card_bottom_sheet.dart ───────────

Widget _buildForm(BuildContext context) {
  return Column(
    children: [
      // ── Card Number ──────────────────────────────────────
      CustomFormField(
        controller: _cardNumberCtrl,
        title: AppLocalKay.cardNumber.tr(),
        prefixIcon: const Icon(Icons.credit_card),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(16),
          _CardNumberFormatter(),           // يضيف مسافة كل 4 أرقام
        ],
        onChanged: (_) => setState(() {}),
        validator: CreditCardValidators.validateCardNumber,
      ),
      Gap(16.h),

      // ── Cardholder Name ──────────────────────────────────
      CustomFormField(
        controller: _cardHolderCtrl,
        title: AppLocalKay.cardHolderName.tr(),
        prefixIcon: const Icon(Icons.person_outline_rounded),
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
          LengthLimitingTextInputFormatter(26),
        ],
        onChanged: (_) => setState(() {}),
        validator: CreditCardValidators.validateCardHolder,
      ),
      Gap(16.h),

      // ── Expiry + CVV ─────────────────────────────────────
      Row(
        children: [
          Expanded(
            child: CustomFormField(
              controller: _expiryCtrl,
              title: AppLocalKay.expiryDate.tr(),
              hintText: 'MM/YY',
              prefixIcon: const Icon(Icons.calendar_today_outlined),
              keyboardType: TextInputType.datetime,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
                _ExpiryDateFormatter(),     // يضيف / تلقائياً
              ],
              onChanged: (_) => setState(() {}),
              validator: CreditCardValidators.validateExpiry,
            ),
          ),
          Gap(16.w),
          Expanded(
            child: CustomFormField(
              controller: _cvvCtrl,
              title: AppLocalKay.cvv.tr(),
              prefixIcon: const Icon(Icons.security_outlined),
              isPassword: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              onChanged: (_) => setState(() => _isFlipped = true),
              onEditingComplete: () => setState(() => _isFlipped = false),
              validator: CreditCardValidators.validateCvv,
            ),
          ),
        ],
      ),
    ],
  );
}

  Widget _buildPayButton(BuildContext context) {
    return CustomButton(
      radius: 12.r,
      onPressed: _isLoading ? null : _processPayment,
      child: _isLoading
          ? SizedBox(
              width: 20.w,
              height: 20.w,
              child: CustomLoading(color: AppColor.whiteColor(context)),
            )
          : Text(
              '${AppLocalKay.pay_now.tr()} (${widget.student.balance}${AppLocalKay.sarCurrency.tr()})',
              style: AppTextStyle.bodyMedium(context).copyWith(
                color: AppColor.whiteColor(context),
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
// ─── _CardNumberFormatter ────────────────────────────────────────

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
// ─── _ExpiryDateFormatter ────────────────────────────────────────

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}