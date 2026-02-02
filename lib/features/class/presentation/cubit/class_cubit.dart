import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/class/data/repository/class_repo.dart';

import 'class_state.dart';

class ClassCubit extends Cubit<ClassState> {
  final ClassRepo _classRepo;

  ClassCubit(this._classRepo) : super(ClassInitial());

  Future<void> getClassData(String userTypeId) async {
    if (state.classesStatus.isSuccess) return;
    emit(state.copyWith(classesStatus: const StatusState.loading()));

    // Map numeric types to named types with robust normalization
    final cleanType = userTypeId.trim();
    String normalizedType;
    if (cleanType == '1' || cleanType == 'student') {
      normalizedType = 'student';
    } else if (cleanType == '2' || cleanType == 'parent') {
      normalizedType = 'parent';
    } else if (cleanType == '3' || cleanType == 'teacher') {
      normalizedType = 'teacher';
    } else {
      normalizedType = 'admin';
    }

    try {
      final List<dynamic> data;
      if (normalizedType == 'student') {
        data = await _classRepo.getStudentClasses();
      } else if (normalizedType == 'teacher') {
        data = await _classRepo.getTeacherClasses();
      } else if (normalizedType == 'admin') {
        data = await _classRepo.getAdminClasses();
      } else if (normalizedType == 'parent') {
        data = await _classRepo.getParentStudentClasses();
      } else {
        emit(state.copyWith(classesStatus: const StatusState.failure("Unknown user type")));
        return;
      }
      emit(state.copyWith(classesStatus: StatusState.success(data.cast())));
    } catch (e) {
      emit(state.copyWith(classesStatus: StatusState.failure(e.toString())));
    }
  }

  Future<void> getHomeWork({required int code, required String hwDate}) async {
    emit(state.copyWith(homeWorkStatus: const StatusState.loading()));

    final result = await _classRepo.getHomeWork(code: code, hwDate: hwDate);
    result.fold(
      (failure) => emit(state.copyWith(homeWorkStatus: StatusState.failure(failure.errMessage))),
      (homeWorkList) => emit(state.copyWith(homeWorkStatus: StatusState.success(homeWorkList))),
    );
  }

  Future<void> studentCoursesStatus({required int level}) async {
    emit(state.copyWith(studentCoursesStatus: const StatusState.loading()));

    final result = await _classRepo.getStudentCourses(level: level);
    result.fold(
      (failure) =>
          emit(state.copyWith(studentCoursesStatus: StatusState.failure(failure.errMessage))),
      (homeWorkList) =>
          emit(state.copyWith(studentCoursesStatus: StatusState.success(homeWorkList))),
    );
  }
Future<void> teacherHomeWork({required int code, required String hwDate}) async {
    emit(state.copyWith(teacherHomeWorkStatus: const StatusState.loading()));

    final result = await _classRepo.getTeacherHomeWork(code: code, hwDate: hwDate);
    result.fold(
      (failure) =>
          emit(state.copyWith(teacherHomeWorkStatus: StatusState.failure(failure.errMessage))),
      (homeWorkList) =>
          emit(state.copyWith(teacherHomeWorkStatus: StatusState.success(homeWorkList))),
    );
  }

}
