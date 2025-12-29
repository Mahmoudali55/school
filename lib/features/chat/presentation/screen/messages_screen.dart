import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/chat/presentation/screen/single_message_screen.dart';

class ChatsListScreen extends StatelessWidget {
  const ChatsListScreen({super.key});

  final List<String> chats = const [
    "أحمد محمود",
    "محمد أحمد",
    "سارة عبدالله",
    "فاطمة خالد",
    "خالد إبراهيم",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.messages.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Text(chats[index][0])),
            title: Text(chats[index]),
            subtitle: Text(AppLocalKay.last_message.tr(), style: AppTextStyle.bodySmall(context)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChatScreen(chatWith: chats[index])),
              );
            },
            trailing: Text("12:00AM", style: AppTextStyle.bodySmall(context)),
          );
        },
      ),
    );
  }
}
