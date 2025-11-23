import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/features/class/data/model/schedule_Item_model.dart';

class MessageItemWidget extends StatelessWidget {
  final Message message;
  const MessageItemWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: const Color(0xFFE5E7EB), width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: const Color(0xFF2E5BFF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, color: const Color(0xFF2E5BFF), size: 20.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      message.sender,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      message.time,
                      style: TextStyle(fontSize: 10.sp, color: const Color(0xFF9CA3AF)),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  message.preview,
                  style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (message.unread)
            Container(
              width: 8.w,
              height: 8.w,
              decoration: const BoxDecoration(color: Color(0xFF2E5BFF), shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}
