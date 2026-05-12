import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';
import 'package:my_template/features/home/presentation/view/execution/payment_history_screen.dart';
import 'package:my_template/features/home/presentation/view/execution/payment_receipt_screen.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/payment/credit_card_bottom_sheet.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/payment/bank_transfer_bottom_sheet.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/payment/payment_method_card_widget.dart';

class ShowStudentBalanceScreen extends StatefulWidget {
  const ShowStudentBalanceScreen({super.key});

  @override
  State<ShowStudentBalanceScreen> createState() => _ShowStudentBalanceScreenState();
}

class _ShowStudentBalanceScreenState extends State<ShowStudentBalanceScreen> {
  Map<int, int> selectedPaymentMethods = {}; // index: selected payment method

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().studentBalance(int.parse(HiveMethods.getUserCode()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(AppLocalKay.fees.tr(), style: AppTextStyle.titleLarge(context)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PaymentHistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final balances = state.studentBalanceStatus.data ?? [];

            if (state.studentBalanceStatus.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (balances.isEmpty) {
              return Center(child: Text("لا توجد بيانات", style: AppTextStyle.bodyMedium(context)));
            }

            return ListView.separated(
              itemCount: balances.length,
              separatorBuilder: (_, __) => Gap(16.h),
              itemBuilder: (context, index) {
                final student = balances[index];

                return
                /// تعديل الألوان للشاشة لتكون أكثر عصريّة
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        AppColor.primaryColor(context).withOpacity(0.1), // تدرج ناعم
                        Colors.grey.shade50,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      /// Header
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28.r,
                            backgroundColor: AppColor.primaryColor(context).withOpacity(0.2),
                            child: Icon(
                              Icons.school_rounded,
                              color: AppColor.primaryColor(context),
                              size: 26.sp,
                            ),
                          ),
                          Gap(12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student.studentName,
                                  style: AppTextStyle.titleMedium(
                                    context,
                                  ).copyWith(fontWeight: FontWeight.bold),
                                ),
                                Gap(4.h),
                                Text(
                                  "${AppLocalKay.student_code.tr()} : ${student.studentCode}",
                                  style: AppTextStyle.bodySmall(
                                    context,
                                  ).copyWith(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Gap(16.h),

                      /// Balance
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green.shade100, Colors.green.shade50],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.shade200.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              AppLocalKay.financial_desc.tr(),
                              style: AppTextStyle.bodySmall(
                                context,
                              ).copyWith(color: Colors.green.shade800),
                            ),
                            Gap(6.h),
                            Text(
                              "${student.balance} ${AppLocalKay.sarCurrency.tr()}",
                              style: AppTextStyle.titleLarge(
                                context,
                              ).copyWith(fontWeight: FontWeight.bold, color: Colors.green.shade900),
                            ),
                          ],
                        ),
                      ),

                      Gap(14.h),

                      /// Payment Methods Section
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          AppLocalKay.payment_method.tr(),
                          style: AppTextStyle.bodySmall(context).copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      Gap(10.h),
                      Row(
                        children: [
                          Expanded(
                            child: PaymentMethodCardWidget(
                              image: "assets/image/tabby.jpeg",
                              label: "Tabby",
                              isSelected: (selectedPaymentMethods[index] ?? -1) == 0,
                              onTap: () => setState(() => selectedPaymentMethods[index] = 0),
                            ),
                          ),
                          Gap(12.w),
                          Expanded(
                            child: PaymentMethodCardWidget(
                              
                              image: "assets/image/tamar.jpeg",
                              label: "Tamara",
                              isSelected: (selectedPaymentMethods[index] ?? -1) == 1,
                              onTap: () => setState(() => selectedPaymentMethods[index] = 1),
                            ),
                          ),
                        ],
                      ),
                      Gap(12.h),
                      Row(
                        children: [
                          Expanded(
                            child: PaymentMethodCardWidget(
                              icon: Icons.credit_card,
                              label: AppLocalKay.creditCard.tr(),
                              isSelected: (selectedPaymentMethods[index] ?? -1) == 2,
                              onTap: () => setState(() => selectedPaymentMethods[index] = 2),
                            ),
                          ),
                          Gap(12.w),
                          Expanded(
                            child: PaymentMethodCardWidget(
                              icon: Icons.account_balance,
                              label: AppLocalKay.bankTransfer.tr(),
                              isSelected: (selectedPaymentMethods[index] ?? -1) == 3,
                              onTap: () => setState(() => selectedPaymentMethods[index] = 3),
                            ),
                          ),
                        ],
                      ),

                      Gap(16.h),

                      /// Pay Now Button
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          radius: 12.r,
                          onPressed: () {
                            if ((selectedPaymentMethods[index] ?? -1) == -1) {
                              CommonMethods.showToast(message: AppLocalKay.PAYMENT_METHOD_REQUIRED.tr(),type: ToastType.error);
                              return;
                            }

                            if ((selectedPaymentMethods[index] ?? -1) == 2) {
                              // Show Credit Card Bottom Sheet
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => CreditCardBottomSheet(student: student),
                              );
                              return;
                            }

                            if ((selectedPaymentMethods[index] ?? -1) == 3) {
                              // Show Bank Transfer Bottom Sheet
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => BankTransferBottomSheet(student: student),
                              );
                              return;
                            }
                            
                            // Mocking the payment processing for Tabby/Tamara
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(child: CircularProgressIndicator()),
                            );

                            Future.delayed(const Duration(seconds: 2), () {
                              Navigator.pop(context); // Close dialog

                              final transactionId = 'TRX${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
                              final paymentMethodName = (selectedPaymentMethods[index] ?? -1) == 0 ? 'Tabby' : 'Tamara';
                              final dateStr = DateTime.now().toIso8601String();

                              // Save the receipt locally
                              HiveMethods.savePaymentReceipt({
                                'studentName':  '${student.studentName} ${HiveMethods.getUserName()}',
                                'studentCode': student.studentCode.toString(),
                                'amount': student.balance,
                                'paymentMethod': paymentMethodName,
                                'transactionId': transactionId,
                                'date': dateStr,
                              });

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentReceiptScreen(
                                    studentName: '${student.studentName} ${HiveMethods.getUserName()}',
                                    studentCode: student.studentCode.toString(),
                                    amount: student.balance,
                                    paymentMethod: paymentMethodName,
                                    transactionId: transactionId,
                                    date: DateTime.now(),
                                  ),
                                ),
                              );
                            });
                          },
                          child: Text(
                            AppLocalKay.pay_now.tr(),
                            style: AppTextStyle.bodyMedium(
                              context,
                            ).copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  
}
