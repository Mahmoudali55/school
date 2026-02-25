import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/class/data/model/add_timetable_response_model.dart';
import 'package:my_template/features/class/data/model/level_model.dart';
import 'package:my_template/features/class/data/model/schedule_model.dart';
import 'package:my_template/features/class/data/model/section_data_model.dart';
import 'package:my_template/features/class/data/model/stage_data_model.dart';
import 'package:my_template/features/home/data/models/teacher_class_model.dart';

class ScheduleState extends Equatable {
  final StatusState<List<SectionDataModel>> sectionDataStatus;
  final StatusState<List<StageDataModel>> stageDataStatus;
  final StatusState<List<LevelModel>> levelDataStatus;
  final StatusState<List<TeacherClassModels>> classDataStatus;
  final StatusState<List<ScheduleModel>> generateScheduleStatus;
  final StatusState<List<ScheduleModel>> getScheduleStatus;
  final StatusState<List<ScheduleModel>> getScheduleApiStatus;
  final StatusState<AddTimetableResponseModel> saveScheduleStatus;

  final SectionDataModel? selectedSection;
  final StageDataModel? selectedStage;
  final LevelModel? selectedLevel;
  final TeacherClassModels? selectedClass;

  final List<ScheduleModel> generatedSchedules;

  final TimeOfDay startTime;
  final int periodsCount;
  final int periodDuration;
  final int breakDuration;
  final int thursdayPeriodsCount;
  final int breakAfterPeriod;

  const ScheduleState({
    this.sectionDataStatus = const StatusState.initial(),
    this.stageDataStatus = const StatusState.initial(),
    this.levelDataStatus = const StatusState.initial(),
    this.classDataStatus = const StatusState.initial(),
    this.generateScheduleStatus = const StatusState.initial(),
    this.getScheduleStatus = const StatusState.initial(),
    this.getScheduleApiStatus = const StatusState.initial(),
    this.saveScheduleStatus = const StatusState.initial(),
    this.selectedSection,
    this.selectedStage,
    this.selectedLevel,
    this.selectedClass,
    this.generatedSchedules = const [],
    this.startTime = const TimeOfDay(hour: 7, minute: 0),
    this.periodsCount = 7,
    this.periodDuration = 45,
    this.breakDuration = 15,
    this.thursdayPeriodsCount = 5,
    this.breakAfterPeriod = 3,
  });

  ScheduleState copyWith({
    StatusState<List<SectionDataModel>>? sectionDataStatus,
    StatusState<List<StageDataModel>>? stageDataStatus,
    StatusState<List<LevelModel>>? levelDataStatus,
    StatusState<List<TeacherClassModels>>? classDataStatus,
    StatusState<List<ScheduleModel>>? generateScheduleStatus,
    StatusState<List<ScheduleModel>>? getScheduleStatus,
    StatusState<List<ScheduleModel>>? getScheduleApiStatus,
    StatusState<AddTimetableResponseModel>? saveScheduleStatus,
    SectionDataModel? selectedSection,
    StageDataModel? selectedStage,
    LevelModel? selectedLevel,
    TeacherClassModels? selectedClass,
    List<ScheduleModel>? generatedSchedules,
    TimeOfDay? startTime,
    int? periodsCount,
    int? periodDuration,
    int? breakDuration,
    int? thursdayPeriodsCount,
    int? breakAfterPeriod,
  }) {
    return ScheduleState(
      sectionDataStatus: sectionDataStatus ?? this.sectionDataStatus,
      stageDataStatus: stageDataStatus ?? this.stageDataStatus,
      levelDataStatus: levelDataStatus ?? this.levelDataStatus,
      classDataStatus: classDataStatus ?? this.classDataStatus,
      generateScheduleStatus: generateScheduleStatus ?? this.generateScheduleStatus,
      getScheduleStatus: getScheduleStatus ?? this.getScheduleStatus,
      getScheduleApiStatus: getScheduleApiStatus ?? this.getScheduleApiStatus,
      saveScheduleStatus: saveScheduleStatus ?? this.saveScheduleStatus,
      selectedSection: selectedSection ?? this.selectedSection,
      selectedStage: selectedStage ?? this.selectedStage,
      selectedLevel: selectedLevel ?? this.selectedLevel,
      selectedClass: selectedClass ?? this.selectedClass,
      generatedSchedules: generatedSchedules ?? this.generatedSchedules,
      startTime: startTime ?? this.startTime,
      periodsCount: periodsCount ?? this.periodsCount,
      periodDuration: periodDuration ?? this.periodDuration,
      breakDuration: breakDuration ?? this.breakDuration,
      thursdayPeriodsCount: thursdayPeriodsCount ?? this.thursdayPeriodsCount,
      breakAfterPeriod: breakAfterPeriod ?? this.breakAfterPeriod,
    );
  }

  @override
  List<Object?> get props => [
    sectionDataStatus,
    stageDataStatus,
    levelDataStatus,
    classDataStatus,
    generateScheduleStatus,
    getScheduleStatus,
    getScheduleApiStatus,
    saveScheduleStatus,
    selectedSection,
    selectedStage,
    selectedLevel,
    selectedClass,
    generatedSchedules,
    startTime,
    periodsCount,
    periodDuration,
    breakDuration,
    thursdayPeriodsCount,
    breakAfterPeriod,
  ];
}
