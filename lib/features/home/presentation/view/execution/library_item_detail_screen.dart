import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/services/file_viewer_utils.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/home/data/models/get_digital_library_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class LibraryItemDetailScreen extends StatelessWidget {
  final DigitalLibraryItem item;

  const LibraryItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final ext = item.fileExtension.toLowerCase();
    IconData icon;
    Color color;

    if (['pdf'].contains(ext)) {
      icon = Icons.picture_as_pdf_outlined;
      color = Colors.redAccent;
    } else if (['mp4', 'avi', 'mov'].contains(ext)) {
      icon = Icons.play_circle_outline_rounded;
      color = Colors.blueAccent;
    } else if (['doc', 'docx'].contains(ext)) {
      icon = Icons.article_rounded;
      color = Colors.indigoAccent;
    } else if (['ppt', 'pptx'].contains(ext)) {
      icon = Icons.slideshow_rounded;
      color = Colors.orangeAccent;
    } else {
      icon = Icons.insert_drive_file_rounded;
      color = Colors.teal;
    }

    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.imageFileNameStatus.isSuccess) {
          FileViewerUtils.displayFile(context, state.imageFileNameStatus.data!, item.fileName);
          context.read<HomeCubit>().resetImageFileNameStatus();
        } else if (state.imageFileNameStatus.isFailure) {
          CommonMethods.showToast(
            message: state.imageFileNameStatus.error ?? "Failed to open file",
            type: ToastType.error,
          );
          context.read<HomeCubit>().resetImageFileNameStatus();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              item.fileName,
              style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 140.w,
                    height: 140.w,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(icon, size: 60.w, color: color),
                    ),
                  ),
                ),
                Gap(30.h),
                Text(
                  item.fileName,
                  style: AppTextStyle.titleLarge(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold, fontSize: 22.sp),
                ),
                Gap(12.h),
                _buildInfoRow(
                  context,
                  Icons.person_outline_rounded,
                  'بواسطة',
                  item.teacherName.isNotEmpty ? item.teacherName : 'المدرسة',
                ),
                _buildInfoRow(
                  context,
                  Icons.extension_outlined,
                  'النوع',
                  item.fileExtension.toUpperCase(),
                ),
                Gap(20.h),
                if (item.notes.isNotEmpty) ...[
                  Text(
                    'ملاحظات:',
                    style: AppTextStyle.bodyLarge(context).copyWith(fontWeight: FontWeight.bold),
                  ),
                  Gap(8.h),
                  Text(
                    item.notes,
                    style: AppTextStyle.bodyMedium(
                      context,
                    ).copyWith(color: Colors.grey.shade600, height: 1.5),
                  ),
                ],
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 55.h,
                  child: ElevatedButton(
                    onPressed: state.imageFileNameStatus.isLoading
                        ? null
                        : () {
                            context.read<HomeCubit>().imageFileName(item.filePath);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                      elevation: 0,
                    ),
                    child: state.imageFileNameStatus.isLoading
                        ? CustomLoading(color: Colors.white, size: 20.w)
                        : Text(
                            'عرض / تحميل',
                            style: AppTextStyle.titleMedium(
                              context,
                            ).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                Gap(20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Icon(icon, size: 18.w, color: Colors.grey.shade400),
          Gap(10.w),
          Text(
            '$label: ',
            style: AppTextStyle.bodyMedium(context).copyWith(color: Colors.grey.shade500),
          ),
          Text(
            value,
            style: AppTextStyle.bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
