import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/data/model/bus_tracking_models.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_cubit.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_state.dart';

class BusDetails extends StatelessWidget {
  final BusClass selectedBusData;
  final VoidCallback? onRouteLineTapped;

  const BusDetails({super.key, required this.selectedBusData, this.onRouteLineTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: BlocBuilder<BusCubit, BusState>(
        builder: (context, state) {
          final busStatus = state.busStatus;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalKay.route_details.tr(),
                style: AppTextStyle.titleLarge(
                  context,
                ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
              ),
              SizedBox(height: 16.h),

              // Loading state
              if (busStatus.isLoading)
                Center(
                  child: Padding(padding: EdgeInsets.all(20.h), child: const CustomLoading()),
                )
              // Error state
              else if (busStatus.isFailure)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.h),
                    child: Text(
                      busStatus.error ?? "خطأ في تحميل بيانات الحافلة",
                      style: AppTextStyle.bodyMedium(
                        context,
                      ).copyWith(color: AppColor.errorColor(context)),
                    ),
                  ),
                )
              // Success state with data
              else if (busStatus.isSuccess && busStatus.data != null && busStatus.data!.isNotEmpty)
                _buildBusLineDetails(context, busStatus.data!.first)
              // Default fallback
              else
                _buildDefaultDetails(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBusLineDetails(BuildContext context, busLine) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: 1.1,
      children: [
        _buildDetailItem(
          context,
          AppLocalKay.bus_number.tr(),
          busLine.plateNo,
          Icons.confirmation_number_rounded,
        ),
        _buildDetailItem(
          context,
          AppLocalKay.bag_type.tr(),
          busLine.busType,
          Icons.directions_bus_rounded,
        ),
        _buildDetailItem(
          context,
          AppLocalKay.driver.tr(),
          busLine.busDriverName,
          Icons.person_rounded,
        ),
        _buildDetailItem(context, AppLocalKay.phone.tr(), busLine.mobileNo, Icons.phone_rounded),
        _buildDetailItem(
          context,
          AppLocalKay.supervisor.tr(),
          busLine.busSupervisorName1,
          Icons.supervisor_account_rounded,
        ),
        _buildDetailItem(
          context,
          AppLocalKay.supervisor_phone.tr(),
          busLine.supMobileNo ?? "---",
          Icons.phone_in_talk_rounded,
        ),
        GestureDetector(
          onTap: onRouteLineTapped,
          child: _buildDetailItem(
            context,
            AppLocalKay.line.tr(),
            busLine.busLineName,
            Icons.route_rounded,
            isTappable: true,
          ),
        ),
        _buildDetailItem(
          context,
          AppLocalKay.capacity.tr(),
          "${busLine.busSetsUsed}/${busLine.busSets}",
          Icons.event_seat_rounded,
        ),
      ],
    );
  }

  Widget _buildDefaultDetails(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: 1.1,
      children: [
        _buildDetailItem(
          context,
          AppLocalKay.bus_number.tr(),
          selectedBusData.busNumber,
          Icons.directions_bus_rounded,
        ),
        _buildDetailItem(
          context,
          AppLocalKay.driver.tr(),
          selectedBusData.driverName,
          Icons.person_rounded,
        ),
        _buildDetailItem(context, AppLocalKay.phone.tr(), "---", Icons.phone_rounded),
        _buildDetailItem(
          context,
          AppLocalKay.current_location.tr(),
          selectedBusData.currentLocation,
          Icons.location_on_rounded,
        ),
        _buildDetailItem(
          context,
          AppLocalKay.next_stop.tr(),
          selectedBusData.nextStop,
          Icons.flag_rounded,
        ),
        _buildDetailItem(
          context,
          AppLocalKay.capacity.tr(),
          "${selectedBusData.studentsOnBus}/${selectedBusData.totalStudents}",
          Icons.people_rounded,
        ),
      ],
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    String title,
    String value,
    IconData icon, {
    bool isTappable = false,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isTappable
            ? AppColor.primaryColor(context).withOpacity(0.05)
            : const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isTappable
              ? AppColor.primaryColor(context).withOpacity(0.3)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: selectedBusData.busColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16.w, color: selectedBusData.busColor),
          ),
          SizedBox(height: 8.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: AppTextStyle.bodySmall(context).copyWith(color: const Color(0xFF6B7280)),
              ),
              if (isTappable) ...[
                SizedBox(width: 4.w),
                Icon(Icons.touch_app_rounded, size: 12.w, color: AppColor.primaryColor(context)),
              ],
            ],
          ),
          SizedBox(height: 8.w),
          Text(
            value,
            style: AppTextStyle.titleSmall(
              context,
            ).copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF1F2937)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
