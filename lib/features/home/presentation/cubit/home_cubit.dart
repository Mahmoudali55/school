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
      (error) => emit(state.copyWith(parentsStudentStatus: StatusState.failure(error.errMessage))),
      (students) {
        emit(
          state.copyWith(
            parentsStudentStatus: StatusState.success(students),
            selectedStudent: students.isNotEmpty ? students[0].toMiniInfo() : null,
          ),
        );
        if (students.isNotEmpty) {
          // تحميل بيانات الطالب الأول مباشرة
          final firstStudent = students[0];
          studentAbsentCount(firstStudent.studentCode);
          studentCourseDegree(firstStudent.studentCode, 6);
        }
      },
    );
  }

  // تحديث الطالب المختار
  void changeSelectedStudent(StudentMiniInfo selectedStudent) {
    emit(state.copyWith(selectedStudent: selectedStudent));

    // جلب بيانات الطالب الجديد
    studentAbsentCount(selectedStudent.studentCode);
    studentCourseDegree(selectedStudent.studentCode, 1);

    print("Selected student updated: ${selectedStudent.studentCode}");
  }

  // جلب أيام الغياب
  Future<void> studentAbsentCount(int code) async {
    emit(state.copyWith(studentAbsentCountStatus: StatusState.loading()));

    final result = await _homeRepo.studentAbsentCount(code: code);
    result.fold(
      (error) =>
          emit(state.copyWith(studentAbsentCountStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(studentAbsentCountStatus: StatusState.success(success))),
    );
  }

  // جلب درجات الطالب
  Future<void> studentCourseDegree(int code, int? monthNo) async {
    emit(state.copyWith(studentCourseDegreeStatus: StatusState.loading()));

    final result = await _homeRepo.studentCourseDegree(code: code, monthNo: monthNo);
    result.fold(
      (error) =>
          emit(state.copyWith(studentCourseDegreeStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(studentCourseDegreeStatus: StatusState.success(success))),
    );
  }

  Future<void> studentAbsentDataDetails(int code) async {
    emit(state.copyWith(studentAbsentDataStatus: StatusState.loading()));

    final result = await _homeRepo.studentAbsentDataDetails(code: code);
    result.fold(
      (error) =>
          emit(state.copyWith(studentAbsentDataStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(studentAbsentDataStatus: StatusState.success(success))),
    );
  }

  Future<void> parentBalance(int code) async {
    emit(state.copyWith(parentBalanceStatus: StatusState.loading()));

    final result = await _homeRepo.parentBalance(code: code);
    result.fold(
      (error) => emit(state.copyWith(parentBalanceStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(parentBalanceStatus: StatusState.success(success))),
    );
  }
}
