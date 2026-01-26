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

            return ListView.builder(
              itemCount: balances.length,
              itemBuilder: (context, index) {
                final student = balances[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 4,
                  shadowColor: Colors.black12,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30.r,
                          backgroundColor: AppColor.primaryColor(context).withOpacity(0.2),
                          child: Icon(
                            Icons.person,
                            color: AppColor.primaryColor(context),
                            size: 28.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
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
                                "كود الطالب: ${student.studentCode}",
                                style: AppTextStyle.bodySmall(
                                  context,
                                ).copyWith(color: Colors.grey[600]),
                              ),
                              SizedBox(height: 8.h),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  AppLocalKay.pay_now.tr(),
                                  style: AppTextStyle.bodySmall(context).copyWith(
                                    color: AppColor.primaryColor(context),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${student.balance} ر.س",
                            style: AppTextStyle.titleMedium(
                              context,
                            ).copyWith(fontWeight: FontWeight.bold, color: Colors.green[700]),
                          ),
                        ),
                      ],
                    ),
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
