import 'package:equatable/equatable.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/class/data/model/student_class_data_model.dart';
import 'package:my_template/features/home/data/models/add_class_absent_response_model.dart';
import 'package:my_template/features/home/data/models/add_homework_response_model.dart';
import 'package:my_template/features/home/data/models/add_lessons_response_model.dart';
import 'package:my_template/features/home/data/models/add_permissions_response_model.dart';
import 'package:my_template/features/home/data/models/add_uniform_response_model.dart';
import 'package:my_template/features/home/data/models/class_hW_del_model.dart';
import 'package:my_template/features/home/data/models/edit_permissions_mobile_response_model.dart';
import 'package:my_template/features/home/data/models/edit_uniform_response_model.dart';
import 'package:my_template/features/home/data/models/get_permissions_mobile_model.dart';
import 'package:my_template/features/home/data/models/get_uniform_data_model.dart';
import 'package:my_template/features/home/data/models/parent_balance_model.dart';
import 'package:my_template/features/home/data/models/parents_student_data_model.dart';
import 'package:my_template/features/home/data/models/student_absent_count_model.dart';
import 'package:my_template/features/home/data/models/student_absent_data_model.dart';
import 'package:my_template/features/home/data/models/student_balance_model.dart';
import 'package:my_template/features/home/data/models/student_course_degree_model.dart';
import 'package:my_template/features/home/data/models/teacher_class_model.dart';
import 'package:my_template/features/home/data/models/teacher_courses_model.dart';
import 'package:my_template/features/home/data/models/teacher_level_model.dart';

import '../../data/models/home_models.dart';

class HomeState extends Equatable {
  const HomeState({
    this.parentsStudentStatus = const StatusState.initial(),
    this.studentAbsentCountStatus = const StatusState.initial(),
    this.studentCourseDegreeStatus = const StatusState.initial(),
    this.studentAbsentDataStatus = const StatusState.initial(),
    this.parentBalanceStatus = const StatusState.initial(),
    this.studentBalanceStatus = const StatusState.initial(),
    this.addPermissionsStatus = const StatusState.initial(),
    this.getPermissionsStatus = const StatusState.initial(),
    this.editPermissionsStatus = const StatusState.initial(),
    this.getUniformsStatus = const StatusState.initial(),
    this.addUniformStatus = const StatusState.initial(),
    this.editUniformStatus = const StatusState.initial(),
    this.teacherLevelStatus = const StatusState.initial(),
    this.teacherClassesStatus = const StatusState.initial(),
    this.teacherCoursesStatus = const StatusState.initial(),
    this.addHomeworkStatus = const StatusState.initial(),
    this.deleteHomeworkStatus = const StatusState.initial(),
    this.studentDataStatus = const StatusState.initial(),
    this.addClassAbsentStatus = const StatusState.initial(),
    this.getClassAbsentStatus = const StatusState.initial(),
    this.addLessonsStatus = const StatusState.initial(),
    this.uploadedFilesStatus = const StatusState.initial(),
    this.selectedStudent,
    this.data,
    this.isLoading = false,
    this.errorMessage,
  });

  final StatusState<List<ParentsStudentData>> parentsStudentStatus;
  final StatusState<List<StudentAbsentCount>> studentAbsentCountStatus;
  final StatusState<List<StudentCourseDegree>> studentCourseDegreeStatus;
  final StatusState<List<StudentAbsentData>> studentAbsentDataStatus;
  final StatusState<List<ParentBalanceModel>> parentBalanceStatus;
  final StatusState<List<StudentBalanceModel>> studentBalanceStatus;
  final StatusState<AddPermissionsResponse> addPermissionsStatus;
  final StatusState<GetPermissionsMobile> getPermissionsStatus;
  final StatusState<EditPermissionsMobileResponse> editPermissionsStatus;
  final StatusState<AddUniformResponseModel> addUniformStatus;
  final StatusState<GetUniformDataResponse> getUniformsStatus;
  final StatusState<EditUniformResponse> editUniformStatus;
  final StatusState<List<TeacherLevelModel>> teacherLevelStatus;
  final StatusState<List<TeacherClassModels>> teacherClassesStatus;
  final StatusState<List<TeacherCoursesModel>> teacherCoursesStatus;
  final StatusState<AddHomeworkResponseModel> addHomeworkStatus;
  final StatusState<ClassHWDelModel> deleteHomeworkStatus;
  final StatusState<GetStudentClassData> studentDataStatus;
  final StatusState<AddClassAbsentResponseModel> addClassAbsentStatus;
  final StatusState<String> getClassAbsentStatus;
  final StatusState<AddLessonsResponse> addLessonsStatus;
  final StatusState<List<String>>? uploadedFilesStatus;
  final StudentMiniInfo? selectedStudent;

