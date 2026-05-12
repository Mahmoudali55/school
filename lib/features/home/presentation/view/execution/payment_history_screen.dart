import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/presentation/view/execution/payment_receipt_screen.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List<Map<String, dynamic>> _receipts = [];

  @override
  void initState() {
    super.initState();
    _loadReceipts();
  }

  void _loadReceipts() {
    setState(() {
      _receipts = HiveMethods.getPaymentReceipts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      appBar: CustomAppBar(
        context,
        title: Text(AppLocalKay.paymentHistory.tr(), style: AppTextStyle.titleLarge(context)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _receipts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_rounded, size: 80.sp, color: AppColor.greyColor(context).withValues(alpha: (0.3))),
                  Gap(16.h),
                  Text(
                    AppLocalKay.noPreviousReceipts.tr(),
                    style: AppTextStyle.titleMedium(context).copyWith(color: AppColor.greyColor(context).withValues(alpha: (0.6))),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: _receipts.length,
              separatorBuilder: (_, __) => Gap(12.h),
              itemBuilder: (context, index) {
                final receipt = _receipts[index];
                final DateTime date = DateTime.tryParse(receipt['date'] ?? '') ?? DateTime.now();

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentReceiptScreen(
                          studentName: receipt['studentName'] ?? '',
                          studentCode: receipt['studentCode'] ?? '',
                          amount: receipt['amount'] ?? 0,
                          paymentMethod: receipt['paymentMethod'] ?? '',
                          transactionId: receipt['transactionId'] ?? '',
                          date: date,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor(context),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.blackColor(context).withValues(alpha: (0.04)),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor(context).withValues(alpha: (0.1)),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.receipt_rounded,
                            color: AppColor.primaryColor(context),
                          ),
                        ),
                        Gap(16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalKay.receiptAmount.tr().replaceAll('{amount}', receipt['amount'].toString()),
                                style: AppTextStyle.titleMedium(context).copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Gap(4.h),
                                Text(
                                  receipt['studentName'] ?? '',
                                  style: AppTextStyle.bodySmall(context).copyWith(
                                    color: AppColor.greyColor(context).withValues(alpha: (0.6)),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Gap(16.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              DateFormat('yyyy/MM/dd', 'ar').format(date),
                              style: AppTextStyle.labelMedium(context).copyWith(
                                color: AppColor.greyColor(context).withValues(alpha: (0.6)),
                              ),
                            ),
                            Gap(4.h),
                            Text(
                              receipt['paymentMethod'] ?? '',
                              style: AppTextStyle.labelSmall(context).copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColor.primaryColor(context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
