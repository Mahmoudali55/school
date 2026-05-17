import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';

import '../../extension/context_extension.dart';
import '../../images/app_images.dart';
import '../../theme/app_colors.dart';
import '../../services/services_locator.dart';
import '../buttons/custom_button.dart';
import '../glass_container.dart';

class OfflineGate extends StatefulWidget {
  final Widget child;
  const OfflineGate({super.key, required this.child});

  @override
  State<OfflineGate> createState() => _OfflineGateState();
}

class _OfflineGateState extends State<OfflineGate> {
  bool _isConnected = true;
  bool _isChecking = false;
  StreamSubscription<InternetStatus>? _subscription;

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
    _subscribeToConnectionChanges();
  }

  Future<void> _checkInitialConnection() async {
    try {
      final isConnected = await sl<InternetConnection>().hasInternetAccess;
      if (mounted) {
        setState(() {
          _isConnected = isConnected;
        });
      }
    } catch (e) {
      debugPrint("OfflineGate: Error checking initial connection: $e");
    }
  }

  void _subscribeToConnectionChanges() {
    try {
      _subscription = sl<InternetConnection>().onStatusChange.listen((status) {
        if (mounted) {
          setState(() {
            _isConnected = status == InternetStatus.connected;
          });
        }
      });
    } catch (e) {
      debugPrint("OfflineGate: Error subscribing to connection: $e");
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _retryConnection() async {
    if (_isChecking) return;
    setState(() {
      _isChecking = true;
    });

    // Elegant artificial delay for smooth transition
    await Future.delayed(const Duration(milliseconds: 1000));

    try {
      final isConnected = await sl<InternetConnection>().hasInternetAccess;
      if (mounted) {
        setState(() {
          _isConnected = isConnected;
          _isChecking = false;
        });
        
        if (isConnected) {
          CommonMethods.showToast(
            message: context.apiTr(
              ar: "تم استعادة الاتصال بالإنترنت بنجاح!",
              en: "Internet connection restored successfully!",
            ),
            type: ToastType.success,
          );
        } else {
          CommonMethods.showToast(
            message: context.apiTr(
              ar: "تأكد من الاتصال بالإنترنت ثم حاول مجدداً",
              en: "Check your internet connection and try again",
            ),
            type: ToastType.error,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isConnected) {
      return widget.child;
    }

    final isDark = AppColor.isDarkMode(context);

    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      body: Stack(
        children: [
          // Background soft design
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [
                    AppColor.primaryColor(context).withValues(alpha: 0.08),
                    AppColor.scaffoldColor(context),
                  ],
                ),
              ),
            ),
          ),
          
          // Pattern dots or soft shapes
          Positioned(
            top: -100,
            right: -100,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: AppColor.primaryColor(context).withValues(alpha: 0.05),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: CircleAvatar(
              radius: 120,
              backgroundColor: AppColor.secondAppColor(context).withValues(alpha: 0.05),
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
                        // Elegant offline icon container
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.errorColor(context).withValues(alpha: 0.1),
                            border: Border.all(
                              color: AppColor.errorColor(context).withValues(alpha: 0.2),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              AppImages.assetsGlobalIconOfflineIcon,
                              colorFilter: ColorFilter.mode(
                                AppColor.errorColor(context),
                                BlendMode.srcIn,
                              ),
                              width: 50,
                              height: 50,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const Gap(24),

                        // Title
                        Text(
                          context.apiTr(
                            ar: "لا يوجد اتصال بالإنترنت",
                            en: "No Internet Connection",
                          ),
                          style: TextStyle(
                            color: AppColor.textColor(context),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: context.fontFamily(),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Gap(12),

                        // Subtitle
                        Text(
                          context.apiTr(
                            ar: "يرجى التحقق من اتصالك بالشبكة للمتابعة ودخول التطبيق.",
                            en: "Please check your network connection to continue and access the app.",
                          ),
                          style: TextStyle(
                            color: AppColor.textSecondary(context),
                            fontSize: 14,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                            fontFamily: context.fontFamily(),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Gap(32),

                        // Elegant Retry Button
                        CustomButton(
                          width: double.infinity,
                          height: 50,
                          radius: 12,
                          text: _isChecking
                              ? ""
                              : context.apiTr(ar: "إعادة المحاولة", en: "Try Again"),
                          child: _isChecking
                              ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CupertinoActivityIndicator(
                                    color: AppColor.whiteColor(context),
                                  ),
                                )
                              : null,
                          prefixIcon: _isChecking
                              ? null
                              : SvgPicture.asset(
                                  AppImages.assetsGlobalIconRefreshIcon,
                                  colorFilter: ColorFilter.mode(
                                    AppColor.whiteColor(context),
                                    BlendMode.srcIn,
                                  ),
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.contain,
                                ),
                          onPressed: _isChecking ? null : _retryConnection,
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
}
