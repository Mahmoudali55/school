import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/class/data/repository/class_repo.dart';
import 'package:my_template/features/home/data/models/add_class_absent_request_model.dart';

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

  Future<void> studentData({required int code}) async {
    emit(state.copyWith(studentClassesStatus: const StatusState.loading()));

    final result = await _classRepo.studentClasses(ClassCode: code);
    result.fold(
      (failure) =>
          emit(state.copyWith(studentClassesStatus: StatusState.failure(failure.errMessage))),
      (homeWorkList) =>
          emit(state.copyWith(studentClassesStatus: StatusState.success(homeWorkList))),
    );
  }

  Future<void> classAbsent({required int classCode, required String HWDATE}) async {
    emit(state.copyWith(classAbsentStatus: StatusState.loading()));
    final result = await _classRepo.classAbsent(classCode: classCode, HwDate: HWDATE);
    result.fold(
      (error) => emit(state.copyWith(classAbsentStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(classAbsentStatus: StatusState.success(success))),
    );
  }

  Future<void> editClassAbsent({required AddClassAbsentRequestModel request}) async {
    emit(state.copyWith(editClassAbsentStatus: StatusState.loading()));
    final result = await _classRepo.editClassAbsent(request: request);
    result.fold(
      (error) => emit(state.copyWith(editClassAbsentStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(editClassAbsentStatus: StatusState.success(success))),
    );
  }

  Future<void> deleteClassAbsent({required int classCode, required String HWDATE}) async {
    emit(state.copyWith(deleteHomeworkStatus: StatusState.loading()));
    final result = await _classRepo.deleteClassAbsent(classCode: classCode, HWDATE: HWDATE);
    result.fold(
      (error) => emit(state.copyWith(deleteHomeworkStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(deleteHomeworkStatus: StatusState.success(success))),
    );
  }

  Future<void> getLessons({required int code}) async {
    emit(state.copyWith(getLessonsStatus: StatusState.loading()));
    final result = await _classRepo.getLessons(code: code);
    result.fold(
      (error) => emit(state.copyWith(getLessonsStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(getLessonsStatus: StatusState.success(success))),
    );
  }

  Future<void> imageFileName(String filePaths, BuildContext context) async {
    emit(state.copyWith(imageFileNameStatus: const StatusState.loading()));
    CommonMethods.showToast(message: AppLocalKay.loading.tr(), type: ToastType.help);
    final result = await _classRepo.imageFileName(filePath: filePaths);

    result.fold(
      (error) {
        emit(state.copyWith(imageFileNameStatus: StatusState.failure(error.errMessage)));
      },
      (files) {
        emit(state.copyWith(imageFileNameStatus: StatusState.success(files)));
        // emit(state.copyWith(imageFileNameStatus: const StatusState.initial()));
      },
    );
  }

  Future<void> deleteStudentAbsent({
    required int studentCode,
    required String HWDATE,
    required int classCode,
  }) async {
    emit(state.copyWith(deleteStudentAbsentStatus: StatusState.loading()));
    final result = await _classRepo.deleteStudentAbsent(
      studentCode: studentCode,
      HWDATE: HWDATE,
      classCode: classCode,
    );
    result.fold(
      (error) =>
          emit(state.copyWith(deleteStudentAbsentStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(deleteStudentAbsentStatus: StatusState.success(success))),
    );
  }

  Future<void> updateClassAbsent({
    required int studentCode,
    required int absentType,
    required String notes,
  }) async {
    final result = await _classRepo.updateClassAbsent(
      studentCode: studentCode,
      absentType: absentType,
      notes: notes,
    );
    result.fold((error) => null, (success) => null);
  }
}
