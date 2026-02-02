import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/home/data/models/add_home_work_request_model.dart';
import 'package:my_template/features/home/data/models/add_permissions_mobile_model.dart';
import 'package:my_template/features/home/data/models/add_uniform_request_model.dart';
import 'package:my_template/features/home/data/models/edit_permissions_mobile_request_model.dart';
import 'package:my_template/features/home/data/models/edit_uniform_request_model.dart';
import 'package:my_template/features/home/data/models/home_models.dart';

import '../../data/repository/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;

  HomeCubit(this._homeRepo) : super(HomeInitial());

  Future<void> getHomeData(String userTypeId, int code) async {
    if (state.data != null && state.errorMessage == null) return;
    emit(state.copyWith(isLoading: true, errorMessage: null));

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

    if (normalizedType == 'student') {
      final result = await _homeRepo.getStudentHomeData();
      result.fold(
        (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.errMessage)),
        (data) => emit(state.copyWith(isLoading: false, data: data, errorMessage: null)),
      );
    } else if (normalizedType == 'parent') {
      // For parents, we fetch the students and return a ParentHomeModel
      final result = await _homeRepo.getParentHomeData(code);
      result.fold(
        (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.errMessage)),
        (data) => emit(state.copyWith(isLoading: false, data: data, errorMessage: null)),
      );
    } else if (normalizedType == 'teacher') {
      final result = await _homeRepo.getTeacherHomeData();
      result.fold(
        (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.errMessage)),
        (data) => emit(state.copyWith(isLoading: false, data: data, errorMessage: null)),
      );
    } else if (normalizedType == 'admin') {
      final result = await _homeRepo.getAdminHomeData();
      result.fold(
        (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.errMessage)),
        (data) => emit(state.copyWith(isLoading: false, data: data, errorMessage: null)),
      );
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: "Invalid User Type"));
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
          studentCourseDegree(firstStudent.studentCode, null);
        }
      },
    );
  }

  // تحديث الطالب المختار
  void changeSelectedStudent(StudentMiniInfo selectedStudent) {
    emit(state.copyWith(selectedStudent: selectedStudent));

    // جلب بيانات الطالب الجديد
    studentAbsentCount(selectedStudent.studentCode);
    studentCourseDegree(selectedStudent.studentCode, null);

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

  Future<void> studentBalance(int code) async {
    emit(state.copyWith(studentBalanceStatus: StatusState.loading()));

    final result = await _homeRepo.studentBalance(code: code);
    result.fold(
      (error) => emit(state.copyWith(studentBalanceStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(studentBalanceStatus: StatusState.success(success))),
    );
  }

  Future<void> addPermissions(AddPermissionsMobile request) async {
    if (isClosed) return;
    emit(state.copyWith(addPermissionsStatus: StatusState.loading()));

    final result = await _homeRepo.addPermissions(request: request);
    if (isClosed) return;
    result.fold(
      (error) => emit(state.copyWith(addPermissionsStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(addPermissionsStatus: StatusState.success(success))),
    );
  }

  Future<void> getPermissions({required int code}) async {
    emit(state.copyWith(getPermissionsStatus: StatusState.loading()));

    final result = await _homeRepo.getPermissions(code: code);
    result.fold(
      (error) => emit(state.copyWith(getPermissionsStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(getPermissionsStatus: StatusState.success(success))),
    );
  }

  Future<void> editPermissions(EditPermissionsMobileRequest request) async {
    if (isClosed) return;
    emit(state.copyWith(editPermissionsStatus: StatusState.loading()));

    final result = await _homeRepo.editPermissions(request: request);
    if (isClosed) return;
    result.fold(
      (error) => emit(state.copyWith(editPermissionsStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(editPermissionsStatus: StatusState.success(success))),
    );
  }

  Future<void> addUniform(AddUniformRequestModel request) async {
    emit(state.copyWith(addUniformStatus: StatusState.loading()));

    final result = await _homeRepo.addUniform(request: request);
    result.fold(
      (error) => emit(state.copyWith(addUniformStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(addUniformStatus: StatusState.success(success))),
    );
  }

  Future<void> getUniform({required int code, int? id}) async {
    emit(state.copyWith(getUniformsStatus: StatusState.loading()));

    final result = await _homeRepo.getUniforms(code: code, id: id);
    result.fold(
      (error) => emit(state.copyWith(getUniformsStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(getUniformsStatus: StatusState.success(success))),
    );
  }

  Future<void> editUniform(EditUniformRequestModel request) async {
    emit(state.copyWith(editUniformStatus: StatusState.loading()));

    final result = await _homeRepo.editUniform(request: request);
    result.fold(
      (error) => emit(state.copyWith(editUniformStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(editUniformStatus: StatusState.success(success))),
    );
  }

  Future<void> teacherLevel(int stageCode) async {
    emit(state.copyWith(teacherLevelStatus: StatusState.loading()));

    final result = await _homeRepo.teacherLevel(stageCode: stageCode);
    result.fold(
      (error) => emit(state.copyWith(teacherLevelStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(teacherLevelStatus: StatusState.success(success))),
    );
  }

  Future<void> teacherClasses(int sectionCode, int stageCode, int levelCode) async {
    emit(state.copyWith(teacherClassesStatus: StatusState.loading()));

    final result = await _homeRepo.teacherClasses(
      sectionCode: sectionCode,
      stageCode: stageCode,
      levelCode: levelCode,
    );
    result.fold(
      (error) => emit(state.copyWith(teacherClassesStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(teacherClassesStatus: StatusState.success(success))),
    );
  }

  Future<void> teacherCourses(int code) async {
    emit(state.copyWith(teacherCoursesStatus: StatusState.loading()));

    final result = await _homeRepo.teacherCourses(code: code);
    result.fold(
      (error) => emit(state.copyWith(teacherCoursesStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(teacherCoursesStatus: StatusState.success(success))),
    );
  }

  Future<void> addHomework(AddHomeworkModelRequest request) async {
    emit(state.copyWith(addHomeworkStatus: StatusState.loading()));

    final result = await _homeRepo.addHomework(request: request);
    result.fold(
      (error) => emit(state.copyWith(addHomeworkStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(addHomeworkStatus: StatusState.success(success))),
    );
  }

  Future<void> editHomework(AddHomeworkModelRequest request) async {
    emit(state.copyWith(addHomeworkStatus: StatusState.loading()));

    final result = await _homeRepo.editHomework(request: request);
    result.fold(
      (error) => emit(state.copyWith(addHomeworkStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(addHomeworkStatus: StatusState.success(success))),
    );
  }

  Future<void> deleteHomework({required int classCode}) async {
    emit(state.copyWith(deleteHomeworkStatus: StatusState.loading()));

    final result = await _homeRepo.deleteHomework(classCode: classCode);
    result.fold(
      (error) => emit(state.copyWith(deleteHomeworkStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(deleteHomeworkStatus: StatusState.success(success))),
    );
  }

  void resetAddHomeworkStatus() {
    emit(state.copyWith(addHomeworkStatus: const StatusState.initial()));
  }

  void resetDeleteHomeworkStatus() {
    emit(state.copyWith(deleteHomeworkStatus: const StatusState.initial()));
  }

  void resetAddPermissionStatus() {
    if (isClosed) return;
    emit(state.copyWith(addPermissionsStatus: const StatusState.initial()));
  }

  void resetEditPermissionStatus() {
    if (isClosed) return;
    emit(state.copyWith(editPermissionsStatus: const StatusState.initial()));
  }

  void resetAddUniformStatus() {
    if (isClosed) return;
    emit(state.copyWith(addUniformStatus: const StatusState.initial()));
  }

  void resetEditUniformStatus() {
    if (isClosed) return;
    emit(state.copyWith(editUniformStatus: const StatusState.initial()));
  }
}
