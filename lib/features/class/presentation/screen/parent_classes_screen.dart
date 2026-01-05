import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/class_state.dart';
import 'package:my_template/features/class/presentation/screen/widget/parent/parent_children_selection.dart';
import 'package:my_template/features/class/presentation/screen/widget/parent/parent_info_card.dart';
import 'package:my_template/features/class/presentation/screen/widget/parent/parent_quick_stats.dart';
import 'package:my_template/features/class/presentation/screen/widget/parent/parent_tabs_section.dart';

class ParentClassScreen extends StatefulWidget {
  const ParentClassScreen({super.key});

  @override
  State<ParentClassScreen> createState() => _ParentClassScreenState();
}

class _ParentClassScreenState extends State<ParentClassScreen> {
  int _selectedIndex = 0;

  final List<Map<String, String>> _children = [
    {'name'.tr(): 'أحمد محمد'.tr(), 'grade'.tr(): 'الصف العاشر'.tr()},
    {'name'.tr(): 'سارة محمد'.tr(), 'grade'.tr(): 'الصف الثامن'.tr()},
    {'name'.tr(): 'فاطمة محمد'.tr(), 'grade'.tr(): 'الصف السادس'.tr()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          AppLocalKay.classes.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: AppColor.whiteColor(context),
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<ClassCubit, ClassState>(
          builder: (context, state) {
            if (state is ClassLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ClassError) {
              return Center(child: Text(state.message));
            } else if (state is ClassLoaded) {
              // For now, parent classes are using StudentClassModel as per ClassRepo
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ParentInfoCard(),
                    const SizedBox(height: 16),
                    ParentChildrenSelection(
                      children: _children,
                      selectedIndex: _selectedIndex,
                      onSelected: (index) => setState(() => _selectedIndex = index),
                    ),
                    const SizedBox(height: 16),
                    const ParentQuickStats(),
                    const SizedBox(height: 16),
                    const Expanded(child: ParentTabsSection()),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
