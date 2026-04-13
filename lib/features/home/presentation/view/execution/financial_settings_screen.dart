// features/finance/presentation/view/financial_settings_page.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/images/app_images.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/data/models/get_income_list_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class FinancialSettingsScreen extends StatefulWidget {
  const FinancialSettingsScreen({super.key});

  @override
  State<FinancialSettingsScreen> createState() => _FinancialSettingsScreenState();
}

class _FinancialSettingsScreenState extends State<FinancialSettingsScreen> {
  String fromDate = '';
  String toDate = '';
  bool _hasSelectedDates = false;

  @override
  void initState() {
    super.initState();
    // Do not call getincomelist here anymore, wait for dates
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        String formattedDate = DateFormat('dd/MM/yyyy', 'en').format(picked);
        if (isFromDate) {
          fromDate = formattedDate;
        } else {
          toDate = formattedDate;
        }

        if (fromDate.isNotEmpty && toDate.isNotEmpty) {
          _hasSelectedDates = true;
          if (context.mounted) {
            context.read<HomeCubit>().getincomelist(fromdate: fromDate, todate: toDate);
          }
        }
      });
    }
  }

  double totalIncome(List<GetIncomeListModel> list) {
    return list.fold(0, (sum, e) => sum + (e.paidValue ?? 0));
  }

  double totalVat(List<GetIncomeListModel> list) {
    return list.fold(0, (sum, e) => sum + (e.vatValue ?? 0));
  }

  Widget _buildDataList(List<GetIncomeListModel> data, Color color, IconData icon) {
    if (data.isEmpty) {
      return Center(
        child: Column(
          children: [
            SvgPicture.asset(
              AppImages.assetsGlobalIconEmptyFolderIcon,
              height: 200.h,
              width: 200.w,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(AppColor.primaryColor(context), BlendMode.srcIn),
            ),
            Gap(20.h),
            Text(
              AppLocalKay.user_management_no_reports.tr(),
              style: AppTextStyle.bodyMedium(context),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: data.length,
      padding: EdgeInsets.only(bottom: 20.h),
      itemBuilder: (context, index) {
        final item = data[index];

        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppColor.whiteColor(context),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.03),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: color, size: 22.w),
              ),

              Gap(12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.locale.languageCode == 'ar'
                          ? (item.companyName ?? '')
                          : (item.companyNameEng ?? ''),
                      style: AppTextStyle.bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
                    ),

                    Gap(4.h),

                    Text(
                      '${item.transDate} | #${item.transNo}',
                      style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey),
                    ),

                    if (item.vatValue != null && item.vatValue! > 0)
                      Text(
                        'VAT: ${item.vatValue} ر.س',
                        style: AppTextStyle.bodySmall(context).copyWith(color: Colors.orange),
                      ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${item.paidValue}',
                    style: AppTextStyle.bodyLarge(
                      context,
                    ).copyWith(fontWeight: FontWeight.bold, color: color),
                  ),
                  Text('SAR', style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateFilter() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _selectDate(context, true),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: AppColor.whiteColor(context),
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    fromDate.isEmpty ? AppLocalKay.start_date.tr() : fromDate,
                    style: AppTextStyle.bodyMedium(
                      context,
                    ).copyWith(color: fromDate.isEmpty ? Colors.grey : Colors.black),
                  ),
                  Icon(Icons.calendar_today, size: 16.w, color: AppColor.primaryColor(context)),
                ],
              ),
            ),
          ),
        ),
        Gap(12.w),
        Expanded(
          child: InkWell(
            onTap: () => _selectDate(context, false),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: AppColor.whiteColor(context),
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    toDate.isEmpty ? AppLocalKay.end_date.tr() : toDate,
                    style: AppTextStyle.bodyMedium(
                      context,
                    ).copyWith(color: toDate.isEmpty ? Colors.grey : Colors.black),
                  ),
                  Icon(Icons.calendar_today, size: 16.w, color: AppColor.primaryColor(context)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalKay.financial_title.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildDateFilter(),
            Gap(16.h),
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (!_hasSelectedDates) {
                    return Center(
                      child: Text(
                        context.locale.languageCode == 'ar'
                            ? 'يرجى إدخال تاريخ البداية والنهاية أولاً'
                            : 'Please select start and end dates first',
                        style: AppTextStyle.bodyMedium(context).copyWith(color: Colors.grey),
                      ),
                    );
                  }

                  if (state.getincomelistStatus.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.getincomelistStatus.isFailure) {
                    return Center(child: Text(state.getincomelistStatus.error ?? ''));
                  }

                  if (state.getincomelistStatus.isSuccess) {
                    final data = state.getincomelistStatus.data ?? [];
                    final revenueData = data.where((e) => e.transType == 1).toList();

                    final income = totalIncome(revenueData);

                    return Column(
                      children: [
                        _buildFinancialSummary(income),

                        Gap(20.h),

                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            AppLocalKay.user_management_Fees.tr(),
                            style: AppTextStyle.titleMedium(
                              context,
                            ).copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),

                        Gap(12.h),

                        Expanded(
                          child: _buildDataList(revenueData, Colors.green, Icons.attach_money),
                        ),
                      ],
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialSummary(double income) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  "${income.toStringAsFixed(0)} ر.س",
                  style: AppTextStyle.titleLarge(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold, color: Colors.green),
                ),
                Gap(4.h),
                Text(
                  AppLocalKay.total_fees.tr(),
                  style: AppTextStyle.bodyMedium(context).copyWith(color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
