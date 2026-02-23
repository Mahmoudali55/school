import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/class/data/model/level_model.dart';
import 'package:my_template/features/class/data/model/section_data_model.dart';
import 'package:my_template/features/class/data/model/stage_data_model.dart';
import 'package:my_template/features/class/data/repository/class_repo.dart';
import 'package:my_template/features/class/data/repository/schedule_repo.dart';
import 'package:my_template/features/class/domain/services/ai_schedule_service.dart';
import 'package:my_template/features/class/presentation/cubit/schedule_state.dart';
import 'package:my_template/features/home/data/models/teacher_class_model.dart';
import 'package:my_template/features/home/data/repository/home_repo.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final HomeRepo _homeRepo;
  final ClassRepo _classRepo;
  final ScheduleRepo _scheduleRepo;
  final AIScheduleService _aiService;

  ScheduleCubit({
    required HomeRepo homeRepo,
    required ClassRepo classRepo,
    required ScheduleRepo scheduleRepo,
    required AIScheduleService aiService,
  }) : _homeRepo = homeRepo,
       _classRepo = classRepo,
       _scheduleRepo = scheduleRepo,
       _aiService = aiService,
       super(const ScheduleState());

  Future<void> getSections(String userId) async {
    emit(state.copyWith(sectionDataStatus: const StatusState.loading()));
    final result = await _classRepo.sectionData(userId: userId);
    result.fold(
      (failure) => emit(state.copyWith(sectionDataStatus: StatusState.failure(failure.errMessage))),
      (sections) => emit(state.copyWith(sectionDataStatus: StatusState.success(sections))),
    );
  }

  Future<void> getStages(int sectionCode) async {
    emit(state.copyWith(stageDataStatus: const StatusState.loading()));
    final result = await _classRepo.stageData(sectionCode: sectionCode);
    result.fold(
      (failure) => emit(state.copyWith(stageDataStatus: StatusState.failure(failure.errMessage))),
      (stages) => emit(state.copyWith(stageDataStatus: StatusState.success(stages))),
    );
  }

  Future<void> getLevels(int stageCode) async {
    emit(state.copyWith(levelDataStatus: const StatusState.loading()));
    final result = await _classRepo.levelData(stage: stageCode);
    result.fold(
      (failure) => emit(state.copyWith(levelDataStatus: StatusState.failure(failure.errMessage))),
      (levels) {
        // Map common LevelModel to local LevelModel if needed, but they seem compatible
        emit(state.copyWith(levelDataStatus: StatusState.success(levels)));
      },
    );
  }

  Future<void> getClasses(int sectionCode, int stageCode, int levelCode) async {
    emit(state.copyWith(classDataStatus: const StatusState.loading()));
    // We use HomeRepo's teacherClasses as it returns TeacherClassModels which has teacher info
    final result = await _homeRepo.teacherClasses(
      sectionCode: sectionCode,
      stageCode: stageCode,
      levelCode: levelCode,
    );
    result.fold(
      (failure) => emit(state.copyWith(classDataStatus: StatusState.failure(failure.errMessage))),
      (classes) => emit(state.copyWith(classDataStatus: StatusState.success(classes))),
    );
  }

  void onSectionChanged(SectionDataModel? section) {
    emit(
      state.copyWith(
        selectedSection: section,
        selectedStage: null,
        selectedLevel: null,
        selectedClass: null,
      ),
    );
    if (section != null) getStages(section.sectionCode);
  }

  void onStageChanged(StageDataModel? stage) {
    emit(state.copyWith(selectedStage: stage, selectedLevel: null, selectedClass: null));
    if (stage != null) getLevels(stage.stageCode);
  }

  void onLevelChanged(LevelModel? level) {
    emit(state.copyWith(selectedLevel: level, selectedClass: null));
    if (level != null && state.selectedSection != null && state.selectedStage != null) {
      getClasses(
        state.selectedSection!.sectionCode,
        state.selectedStage!.stageCode,
        level.levelCode,
      );
    }
  }

  void onClassChanged(TeacherClassModels? schoolClass) {
    emit(state.copyWith(selectedClass: schoolClass));
  }

  Future<void> generateAICalendar() async {
    if (state.selectedClass == null || state.selectedLevel == null) {
      emit(
        state.copyWith(
          generateScheduleStatus: const StatusState.failure(
            'Please select a class and level first',
          ),
        ),
      );
      return;
    }

    emit(state.copyWith(generateScheduleStatus: const StatusState.loading()));

    try {
      final selectedClass = state.selectedClass!;
      final levelCode = state.selectedLevel!.levelCode;

      // 1. Fetch Subjects (Materials) for this level
      final coursesResult = await _classRepo.getStudentCourses(level: levelCode);

      // 2. Fetch Teachers pool
      final teachersResult = await _homeRepo.teacherData(searchVal: "");

      coursesResult.fold(
        (failure) => emit(
          state.copyWith(
            generateScheduleStatus: StatusState.failure(
              "Failed to fetch subjects: ${failure.errMessage}",
            ),
          ),
        ),
        (subjects) async {
          if (subjects.isEmpty) {
            emit(
              state.copyWith(
                generateScheduleStatus: const StatusState.failure(
                  "No subjects found for this level",
                ),
              ),
            );
            return;
          }

          teachersResult.fold(
            (failure) => emit(
              state.copyWith(
                generateScheduleStatus: StatusState.failure(
                  "Failed to fetch teachers: ${failure.errMessage}",
                ),
              ),
            ),
            (teachers) {
              if (teachers.isEmpty) {
                emit(
                  state.copyWith(
                    generateScheduleStatus: const StatusState.failure("No teachers found"),
                  ),
                );
                return;
              }

              // Generate schedule using the fetched subjects and teachers
              final generated = _aiService.generateSchedules(
                allTeacherClasses: [selectedClass],
                subjects: subjects,
                teachers: teachers,
              );

              if (generated.isEmpty) {
                emit(
                  state.copyWith(
                    generateScheduleStatus: const StatusState.failure(
                      "Failed to generate any schedule slots",
                    ),
                  ),
                );
                return;
              }

              emit(
                state.copyWith(
                  generateScheduleStatus: StatusState.success(generated),
                  generatedSchedules: generated,
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(generateScheduleStatus: StatusState.failure(e.toString())));
    }
  }

  Future<void> saveSchedule(int classCode) async {
    final scheduleToSave = state.generatedSchedules.where((e) => e.classCode == classCode).toList();
    if (scheduleToSave.isEmpty) return;

    emit(state.copyWith(saveScheduleStatus: const StatusState.loading()));
    final result = await _scheduleRepo.saveSchedule(classCode: classCode, schedule: scheduleToSave);
    result.fold(
      (failure) =>
          emit(state.copyWith(saveScheduleStatus: StatusState.failure(failure.errMessage))),
      (success) => emit(state.copyWith(saveScheduleStatus: StatusState.success(success))),
    );
  }

  Future<void> getSchedule(int classCode) async {
    emit(state.copyWith(getScheduleStatus: const StatusState.loading()));
    final result = await _scheduleRepo.getSchedule(classCode: classCode);
    result.fold(
      (failure) => emit(state.copyWith(getScheduleStatus: StatusState.failure(failure.errMessage))),
      (schedule) => emit(state.copyWith(getScheduleStatus: StatusState.success(schedule))),
    );
  }
}
