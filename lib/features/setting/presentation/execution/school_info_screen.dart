import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/setting/presentation/cubit/settings_cubit.dart';
import 'package:my_template/features/setting/presentation/cubit/settings_state.dart';

class SchoolInfoScreen extends StatefulWidget {
  const SchoolInfoScreen({super.key});

  @override
  State<SchoolInfoScreen> createState() => _SchoolInfoScreenState();
}

class _SchoolInfoScreenState extends State<SchoolInfoScreen> {
  @override
  void initState() {
    context.read<SettingsCubit>().getSchoolData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalKay.schoolInfoDetailed.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state.schoolDataStatus.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.schoolDataStatus.isFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.schoolDataStatus.error ?? AppLocalKay.somethingWentWrong.tr()),
                  ElevatedButton(
                    onPressed: () => context.read<SettingsCubit>().getSchoolData(),
                    child: Text(AppLocalKay.retry.tr()),
                  ),
                ],
              ),
            );
          }

          final data = state.schoolDataStatus.data;
          if (data == null) {
            return Center(child: Text(AppLocalKay.noDataAvailable.tr()));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ================= LOGO =================
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primaryColor(context).withValues(alpha: (0.2)),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50.r,
                      backgroundColor: AppColor.whiteColor(context),
                      child: Icon(
                        Icons.school_rounded,
                        size: 50.w,
                        color: AppColor.primaryColor(context),
                      ),
                    ),
                  ),
                ),

                Gap(24.h),

                /// ================= Identity =================
                _SectionHeader(title: AppLocalKay.identityData.tr()),

                _DisplayTile(
                  label: AppLocalKay.schoolNameAr.tr(),
                  value: data.companyName,
                  icon: Icons.business,
                ),
                _DisplayTile(
                  label: AppLocalKay.schoolNameEn.tr(),
                  value: data.companyNameEng,
                  icon: Icons.business,
                ),
                _DisplayTile(
                  label: AppLocalKay.schoolCode.tr(),
                  value: data.schoolCode,
                  icon: Icons.code,
                ),
                _DisplayTile(
                  label: AppLocalKay.commercialRegistration.tr(),
                  value: data.tradeReg,
                  icon: Icons.app_registration,
                ),

                /// ================= Address =================
                _SectionHeader(title: AppLocalKay.addressContact.tr()),

                _DisplayTile(
                  label: AppLocalKay.country.tr(),
                  value: data.countryName,
                  icon: Icons.public,
                ),
                _DisplayTile(
                  label: AppLocalKay.city.tr(),
                  value: data.cityName,
                  icon: Icons.location_city,
                ),
                _DisplayTile(
                  label: AppLocalKay.district.tr(),
                  value: data.districtName,
                  icon: Icons.map,
                ),
                _DisplayTile(
                  label: AppLocalKay.street.tr(),
                  value: data.streetName,
                  icon: Icons.streetview,
                ),
                _DisplayTile(
                  label: AppLocalKay.buildingNumber.tr(),
                  value: data.buildingNo,
                  icon: Icons.home,
                ),
                _DisplayTile(
                  label: AppLocalKay.postalCode.tr(),
                  value: data.postalNo,
                  icon: Icons.location_on,
                ),
                _DisplayTile(label: AppLocalKay.phone1.tr(), value: data.tel1, icon: Icons.phone),
                _DisplayTile(
                  label: AppLocalKay.phone2.tr(),
                  value: data.tel2,
                  icon: Icons.phone_android,
                ),
                _DisplayTile(label: AppLocalKay.fax.tr(), value: data.fax, icon: Icons.fax),

                /// ================= Dates =================
                _SectionHeader(title: AppLocalKay.dates.tr()),

                _DisplayTile(
                  label: AppLocalKay.eduStartDate.tr(),
                  value: data.eduStartDate,
                  icon: Icons.calendar_today,
                ),
                _DisplayTile(
                  label: AppLocalKay.secondTermDate.tr(),
                  value: data.secondTermDate,
                  icon: Icons.calendar_month,
                ),
                _DisplayTile(
                  label: AppLocalKay.startDate.tr(),
                  value: data.startDate,
                  icon: Icons.start,
                ),
                _DisplayTile(
                  label: AppLocalKay.endDate.tr(),
                  value: data.endDate,
                  icon: Icons.event_busy,
                ),

                /// ================= Financial =================
                _SectionHeader(title: AppLocalKay.financialTaxData.tr()),

                _DisplayTile(
                  label: AppLocalKay.vatNumber.tr(),
                  value: data.vatSerial,
                  icon: Icons.numbers,
                ),
                _DisplayTile(
                  label: AppLocalKay.vatPercentage.tr(),
                  value: '${data.vatPrec ?? 0}%',
                  icon: Icons.percent,
                ),
                _DisplayTile(
                  label: AppLocalKay.vatAccountNumber.tr(),
                  value: data.vatAccNo?.toString(),
                  icon: Icons.account_balance,
                ),
                _DisplayTile(
                  label: AppLocalKay.docNature.tr(),
                  value: data.docNature?.toString(),
                  icon: Icons.note,
                ),

                /// ================= System =================
                _SectionHeader(title: AppLocalKay.systemSettingsAccounts.tr()),

                _DisplayTile(
                  label: AppLocalKay.server.tr(),
                  value: data.accountServer,
                  icon: Icons.storage,
                ),
                _DisplayTile(
                  label: AppLocalKay.database.tr(),
                  value: data.accountDatabase,
                  icon: Icons.dns,
                ),
                _DisplayTile(
                  label: AppLocalKay.user.tr(),
                  value: data.accountUser,
                  icon: Icons.person,
                ),

                _DisplayTile(
                  label: AppLocalKay.linkWithAccounts.tr(),
                  value: data.linkWithAcc == true
                      ? AppLocalKay.enabled.tr()
                      : AppLocalKay.disabled.tr(),
                  icon: Icons.link,
                ),

                _DisplayTile(
                  label: AppLocalKay.postingType.tr(),
                  value: data.accPostingType == true
                      ? AppLocalKay.automatic.tr()
                      : AppLocalKay.manual.tr(),
                  icon: Icons.send,
                ),

                _DisplayTile(
                  label: AppLocalKay.glPath.tr(),
                  value: data.glPath,
                  icon: Icons.folder,
                ),
                _DisplayTile(
                  label: AppLocalKay.glExtension.tr(),
                  value: data.glExtent,
                  icon: Icons.file_present,
                ),

                /// ================= Other =================
                _SectionHeader(title: AppLocalKay.others.tr()),

                _DisplayTile(
                  label: AppLocalKay.smsLink.tr(),
                  value: data.http,
                  icon: Icons.message,
                ),
                _DisplayTile(label: AppLocalKay.notes.tr(), value: data.notes, icon: Icons.notes),

                _DisplayTile(
                  label: AppLocalKay.autoCode.tr(),
                  value: data.autoCode == true
                      ? AppLocalKay.enabled.tr()
                      : AppLocalKay.disabled.tr(),
                  icon: Icons.code,
                ),

                Gap(32.h),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// ================= Section Header =================

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Text(
        title,
        style: AppTextStyle.titleMedium(
          context,
        ).copyWith(color: AppColor.primaryColor(context), fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// ================= Display Tile =================

class _DisplayTile extends StatelessWidget {
  final String label;
  final String? value;
  final IconData icon;

  const _DisplayTile({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withValues(alpha: (0.02)),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColor.grey100Color(context)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColor.primaryColor(context).withValues(alpha: (0.5)),
            size: 20.w,
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(color: AppColor.grey600Color(context)),
                ),
                Gap(2.h),
                Text(
                  value != null && value!.isNotEmpty && value != "null" ? value! : "-",
                  style: AppTextStyle.bodyMedium(context).copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
