import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_template/core/images/app_images.dart';

enum ToastType { success, error, offline, warning, help }

class CustomToast extends StatelessWidget {
  final ToastType type;
  final String? title;
  final String? icon;
  final String message;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomToast({
    super.key,
    required this.type,
    this.title,
    required this.message,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: backgroundColor ?? _backgroundColor()),
      ),
      child: Row(
        children: [
          Center(
            child: CircleAvatar(
              radius: 24,
              backgroundColor: backgroundColor ?? _backgroundColor(),
              child: SvgPicture.asset(
                icon ?? _icons(),
                height: 30,
                width: 30,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (title != null) ...{
                  Text(
                    title!,
                    style: TextStyle(
                      color: textColor ?? Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 8),
                },
                Text(
                  message,
                  style: TextStyle(
                    color: textColor ?? Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _backgroundColor() {
    switch (type) {
      case ToastType.success:
        return const Color.fromARGB(255, 80, 213, 85);
      case ToastType.error:
        return const Color(0xffff3333);
      case ToastType.offline:
        return const Color(0xFF616161);
      case ToastType.warning:
        return const Color(0xffFFCC00);
      case ToastType.help:
        return const Color(0xff0091EA);
    }
  }

  String _icons() {
    switch (type) {
      case ToastType.success:
        return AppImages.assetsGlobalIconSuccess;
      case ToastType.error:
        return AppImages.assetsGlobalIconErrorIcon;
      case ToastType.offline:
        return AppImages.assetsGlobalIconOfflineIcon;
      case ToastType.warning:
        return AppImages.assetsGlobalIconWarning;
      case ToastType.help:
        return AppImages.assetsGlobalIconHelp;
    }
  }
}
