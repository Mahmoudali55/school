import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';
import 'package:my_template/features/home/presentation/view/widget/teacher_card.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().teacherData(searchVal: '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.teachers_ar.tr(),
          style: AppTextStyle.bodyLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Elegant Search Bar
          Padding(
            padding: EdgeInsets.all(20.w),
            child: CustomFormField(
              controller: _searchController,
              hintText: "البحث عن معلم بالاسم أو الكود...",
              prefixIcon: Icon(
                Icons.search_rounded,
                color: AppColor.primaryColor(context),
                size: 22.sp,
              ),
              onChanged: (val) {
                context.read<HomeCubit>().teacherData(searchVal: val);
              },
              radius: 12.r,
            ),
          ),

          Expanded(
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                final status = state.teacherDataStatus;

                if (status?.isLoading ?? false) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (status?.isFailure ?? false) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: AppColor.errorColor(context),
                          size: 48.sp,
                        ),
                        Gap(16.h),
                        Text(
                          status?.error ?? "حدث خطأ ما أثناء تحميل البيانات",
                          style: AppTextStyle.bodyMedium(context),
                        ),
                      ],
                    ),
                  );
                }

                final teachers = status?.data ?? [];

                if (teachers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_search_rounded,
                          size: 64.sp,
                          color: AppColor.grey200Color(context),
                        ),
                        Gap(16.h),
                        Text(
                          "لا يوجد معلمين مطابقين للبحث",
                          style: AppTextStyle.bodyMedium(
                            context,
                          ).copyWith(color: AppColor.greyColor(context)),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  physics: const BouncingScrollPhysics(),
                  itemCount: teachers.length,
                  itemBuilder: (context, index) {
                    return TeacherCard(
                      teacher: teachers[index],
                      onTap: () {
                        // Action when tapping on a teacher
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
