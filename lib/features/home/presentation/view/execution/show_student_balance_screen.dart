import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class ShowStudentBalanceScreen extends StatefulWidget {
  const ShowStudentBalanceScreen({super.key});

  @override
  State<ShowStudentBalanceScreen> createState() => _ShowStudentBalanceScreenState();
}

class _ShowStudentBalanceScreenState extends State<ShowStudentBalanceScreen> {
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
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
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
                          SizedBox(width: 12.w),
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
                                SizedBox(height: 4.h),
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

                      SizedBox(height: 16.h),

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
                            SizedBox(height: 6.h),
                            Text(
                              "${student.balance} ر.س",
                              style: AppTextStyle.titleLarge(
                                context,
                              ).copyWith(fontWeight: FontWeight.bold, color: Colors.green.shade900),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 14.h),

                      /// Pay Now Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primaryColor(context),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 3,
                            shadowColor: AppColor.primaryColor(context).withOpacity(0.4),
                          ),
                          onPressed: () {
                            // TODO: navigate to payment
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
