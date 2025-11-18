import 'package:easy_localization/easy_localization.dart';
import 'package:my_template/core/images/app_images.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/on_boarding/data/model/on_boarding_model.dart';

class OnBoardingRepository {
  List<OnBoardingPageModel> getOnBoardingPages() {
    return [
      OnBoardingPageModel(
        title: AppLocalKay.onboardingtitleone.tr(),
        description: AppLocalKay.onboardingDescriptionone.tr(),
        image: AppImages.school,
      ),
      OnBoardingPageModel(
        title: AppLocalKay.onboardingtitletwo.tr(),
        description: AppLocalKay.onboardingDescriptiontwo.tr(),
        image: AppImages.education,
      ),
      OnBoardingPageModel(
        title: AppLocalKay.onboardingtitlethree.tr(),
        description: AppLocalKay.onboardingDescriptionthree.tr(),
        image: AppImages.homework,
      ),
    ];
  }
}
