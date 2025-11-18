import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/on_boarding/presentation/view/cubit/on_boarding_cubit.dart';
import 'package:my_template/features/on_boarding/presentation/view/cubit/on_boarding_state.dart';
import 'package:my_template/features/on_boarding/presentation/view/screen/widget/custom_dots_list_Index_widget.dart';
import 'package:my_template/features/on_boarding/presentation/view/screen/widget/custom_page_view_widget.dart';
import 'package:my_template/features/on_boarding/presentation/view/screen/widget/custom_text_header_widget.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingCubit, OnBoardingState>(
      builder: (context, state) {
        final cubit = context.read<OnBoardingCubit>();
        return Scaffold(
          backgroundColor: AppColor.whiteColor(context),
          body: SafeArea(
            child: Column(
              children: [
                const CustomTextHeaderWidget(),
                Expanded(
                  child: PageView.builder(
                    controller: cubit.pageController,
                    itemCount: state.onboardingData.length,
                    onPageChanged: cubit.changePage,
                    itemBuilder: (context, index) {
                      final page = state.onboardingData[index];
                      return CustomPageViewWidget(page: page);
                    },
                  ),
                ),
                CustomDotsListIndexWidget(state: state),
                Gap(20.h),
                CustomButton(
                  radius: 12,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    cubit.isLastPage() ? AppLocalKay.done.tr() : AppLocalKay.next.tr(),
                    style: AppTextStyle.text16MSecond(context, color: AppColor.whiteColor(context)),
                  ),
                  onPressed: () => cubit.nextPage(context),
                ),
                Gap(20.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
