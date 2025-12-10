import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/presentation/execution/widget/base_page_widget.dart';

class TakeAttendanceScreen extends StatefulWidget {
  const TakeAttendanceScreen({super.key});

  @override
  State<TakeAttendanceScreen> createState() => _TakeAttendanceScreenState();
}

class _TakeAttendanceScreenState extends State<TakeAttendanceScreen> {
  final List<bool> _attendance = List.generate(20, (_) => false);

  @override
  Widget build(BuildContext context) {
    return BasePageWidget(
      title: AppLocalKay.check_in.tr(),
      isScrollable: false,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _attendance.length,
              itemBuilder: (context, index) {
                final isPresent = _attendance[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
                  elevation: 2,
                  shadowColor: Colors.grey.shade200,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isPresent ? Colors.green.shade100 : Colors.grey.shade200,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isPresent ? Colors.green.shade800 : Colors.grey.shade600,
                        ),
                      ),
                    ),
                    title: Text('${AppLocalKay.student.tr()} ${index + 1}'),
                    trailing: Checkbox(
                      value: isPresent,
                      activeColor: Colors.green,
                      onChanged: (value) {
                        setState(() => _attendance[index] = value!);
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 12.h),

          CustomButton(
            radius: 12.r,
            color: AppColor.accentColor(context),
            text: AppLocalKay.check_in.tr(),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