  /// Main home data (TeacherHomeModel, StudentHomeModel, etc.)
  final HomeModel? data;
  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [
    parentsStudentStatus,
    studentAbsentCountStatus,
    selectedStudent,
    studentCourseDegreeStatus,
    studentAbsentDataStatus,
    parentBalanceStatus,
    studentBalanceStatus,
    addPermissionsStatus,
    getPermissionsStatus,
    editPermissionsStatus,
    addUniformStatus,
    getUniformsStatus,
    editUniformStatus,
    teacherLevelStatus,
    teacherClassesStatus,
    teacherCoursesStatus,
    data,
    isLoading,
    errorMessage,
    addHomeworkStatus,
    deleteHomeworkStatus,
    studentDataStatus,
    addClassAbsentStatus,
    getClassAbsentStatus,
    addLessonsStatus,
    uploadedFilesStatus,
  ];

  HomeState copyWith({
    StatusState<List<ParentsStudentData>>? parentsStudentStatus,
    StatusState<List<StudentAbsentCount>>? studentAbsentCountStatus,
    StatusState<List<StudentCourseDegree>>? studentCourseDegreeStatus,
    StatusState<List<StudentAbsentData>>? studentAbsentDataStatus,
    StatusState<List<ParentBalanceModel>>? parentBalanceStatus,
    StatusState<List<StudentBalanceModel>>? studentBalanceStatus,
    StatusState<AddPermissionsResponse>? addPermissionsStatus,
    StatusState<GetPermissionsMobile>? getPermissionsStatus,
    StatusState<EditPermissionsMobileResponse>? editPermissionsStatus,
    StatusState<AddUniformResponseModel>? addUniformStatus,
    StatusState<GetUniformDataResponse>? getUniformsStatus,
    StatusState<EditUniformResponse>? editUniformStatus,
    StatusState<List<TeacherLevelModel>>? teacherLevelStatus,
    StatusState<List<TeacherClassModels>>? teacherClassesStatus,
    StatusState<List<TeacherCoursesModel>>? teacherCoursesStatus,
    StatusState<AddHomeworkResponseModel>? addHomeworkStatus,
    StatusState<ClassHWDelModel>? deleteHomeworkStatus,
    StatusState<GetStudentClassData>? studentDataStatus,
    StatusState<AddClassAbsentResponseModel>? addClassAbsentStatus,
    StatusState<AddLessonsResponse>? addLessonsStatus,
    StatusState<String>? getClassAbsentStatus,
    StatusState<List<String>>? uploadedFilesStatus,
    StudentMiniInfo? selectedStudent,
    HomeModel? data,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeState(
      parentsStudentStatus: parentsStudentStatus ?? this.parentsStudentStatus,
      studentAbsentCountStatus: studentAbsentCountStatus ?? this.studentAbsentCountStatus,
      selectedStudent: selectedStudent ?? this.selectedStudent,
      studentCourseDegreeStatus: studentCourseDegreeStatus ?? this.studentCourseDegreeStatus,
      studentAbsentDataStatus: studentAbsentDataStatus ?? this.studentAbsentDataStatus,
      parentBalanceStatus: parentBalanceStatus ?? this.parentBalanceStatus,
      studentBalanceStatus: studentBalanceStatus ?? this.studentBalanceStatus,
      addPermissionsStatus: addPermissionsStatus ?? this.addPermissionsStatus,
      getPermissionsStatus: getPermissionsStatus ?? this.getPermissionsStatus,
      editPermissionsStatus: editPermissionsStatus ?? this.editPermissionsStatus,
      addUniformStatus: addUniformStatus ?? this.addUniformStatus,
      getUniformsStatus: getUniformsStatus ?? this.getUniformsStatus,
      editUniformStatus: editUniformStatus ?? this.editUniformStatus,
      teacherLevelStatus: teacherLevelStatus ?? this.teacherLevelStatus,
      teacherClassesStatus: teacherClassesStatus ?? this.teacherClassesStatus,
      teacherCoursesStatus: teacherCoursesStatus ?? this.teacherCoursesStatus,
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      addHomeworkStatus: addHomeworkStatus ?? this.addHomeworkStatus,
      deleteHomeworkStatus: deleteHomeworkStatus ?? this.deleteHomeworkStatus,
      studentDataStatus: studentDataStatus ?? this.studentDataStatus,
      addClassAbsentStatus: addClassAbsentStatus ?? this.addClassAbsentStatus,
      getClassAbsentStatus: getClassAbsentStatus ?? this.getClassAbsentStatus,
      addLessonsStatus: addLessonsStatus ?? this.addLessonsStatus,
      uploadedFilesStatus: uploadedFilesStatus ?? this.uploadedFilesStatus,
    );
  }
}

class HomeInitial extends HomeState {
  const HomeInitial() : super();
}

class HomeLoading extends HomeState {
  const HomeLoading() : super(isLoading: true);
}

class HomeLoaded extends HomeState {
  const HomeLoaded(HomeModel data) : super(data: data);
}

class HomeError extends HomeState {
  const HomeError(String message) : super(errorMessage: message);

  String get message => errorMessage ?? "";
}
