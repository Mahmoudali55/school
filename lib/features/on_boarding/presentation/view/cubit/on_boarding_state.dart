import 'package:equatable/equatable.dart';
import 'package:my_template/features/on_boarding/data/model/on_boarding_model.dart';


class OnBoardingState extends Equatable {
  final int currentPage;
  final List<OnBoardingPageModel> onboardingData;

  const OnBoardingState({
    this.currentPage = 0,
    this.onboardingData = const [],
  });

  OnBoardingState copyWith({int? currentPage, List<OnBoardingPageModel>? onboardingData}) {
    return OnBoardingState(
      currentPage: currentPage ?? this.currentPage,
      onboardingData: onboardingData ?? this.onboardingData,
    );
  }

  @override
  List<Object?> get props => [currentPage, onboardingData];
}
