import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/profile/data/repo/profile_repo.dart';
import 'package:my_template/features/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _profileRepo;

  ProfileCubit(this._profileRepo) : super(const ProfileState());

  Future<void> loadStudentProfile() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final profile = await _profileRepo.getStudentProfile();
      final activities = await _profileRepo.getStudentActivities();
      final achievements = await _profileRepo.getStudentAchievements();
      emit(
        state.copyWith(
          isLoading: false,
          profile: profile,
          activities: activities,
          achievements: achievements,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> loadParentProfile() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final profile = await _profileRepo.getParentProfile();
      emit(state.copyWith(isLoading: false, profile: profile));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
