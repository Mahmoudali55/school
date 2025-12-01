import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/navigator_methods.dart';
import 'package:my_template/features/class/data/model/schedule_Item_model.dart';
import 'package:my_template/features/home/presentation/view/widget/teacher/message_item_widget.dart';

class RecentMessagesWidget extends StatelessWidget {
  const RecentMessagesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<Message> messages = [
      Message(
        sender: "ولى أمر - أحمد محمود",
        preview: "هل يمكن توضيح الدرس الجديد؟",
        time: "منذ ٢ ساعة",
        unread: true,
      ),
      Message(
        sender: "الطالب - محمد أحمد",
        preview: "شكراً على الشرح الوافي",
        time: "منذ ٥ ساعات",
        unread: false,
      ),
      Message(
        sender: "إدارة المدرسة",
        preview: "اجتماع المعلمين يوم الخميس",
        time: "منذ يوم",
        unread: false,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalKay.last_messages.tr(),
              style: AppTextStyle.bodyLarge(
                context,
              ).copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF1F2937)),
            ),
            TextButton(
              onPressed: () {
                NavigatorMethods.pushNamed(context, RoutesName.messagesScreen);
              },
              child: Text(
                AppLocalKay.show_all.tr(),
                style: AppTextStyle.bodyMedium(
                  context,
                ).copyWith(color: AppColor.primaryColor(context)),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Column(children: messages.map((msg) => MessageItemWidget(message: msg)).toList()),
      ],
    );
  }
}
