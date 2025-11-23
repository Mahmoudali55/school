import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              "آخر الرسائل",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "عرض الكل",
                style: TextStyle(color: const Color(0xFF2E5BFF), fontSize: 14.sp),
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
