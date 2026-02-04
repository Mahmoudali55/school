import 'package:equatable/equatable.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/class/data/model/class_absent_model.dart';
import 'package:my_template/features/class/data/model/class_models.dart';
import 'package:my_template/features/class/data/model/get_T_home_work_model.dart';
import 'package:my_template/features/class/data/model/home_work_model.dart';
import 'package:my_template/features/class/data/model/student_class_data_model.dart';
import 'package:my_template/features/class/data/model/student_courses_model.dart';
import 'package:my_template/features/home/data/models/add_class_absent_response_model.dart';
import 'package:my_template/features/home/data/models/class_hW_del_model.dart';

class ClassState extends Equatable {
  final StatusState<List<ClassModel>> classesStatus;
  final StatusState<List<HomeWorkModel>> homeWorkStatus;
  final StatusState<List<StudentCoursesModel>> studentCoursesStatus;

  final StatusState<List<THomeWorkItem>> teacherHomeWorkStatus;
  final StatusState<GetStudentClassData> studentClassesStatus;
  final StatusState<List<ClassAbsentModel>> classAbsentStatus;
  final StatusState<AddClassAbsentResponseModel> editClassAbsentStatus;
  final StatusState<ClassHWDelModel> deleteHomeworkStatus;
  final StatusState<ClassHWDelModel> deleteStudentAbsentStatus;
  const ClassState({
    this.classesStatus = const StatusState.initial(),
    this.homeWorkStatus = const StatusState.initial(),
    this.studentCoursesStatus = const StatusState.initial(),
    this.teacherHomeWorkStatus = const StatusState.initial(),
    this.studentClassesStatus = const StatusState.initial(),
    this.classAbsentStatus = const StatusState.initial(),
    this.editClassAbsentStatus = const StatusState.initial(),
    this.deleteHomeworkStatus = const StatusState.initial(),
    this.deleteStudentAbsentStatus = const StatusState.initial(),
  });

  @override
  List<Object?> get props => [
    classesStatus,
    homeWorkStatus,
    studentCoursesStatus,
    teacherHomeWorkStatus,
    studentClassesStatus,
    classAbsentStatus,
    editClassAbsentStatus,
    deleteHomeworkStatus,
    deleteStudentAbsentStatus,
  ];

  ClassState copyWith({
    StatusState<List<ClassModel>>? classesStatus,
    StatusState<List<HomeWorkModel>>? homeWorkStatus,
    StatusState<List<StudentCoursesModel>>? studentCoursesStatus,
    StatusState<List<THomeWorkItem>>? teacherHomeWorkStatus,
    StatusState<GetStudentClassData>? studentClassesStatus,
    StatusState<List<ClassAbsentModel>>? classAbsentStatus,
    StatusState<AddClassAbsentResponseModel>? editClassAbsentStatus,
    StatusState<ClassHWDelModel>? deleteHomeworkStatus,
    StatusState<ClassHWDelModel>? deleteStudentAbsentStatus,
  }) {
    return ClassState(
      classesStatus: classesStatus ?? this.classesStatus,
      homeWorkStatus: homeWorkStatus ?? this.homeWorkStatus,
      studentCoursesStatus: studentCoursesStatus ?? this.studentCoursesStatus,
      teacherHomeWorkStatus: teacherHomeWorkStatus ?? this.teacherHomeWorkStatus,
      studentClassesStatus: studentClassesStatus ?? this.studentClassesStatus,
      classAbsentStatus: classAbsentStatus ?? this.classAbsentStatus,
      editClassAbsentStatus: editClassAbsentStatus ?? this.editClassAbsentStatus,
      deleteHomeworkStatus: deleteHomeworkStatus ?? this.deleteHomeworkStatus,
      deleteStudentAbsentStatus: deleteStudentAbsentStatus ?? this.deleteStudentAbsentStatus,
    );
  }
}

class ClassInitial extends ClassState {}

class ClassLoading extends ClassState {}

class ClassLoaded extends ClassState {
  final List<ClassModel> classes;

  const ClassLoaded(this.classes);

  @override
  List<Object?> get props => [classes];
}

class ClassError extends ClassState {
  final String message;

  const ClassError(this.message);

  @override
  List<Object?> get props => [message];
}
