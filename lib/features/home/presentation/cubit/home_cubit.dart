import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/home/data/models/home_models.dart';

import '../../data/repository/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;

  HomeCubit(this._homeRepo) : super(HomeInitial());

  Future<void> getHomeData(String userTypeId, int code) async {
    emit(HomeLoading());

    if (userTypeId == 'student') {
      final result = await _homeRepo.getStudentHomeData();
      result.fold(
        (failure) => emit(HomeError(failure.errMessage)),
        (data) => emit(HomeLoaded(data)),
      );
    } else if (userTypeId == 'parent') {
      // For parents, we fetch the students and return a ParentHomeModel
      final result = await _homeRepo.getParentHomeData(code);
      result.fold(
        (failure) => emit(HomeError(failure.errMessage)),
        (data) => emit(HomeLoaded(data)),
      );
    } else if (userTypeId == 'teacher') {
      final result = await _homeRepo.getTeacherHomeData();
      result.fold(
        (failure) => emit(HomeError(failure.errMessage)),
        (data) => emit(HomeLoaded(data)),
      );
    } else if (userTypeId == 'admin') {
      final result = await _homeRepo.getAdminHomeData();
      result.fold(
        (failure) => emit(HomeError(failure.errMessage)),
        (data) => emit(HomeLoaded(data)),
      );
    } else {
      emit(const HomeError("Invalid User Type"));
    }
  }

  Future<void> parentData(int code) async {
    emit(state.copyWith(parentsStudentStatus: StatusState.loading()));

    final result = await _homeRepo.ParentsStudent(code: code);

    result.fold(
      (error) {
        final errorMessage = error.errMessage;
        emit(state.copyWith(parentsStudentStatus: StatusState.failure(errorMessage)));
      },
      (success) {
        emit(state.copyWith(parentsStudentStatus: StatusState.success(success)));
      },
    );
  }

  Future<void> studentAbsentCount(int code) async {
    emit(state.copyWith(studentAbsentCountStatus: StatusState.loading()));

    final result = await _homeRepo.studentAbsentCount(code: code);

    result.fold(
      (error) {
        final errorMessage = error.errMessage;
        emit(state.copyWith(studentAbsentCountStatus: StatusState.failure(errorMessage)));
      },
      (success) {
        emit(state.copyWith(studentAbsentCountStatus: StatusState.success(success)));
      },
    );
  }

  void changeSelectedStudent(StudentMiniInfo selectedStudent) {
    emit(state.copyWith(selectedStudent: selectedStudent)); // فقط تحديث الطالب
    studentAbsentCount(selectedStudent.studentCode); // تحميل أيام الغياب
  }
}
