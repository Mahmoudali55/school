import 'package:equatable/equatable.dart';
import 'package:my_template/core/network/status.state.dart';
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
  final StatusState<bool> saveScheduleStatus;

  final SectionDataModel? selectedSection;
  final StageDataModel? selectedStage;
  final LevelModel? selectedLevel;
  final TeacherClassModels? selectedClass;

  final List<ScheduleModel> generatedSchedules;

  const ScheduleState({
    this.sectionDataStatus = const StatusState.initial(),
    this.stageDataStatus = const StatusState.initial(),
    this.levelDataStatus = const StatusState.initial(),
    this.classDataStatus = const StatusState.initial(),
    this.generateScheduleStatus = const StatusState.initial(),
    this.getScheduleStatus = const StatusState.initial(),
    this.saveScheduleStatus = const StatusState.initial(),
    this.selectedSection,
    this.selectedStage,
    this.selectedLevel,
    this.selectedClass,
    this.generatedSchedules = const [],
  });

  ScheduleState copyWith({
    StatusState<List<SectionDataModel>>? sectionDataStatus,
    StatusState<List<StageDataModel>>? stageDataStatus,
    StatusState<List<LevelModel>>? levelDataStatus,
    StatusState<List<TeacherClassModels>>? classDataStatus,
    StatusState<List<ScheduleModel>>? generateScheduleStatus,
    StatusState<List<ScheduleModel>>? getScheduleStatus,
    StatusState<bool>? saveScheduleStatus,
    SectionDataModel? selectedSection,
    StageDataModel? selectedStage,
    LevelModel? selectedLevel,
    TeacherClassModels? selectedClass,
    List<ScheduleModel>? generatedSchedules,
  }) {
    return ScheduleState(
      sectionDataStatus: sectionDataStatus ?? this.sectionDataStatus,
      stageDataStatus: stageDataStatus ?? this.stageDataStatus,
      levelDataStatus: levelDataStatus ?? this.levelDataStatus,
      classDataStatus: classDataStatus ?? this.classDataStatus,
      generateScheduleStatus: generateScheduleStatus ?? this.generateScheduleStatus,
      getScheduleStatus: getScheduleStatus ?? this.getScheduleStatus,
      saveScheduleStatus: saveScheduleStatus ?? this.saveScheduleStatus,
      selectedSection: selectedSection ?? this.selectedSection,
      selectedStage: selectedStage ?? this.selectedStage,
      selectedLevel: selectedLevel ?? this.selectedLevel,
      selectedClass: selectedClass ?? this.selectedClass,
      generatedSchedules: generatedSchedules ?? this.generatedSchedules,
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
    saveScheduleStatus,
    selectedSection,
    selectedStage,
    selectedLevel,
    selectedClass,
    generatedSchedules,
  ];
}
