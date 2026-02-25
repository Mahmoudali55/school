import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/class/data/model/level_model.dart';
import 'package:my_template/features/class/data/model/schedule_model.dart';
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
                startTime: state.startTime,
                periodsCount: state.periodsCount,
                periodDuration: state.periodDuration,
                breakDuration: state.breakDuration,
                thursdayPeriodsCount: state.thursdayPeriodsCount,
                breakAfterPeriod: state.breakAfterPeriod,
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
                  hasChanges: true, // Mark changes on AI generation
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

  void updateBreakAfterPeriod(int period) => emit(state.copyWith(breakAfterPeriod: period));
  void updateStartTime(TimeOfDay time) {
    emit(state.copyWith(startTime: time));
  }

  // تحديث عدد الحصص اليومية
  void updatePeriodsCount(int count) {
    emit(state.copyWith(periodsCount: count));
  }

  // تحديث عدد حصص الخميس
  void updateThursdayPeriodsCount(int count) {
    emit(state.copyWith(thursdayPeriodsCount: count));
  }

  // تحديث مدة الحصة
  void updatePeriodDuration(int duration) {
    emit(state.copyWith(periodDuration: duration));
  }

  // تحديث مدة الفسحة
  void updateBreakDuration(int duration) {
    emit(state.copyWith(breakDuration: duration));
  }

  Future<void> saveSchedule(int classCode) async {
    final scheduleToSave = state.generatedSchedules.where((e) => e.classCode == classCode).toList();
    if (scheduleToSave.isEmpty) {
      emit(state.copyWith(saveScheduleStatus: const StatusState.failure('لا يوجد جدول لحفظه')));
      return;
    }

    emit(state.copyWith(saveScheduleStatus: const StatusState.loading()));
    final result = await _scheduleRepo.saveSchedule(classCode: classCode, schedule: scheduleToSave);
    result.fold(
      (failure) =>
          emit(state.copyWith(saveScheduleStatus: StatusState.failure(failure.errMessage))),
      (response) => emit(
        state.copyWith(saveScheduleStatus: StatusState.success(response), hasChanges: false),
      ),
    );
  }

  Future<void> editSchedule(int classCode) async {
    final scheduleToSave = state.generatedSchedules.where((e) => e.classCode == classCode).toList();
    if (scheduleToSave.isEmpty) {
      emit(state.copyWith(editScheduleStatus: const StatusState.failure('لا يوجد جدول لتعديله')));
      return;
    }

    emit(state.copyWith(editScheduleStatus: const StatusState.loading()));
    final result = await _scheduleRepo.editSchedule(classCode: classCode, schedule: scheduleToSave);
    result.fold(
      (failure) =>
          emit(state.copyWith(editScheduleStatus: StatusState.failure(failure.errMessage))),
      (response) => emit(
        state.copyWith(editScheduleStatus: StatusState.success(response), hasChanges: false),
      ),
    );
  }

  void swapPeriods(ScheduleModel item1, ScheduleModel item2) {
    if (item1.classCode == 0 || item2.classCode == 0) return;

    // 1. Basic Break Protection
    bool isBreak(ScheduleModel m) =>
        m.subjectName.contains('فسحة') || m.subjectName.toLowerCase().contains('break');
    if (isBreak(item1) || isBreak(item2)) {
      emit(state.copyWith(validationStatus: const StatusState.failure('لا يمكن تعديل حصة الفسحة')));
      return;
    }

    // 2. School Standard Validation
    final validationError = _validateSwap(item1, item2);
    if (validationError != null) {
      emit(state.copyWith(validationStatus: StatusState.failure(validationError)));
      return;
    }

    final List<ScheduleModel> newList = List.from(state.generatedSchedules);

    final idx1 = newList.indexWhere(
      (e) => e.day == item1.day && e.period == item1.period && e.classCode == item1.classCode,
    );
    final idx2 = newList.indexWhere(
      (e) => e.day == item2.day && e.period == item2.period && e.classCode == item2.classCode,
    );

    // ... rest of swap logic ...
    final m1 = idx1 != -1 ? newList[idx1] : item1;
    final m2 = idx2 != -1 ? newList[idx2] : item2;

    final newM1 = m1.copyWith(
      subjectName: m2.subjectName,
      subjectCode: m2.subjectCode,
      teacherName: m2.teacherName,
      teacherCode: m2.teacherCode,
      room: m2.room,
      id: m1.id,
    );
    final newM2 = m2.copyWith(
      subjectName: m1.subjectName,
      subjectCode: m1.subjectCode,
      teacherName: m1.teacherName,
      teacherCode: m1.teacherCode,
      room: m1.room,
      id: m2.id,
    );

    void updateInList(int originalIdx, ScheduleModel newItem) {
      if (originalIdx != -1) {
        if (newItem.subjectName.isEmpty && newItem.id.isEmpty) {
          newList.removeAt(originalIdx);
        } else {
          newList[originalIdx] = newItem;
        }
      } else {
        if (newItem.subjectName.isNotEmpty) {
          newList.add(newItem);
        }
      }
    }

    updateInList(idx1, newM1);
    final freshIdx2 = newList.indexWhere(
      (e) => e.day == item2.day && e.period == item2.period && e.classCode == item2.classCode,
    );
    updateInList(freshIdx2, newM2);

    emit(
      state.copyWith(
        generatedSchedules: newList,
        hasChanges: true,
        validationStatus: const StatusState.success(null),
      ),
    );
  }

  String? _validateSwap(ScheduleModel item1, ScheduleModel item2) {
    // Note: We are swapping CONTENT (subject/teacher) between two slots.
    // So item1's content will move to item2's location, and vice versa.

    final schedules = state.generatedSchedules;

    // Rule 2: Teacher Overload (Consecutive Periods)
    // We check if placing item1.teacher at item2's day/period causes 4 consecutive
    if (item1.teacherCode != 0) {
      if (_hasTooManyConsecutive(item1.teacherCode, item2.day, item2.period, schedules, [
        item1,
        item2,
      ])) {
        return 'المعلم "${item1.teacherName}" لديه حصص كثيرة متتالية يوم ${_dayAr(item2.day)}';
      }
    }
    if (item2.teacherCode != 0) {
      if (_hasTooManyConsecutive(item2.teacherCode, item1.day, item1.period, schedules, [
        item1,
        item2,
      ])) {
        return 'المعلم "${item2.teacherName}" لديه حصص كثيرة متتالية يوم ${_dayAr(item1.day)}';
      }
    }

    return null;
  }

  bool _hasTooManyConsecutive(
    int tCode,
    String day,
    int slot,
    List<ScheduleModel> schedules,
    List<ScheduleModel> slotsToIgnore,
  ) {
    // We build a map of busy periods for this teacher on this day
    // We ignore both slots involved in the swap because:
    // 1. One is the slot the teacher is LEAVING.
    // 2. One is the slot the teacher is ENTERING (and we add it manually below).
    final busyPeriods = schedules
        .where((s) => s.day == day && s.teacherCode == tCode && !slotsToIgnore.contains(s))
        .map((s) => s.period)
        .toSet();

    busyPeriods.add(slot);

    final sorted = busyPeriods.toList()..sort();
    int consecutive = 1;
    int maxConsecutive = 1;

    for (int i = 0; i < sorted.length - 1; i++) {
      if (sorted[i + 1] == sorted[i] + 1) {
        consecutive++;
      } else {
        consecutive = 1;
      }
      if (consecutive > maxConsecutive) maxConsecutive = consecutive;
    }

    return maxConsecutive > 3; // Rule: max 3
  }

  String _dayAr(String day) {
    return {
          'Sunday': 'الأحد',
          'Monday': 'الاثنين',
          'Tuesday': 'الثلاثاء',
          'Wednesday': 'الأربعاء',
          'Thursday': 'الخميس',
        }[day] ??
        day;
  }

  void selectSlot(ScheduleModel item) {
    if (item.classCode == 0) return;

    // Don't select break slots
    bool isBreak(ScheduleModel m) =>
        m.subjectName.contains('فسحة') || m.subjectName.toLowerCase().contains('break');
    if (isBreak(item)) return;

    if (state.selectedSlot == null) {
      // First tap: select the slot
      emit(state.copyWith(selectedSlot: item));
    } else {
      if (state.selectedSlot == item) {
        // Tap same item: deselect
        emit(state.copyWith(clearSelectedSlot: true));
      } else {
        // Second tap: swap and clear selection
        final firstItem = state.selectedSlot!;
        swapPeriods(firstItem, item);
        emit(state.copyWith(hasChanges: true, clearSelectedSlot: true));
      }
    }
  }

  List<ScheduleModel> _deduplicateSchedule(List<ScheduleModel> schedule) {
    final Map<String, ScheduleModel> uniqueSlots = {};
    for (var item in schedule) {
      final key = "${item.day}_${item.period}_${item.classCode}";
      if (!uniqueSlots.containsKey(key)) {
        uniqueSlots[key] = item;
      }
    }
    return uniqueSlots.values.toList();
  }

  Future<void> getSchedule(int classCode) async {
    emit(state.copyWith(getScheduleStatus: const StatusState.loading()));
    final result = await _scheduleRepo.getSchedule(classCode: classCode);
    result.fold(
      (failure) => emit(state.copyWith(getScheduleStatus: StatusState.failure(failure.errMessage))),
      (schedule) => emit(
        state.copyWith(
          getScheduleStatus: StatusState.success(_deduplicateSchedule(schedule)),
          hasChanges: false,
        ),
      ),
    );
  }

  Future<void> getScheduleFromApi(int classCode) async {
    emit(state.copyWith(getScheduleApiStatus: const StatusState.loading()));
    final result = await _scheduleRepo.getScheduleFromApi(classCode: classCode);
    result.fold(
      (failure) =>
          emit(state.copyWith(getScheduleApiStatus: StatusState.failure(failure.errMessage))),
      (schedule) => emit(
        state.copyWith(
          getScheduleApiStatus: StatusState.success(_deduplicateSchedule(schedule)),
          generatedSchedules: _deduplicateSchedule(
            schedule,
          ), // 👈 Update generatedSchedules as well
          hasChanges: false,
        ),
      ),
    );
  }
}
