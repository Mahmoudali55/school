import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

import '../../extension/context_extension.dart';
import '../../images/app_images.dart';
import '../../theme/app_colors.dart';
import '../glass_container.dart';

class SecurityGate extends StatefulWidget {
  final Widget child;
  const SecurityGate({super.key, required this.child});

  @override
  State<SecurityGate> createState() => _SecurityGateState();
}

class _SecurityGateState extends State<SecurityGate> {
  bool _isCompromised = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkDeviceIntegrity();
  }

  Future<void> _checkDeviceIntegrity() async {
    try {
      final isJailbroken = await FlutterJailbreakDetection.jailbroken;
      if (mounted) {
        setState(() {
          _isCompromised = isJailbroken;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("SecurityGate: Error checking device integrity: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColor.scaffoldColor(context),
        body: Center(
          child: CircularProgressIndicator(
            color: AppColor.primaryColor(context),
          ),
        ),
      );
    }

    if (_isCompromised) {
      final isDark = AppColor.isDarkMode(context);

      return Scaffold(
        backgroundColor: AppColor.scaffoldColor(context),
        body: Stack(
          children: [
            // Background design
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2,
                    colors: [
                      AppColor.errorColor(context).withValues(alpha: 0.06),
                      AppColor.scaffoldColor(context),
                    ],
                  ),
                ),
              ),
            ),
            
            // Design visual shapes
            Positioned(
              top: -100,
              right: -100,
              child: CircleAvatar(
                radius: 150,
                backgroundColor: AppColor.errorColor(context).withValues(alpha: 0.04),
              ),
            ),

            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SingleChildScrollView(
                    child: GlassContainer(
                      padding: const EdgeInsets.all(28),
                      borderRadius: 24,
                      opacity: isDark ? 0.05 : 0.4,
                      blur: 20,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Red Warning Shield Container
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColor.errorColor(context).withValues(alpha: 0.12),
                              border: Border.all(
                                color: AppColor.errorColor(context).withValues(alpha: 0.25),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                AppImages.assetsGlobalIconWarning,
                                colorFilter: ColorFilter.mode(
                                  AppColor.errorColor(context),
                                  BlendMode.srcIn,
                                ),
                                width: 48,
                                height: 48,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const Gap(28),

                          // Title
                          Text(
                            context.apiTr(
                              ar: "تحذير أمني هام",
                              en: "Security Policy Violation",
                            ),
                            style: TextStyle(
                              color: AppColor.errorColor(context),
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              fontFamily: context.fontFamily(),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Gap(16),

                          // Description
                          Text(
                            context.apiTr(
                              ar: "تم الكشف عن كسر حماية هذا الجهاز (Root/Jailbreak). لحماية بياناتك الشخصية والدفع الحساسة، لا يُسمح بتشغيل التطبيق على أجهزة غير آمنة.",
                              en: "This device is detected as rooted or jailbroken. To protect your sensitive personal and payment data, this application is not allowed to run on compromised devices.",
                            ),
                            style: TextStyle(
                              color: AppColor.textColor(context),
                              fontSize: 14,
                              height: 1.6,
                              fontWeight: FontWeight.w500,
                              fontFamily: context.fontFamily(),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Gap(24),

                          // Informative security notice
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColor.scaffoldColor(context).withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColor.borderColor(context).withValues(alpha: 0.5),
                              ),
                            ),
                            child: Text(
                              context.apiTr(
                                ar: "إذا كنت تعتقد أن هذا الخطأ غير صحيح، يرجى استعادة نظام التشغيل الأصلي لجهازك والمحاولة مرة أخرى.",
                                en: "If you believe this is an error, please restore the original operating system of your device and try again.",
                              ),
                              style: TextStyle(
                                color: AppColor.textSecondary(context),
                                fontSize: 12,
                                height: 1.4,
                                fontWeight: FontWeight.w400,
                                fontFamily: context.fontFamily(),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return widget.child;
  }
}
