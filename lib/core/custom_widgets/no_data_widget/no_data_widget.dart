import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../extension/context_extension.dart';
import '../../images/app_images.dart';
import '../../theme/app_theme.dart';

class NoDataWidget extends StatelessWidget {
  final Axis axis;
  final String? message;
  const NoDataWidget({
    super.key,
    this.axis = Axis.vertical,
    this.message,
  });
  @override
  Widget build(BuildContext context) {
    switch (axis) {
      case Axis.horizontal:
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            //     color: AppColor.mainAppColor(context).withOpacity(0),
            borderRadius: BorderRadius.circular(7),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                SvgPicture.asset(
                  AppImages.assetsGlobalIconEmptyFolderIcon,
                  colorFilter: ColorFilter.mode(
                    AppTheme.getByTheme(
                      context,
                      light: Colors.black,
                      dark: Colors.white,
                    ),
                    BlendMode.srcIn,
                  ),
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      message ??
                          context.apiTr(
                            ar: "لا توجد بيانات",
                            en: "There is no data",
                          ),
                      style: TextStyle(
                        color: AppTheme.getByTheme(
                          context,
                          light: Colors.black,
                          dark: Colors.white,
                        ),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      case Axis.vertical:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(
            //   color: AppColor.mainAppColor(context).withOpacity(0.2),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AppImages.assetsGlobalIconEmptyFolderIcon,
                colorFilter: ColorFilter.mode(
                  AppTheme.getByTheme(
                    context,
                    light: Colors.black,
                    dark: Colors.white,
                  ),
                  BlendMode.srcIn,
                ),
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              Text(
                message ??
                    context.apiTr(
                      ar: "لا توجد بيانات",
                      en: "There is no data",
                    ),
                style: TextStyle(
                  color: AppTheme.getByTheme(
                    context,
                    light: Colors.black,
                    dark: Colors.white,
                  ),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
    }
  }
}
