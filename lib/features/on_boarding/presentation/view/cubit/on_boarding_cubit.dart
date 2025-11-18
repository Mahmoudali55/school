import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/utils/navigator_methods.dart';
import 'package:my_template/features/on_boarding/data/repository/on_boarding_rep.dart';
import 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  final PageController pageController = PageController();
  final OnBoardingRepository repository;

  OnBoardingCubit({required this.repository})
    : super(OnBoardingState(onboardingData: repository.getOnBoardingPages()));

  void changePage(int index) {
    emit(state.copyWith(currentPage: index));
  }

  bool isLastPage() => state.currentPage == state.onboardingData.length - 1;

  void nextPage(BuildContext context) {
    if (isLastPage()) {
      NavigatorMethods.pushNamedAndRemoveUntil(context, RoutesName.loginScreen);
    } else {
      pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }
}
