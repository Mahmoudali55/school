import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/class/data/model/level_model.dart';
import 'package:my_template/features/class/data/model/section_data_model.dart';
import 'package:my_template/features/class/data/model/stage_data_model.dart';
import 'package:my_template/features/class/data/repository/class_repo.dart';
import 'package:my_template/features/class/data/repository/schedule_repo.dart';
import 'package:my_template/features/home/data/models/add_class_absent_request_model.dart';

import 'class_state.dart';

class ClassCubit extends Cubit<ClassState> {
  final ClassRepo _classRepo;
  final ScheduleRepo _scheduleRepo;

  ClassCubit(this._classRepo, this._scheduleRepo) : super(ClassInitial());

  Future<void> getScheduleFromApi(int classCode) async {
    emit(state.copyWith(getScheduleApiStatus: const StatusState.loading()));

    final result = await _scheduleRepo.getScheduleFromApi(classCode: classCode);
    if (isClosed) return;
    result.fold(
      (failure) =>
          emit(state.copyWith(getScheduleApiStatus: StatusState.failure(failure.errMessage))),
      (schedule) => emit(state.copyWith(getScheduleApiStatus: StatusState.success(schedule))),
    );
  }

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
        if (isClosed) return;
        emit(state.copyWith(classesStatus: const StatusState.failure("Unknown user type")));
        return;
      }
      if (isClosed) return;
      emit(state.copyWith(classesStatus: StatusState.success(data.cast())));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(classesStatus: StatusState.failure(e.toString())));
    }
  }

  Future<void> getHomeWork({required int code, required String hwDate}) async {
    emit(state.copyWith(homeWorkStatus: const StatusState.loading()));

    final result = await _classRepo.getHomeWork(code: code, hwDate: hwDate);
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(homeWorkStatus: StatusState.failure(failure.errMessage))),
      (homeWorkList) => emit(state.copyWith(homeWorkStatus: StatusState.success(homeWorkList))),
    );
  }

  Future<void> studentCoursesStatus({required int level}) async {
    emit(state.copyWith(studentCoursesStatus: const StatusState.loading()));

    final result = await _classRepo.getStudentCourses(level: level);
    if (isClosed) return;
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
    if (isClosed) return;
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
    if (isClosed) return;
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
    if (isClosed) return;
    result.fold(
      (error) => emit(state.copyWith(classAbsentStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(classAbsentStatus: StatusState.success(success))),
    );
  }

  Future<void> editClassAbsent({required AddClassAbsentRequestModel request}) async {
    emit(state.copyWith(editClassAbsentStatus: StatusState.loading()));
    final result = await _classRepo.editClassAbsent(request: request);
    if (isClosed) return;
    result.fold(
      (error) => emit(state.copyWith(editClassAbsentStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(editClassAbsentStatus: StatusState.success(success))),
    );
  }

  Future<void> deleteClassAbsent({required int classCode, required String HWDATE}) async {
    emit(state.copyWith(deleteHomeworkStatus: StatusState.loading()));
    final result = await _classRepo.deleteClassAbsent(classCode: classCode, HWDATE: HWDATE);
    if (isClosed) return;
    result.fold(
      (error) => emit(state.copyWith(deleteHomeworkStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(deleteHomeworkStatus: StatusState.success(success))),
    );
  }

  Future<void> getLessons({int? code}) async {
    emit(state.copyWith(getLessonsStatus: StatusState.loading()));
    final result = await _classRepo.getLessons(code: code);
    if (isClosed) return;
    result.fold(
      (error) => emit(state.copyWith(getLessonsStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(getLessonsStatus: StatusState.success(success))),
    );
  }

  Future<void> imageFileName(String filePaths, BuildContext context) async {
    emit(state.copyWith(imageFileNameStatus: const StatusState.loading()));
    CommonMethods.showToast(message: AppLocalKay.loading.tr(), type: ToastType.help);
    final result = await _classRepo.imageFileName(filePath: filePaths);
    if (isClosed) return;

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
    if (isClosed) return;
    result.fold(
      (error) =>
          emit(state.copyWith(deleteStudentAbsentStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(deleteStudentAbsentStatus: StatusState.success(success))),
    );
  }

  Future<void> deleteStudent({required int studentCode}) async {
    emit(state.copyWith(deleteLessonStatus: StatusState.loading()));
    final result = await _classRepo.deleteLesson(lessonCode: studentCode);
    if (isClosed) return;
    result.fold(
      (error) => emit(state.copyWith(deleteLessonStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(deleteLessonStatus: StatusState.success(success))),
    );
  }

  Future<void> sectionData({required String userId}) async {
    emit(
      state.copyWith(
        sectionDataStatus: const StatusState.loading(),
        clearSection: true,
        clearStage: true,
        clearLevel: true,
      ),
    );
    final result = await _classRepo.sectionData(userId: userId);
    if (isClosed) return;
    result.fold(
      (error) => emit(state.copyWith(sectionDataStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(sectionDataStatus: StatusState.success(success))),
    );
  }

  Future<void> stageData({required int sectionId}) async {
    emit(state.copyWith(stageDataStatus: const StatusState.loading(), clearStage: true, clearLevel: true));
    final result = await _classRepo.stageData(sectionCode: sectionId);
    if (isClosed) return;
    result.fold(
      (error) => emit(state.copyWith(stageDataStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(stageDataStatus: StatusState.success(success))),
    );
  }

  Future<void> levelData({required int stage}) async {
    emit(state.copyWith(levelDataStatus: const StatusState.loading(), clearLevel: true));
    final result = await _classRepo.levelData(stage: stage);
    if (isClosed) return;
    result.fold(
      (error) => emit(state.copyWith(levelDataStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(levelDataStatus: StatusState.success(success))),
    );
  }

  Future<void> classMonthResult({required int classCode, required int month}) async {
    emit(state.copyWith(classMonthResultStatus: const StatusState.loading()));
    final result = await _classRepo.classMonthResult(classCode: classCode, month: month);
    if (isClosed) return;
    result.fold(
      (error) =>
          emit(state.copyWith(classMonthResultStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(classMonthResultStatus: StatusState.success(success))),
    );
  }

  Future<void> studentAbsentCount({required int classCode}) async {
    emit(state.copyWith(studentAbsentCountStatus: const StatusState.loading()));
    final result = await _classRepo.studentAbsent(classCode: classCode);
    if (isClosed) return;
    result.fold(
      (error) =>
          emit(state.copyWith(studentAbsentCountStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(studentAbsentCountStatus: StatusState.success(success))),
    );
  }

  Future<void> classData({
    required int level,
    required int sectionCod,
    required int stageCode,
  }) async {
    emit(state.copyWith(classDataStatus: const StatusState.loading()));
    final result = await _classRepo.classData(
      level: level,
      sectionCod: sectionCod,
      stageCode: stageCode,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(state.copyWith(classDataStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(classDataStatus: StatusState.success(success))),
    );
  }

  void onSectionChanged(SectionDataModel? section) {
    emit(
      state.copyWith(
        selectedSection: section,
        clearStage: true,
        clearLevel: true,
        stageDataStatus: const StatusState.initial(),
      ),
    );
    if (section != null) {
      stageData(sectionId: section.sectionCode);
    }
  }

  void onStageChanged(StageDataModel? stage) {
    emit(
      state.copyWith(
        selectedStage: stage,
        clearLevel: true,
        sectionDataStatus: const StatusState.initial(),
      ),
    );
    if (stage != null) {
      levelData(stage: stage.stageCode);
    }
  }

  void onLevelChanged(LevelModel? level) {
    emit(state.copyWith(selectedLevel: level));
    if (level != null && state.selectedSection != null && state.selectedStage != null) {
      classData(
        level: level.levelCode,
        sectionCod: state.selectedSection!.sectionCode,
        stageCode: state.selectedStage!.stageCode,
      );
    }
  }

  void clearSelection() {
    emit(
      state.copyWith(
        selectedSection: null,
        selectedStage: null,
        selectedLevel: null,
        stageDataStatus: const StatusState.initial(),
        levelDataStatus: const StatusState.initial(),
        classDataStatus: const StatusState.initial(),
      ),
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
