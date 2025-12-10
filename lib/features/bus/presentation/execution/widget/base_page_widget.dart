import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class BasePageWidget extends StatelessWidget {
  final String title;
  final Widget child;
  final bool withPadding;
  final bool isScrollable;

  const BasePageWidget({
    super.key,
    required this.title,
    required this.child,
    this.withPadding = true,
    this.isScrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: CustomAppBar(
        context,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, size: 22.w),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isScrollable
            ? SingleChildScrollView(
                key: ValueKey(title),
                padding: withPadding
                    ? EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h)
                    : EdgeInsets.zero,
                child: child,
              )
            : Padding(
                padding: withPadding
                    ? EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h)
                    : EdgeInsets.zero,
                child: child,
              ),
      ),
    );
  }
}
