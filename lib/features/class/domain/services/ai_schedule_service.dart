import 'package:flutter/material.dart';
import 'package:my_template/features/class/data/model/schedule_model.dart';
import 'package:my_template/features/class/data/model/student_courses_model.dart';
import 'package:my_template/features/home/data/models/teacher_class_model.dart';
import 'package:my_template/features/home/data/models/teacher_data_model.dart';

class AIScheduleService {
  final List<String> days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'];

  /// Rules-based Schedule Generation for Saudi Schools (1447H)

  List<ScheduleModel> generateSchedules({
    required List<TeacherClassModels> allTeacherClasses,
    required List<StudentCoursesModel> subjects,
    required List<TeacherDataModel> teachers,
    TimeOfDay startTime = const TimeOfDay(hour: 7, minute: 0),
    int periodsCount = 7,
    int periodDuration = 45,
    int breakDuration = 15,
    int thursdayPeriodsCount = 5,
    int breakAfterPeriod = 3,
  }) {
    List<ScheduleModel> generatedSchedule = [];
    if (subjects.isEmpty || teachers.isEmpty) return [];

    int totalSlots(String day) => (day == 'Thursday' ? thursdayPeriodsCount : periodsCount) + 1;
    int maxTotalSlots = periodsCount > thursdayPeriodsCount
        ? periodsCount + 1
        : thursdayPeriodsCount + 1;

    // Categorize Subjects based on Saudi Curriculum 1447H
    final highFocusSubjects = subjects.where((s) => _isHighFocus(s.courseNameAr)).toList();
    final practicalSubjects = subjects.where((s) => _isPractical(s.courseNameAr)).toList();
    final normalSubjects = subjects
        .where((s) => !_isHighFocus(s.courseNameAr) && !_isPractical(s.courseNameAr))
        .toList();

    // Trackers for constraints
    Map<String, Map<int, Set<int>>> teacherBusyMap = {};
    Map<int, int> teacherFirstPeriodCount = {};
    Map<int, int> teacherLastPeriodCount = {};
    Map<int, Map<String, int>> teacherConsecutivePeriods = {};

    // Map to ensure (classCode, subjectCode) -> teacherCode consistency
    Map<int, Map<int, int>> classSubjectTeacherMap = {};

    // Map to ensure a teacher only teaches ONE subject in a specific class
    Map<int, Set<int>> classAssignedTeachersMap = {};

    for (var day in days) {
      teacherBusyMap[day] = {for (int i = 1; i <= maxTotalSlots; i++) i: {}};
    }

    // Process unique classes to avoid duplicate schedules
    final uniqueClasses = <int, TeacherClassModels>{};
    for (var tc in allTeacherClasses) {
      uniqueClasses[tc.classCode] = tc;
    }

    for (var schoolClass in uniqueClasses.values) {
      Map<String, Set<int>> classDailySubjects = {for (var day in days) day: {}};
      for (var day in days) {
        int slot = 1;
        int dayTotalSlots = totalSlots(day);
        while (slot <= dayTotalSlots) {
          // Rule: Insert Break after breakAfterPeriod teaching period
          if (slot == breakAfterPeriod + 1) {
            generatedSchedule.add(
              ScheduleModel(
                day: day,
                period: slot,
                subjectName: "فسحة / Break",
                subjectCode: 0,
                teacherName: "",
                teacherCode: 0,
                classCode: schoolClass.classCode,
                startTime: _calculateStartTime(
                  slot,
                  startTime,
                  periodDuration,
                  breakDuration,
                  breakAfterPeriod,
                ),
                endTime: _calculateEndTime(
                  slot,
                  startTime,
                  periodDuration,
                  breakDuration,
                  breakAfterPeriod,
                ),
                room: schoolClass.floorName ?? 'Room ${schoolClass.classCode}',
              ),
            );
            slot++;
            continue;
          }

          List<StudentCoursesModel> possibleSubjects = [];

          // Rule: Priority for Quran, Islamic, Lughati in early teaching periods (Slots 1-3)
          if (slot <= 3 && highFocusSubjects.isNotEmpty) {
            possibleSubjects = List.from(highFocusSubjects);
          }
          // Rule: Practical/Activity/Skills in late periods (Slots 6-8)
          else if (slot >= 6) {
            possibleSubjects = List.from(practicalSubjects)..addAll(normalSubjects);
          } else {
            possibleSubjects = List.from(subjects);
          }

          // Rule: Avoid repeating the same core subject in one day
          possibleSubjects.removeWhere((s) => classDailySubjects[day]!.contains(s.courseCode));
          if (possibleSubjects.isEmpty) possibleSubjects = List.from(subjects);
          possibleSubjects.shuffle();

          TeacherDataModel? selectedTeacher;
          StudentCoursesModel? selectedSubject;
          bool isDouble = false;

          for (var subject in possibleSubjects) {
            bool needsDouble = _requiresDoublePeriod(subject.courseNameAr);
            // Double periods cannot span across the break
            bool canDoDouble =
                needsDouble &&
                (slot + 1 <= dayTotalSlots && slot + 1 != breakAfterPeriod + 1) &&
                !classDailySubjects[day]!.contains(subject.courseCode);

            int? assignedTeacherCode =
                classSubjectTeacherMap[schoolClass.classCode]?[subject.courseCode];

            final subjectTeachersPool = teachers.where((t) {
              final isQualifiedForSubject = t.COURSE_CODE == subject.courseCode;
              if (!isQualifiedForSubject) return false;

              if (assignedTeacherCode != null) {
                return t.teacherCode == assignedTeacherCode;
              }

              final isAssignedToOtherSubjectInClass =
                  classAssignedTeachersMap[schoolClass.classCode]?.contains(t.teacherCode) ?? false;

              return !isAssignedToOtherSubjectInClass;
            }).toList();

            if (subjectTeachersPool.isEmpty) continue;

            final t = _findSuitableTeacher(
              subjectTeachersPool,
              assignedTeacherCode ?? schoolClass.teacherCode,
              day,
              slot,
              teacherBusyMap,
              teacherFirstPeriodCount,
              teacherLastPeriodCount,
              teacherConsecutivePeriods,
              dayTotalSlots: dayTotalSlots,
              checkNextPeriod: canDoDouble,
            );

            if (t != null) {
              selectedTeacher = t;
              selectedSubject = subject;
              isDouble = canDoDouble;

              classSubjectTeacherMap[schoolClass.classCode] ??= {};
              classSubjectTeacherMap[schoolClass.classCode]![subject.courseCode] = t.teacherCode;

              classAssignedTeachersMap[schoolClass.classCode] ??= {};
              classAssignedTeachersMap[schoolClass.classCode]!.add(t.teacherCode);
              break;
            }
          }

          if (selectedTeacher != null && selectedSubject != null) {
            _assignSlot(
              generatedSchedule,
              day,
              slot,
              selectedSubject,
              selectedTeacher,
              schoolClass,
              teacherBusyMap,
              classDailySubjects,
              teacherFirstPeriodCount,
              teacherLastPeriodCount,
              teacherConsecutivePeriods,
              startTime,
              periodDuration,
              breakDuration,
              breakAfterPeriod,
              dayTotalSlots,
            );
            if (isDouble) {
              slot++;
              _assignSlot(
                generatedSchedule,
                day,
                slot,
                selectedSubject,
                selectedTeacher,
                schoolClass,
                teacherBusyMap,
                classDailySubjects,
                teacherFirstPeriodCount,
                teacherLastPeriodCount,
                teacherConsecutivePeriods,
                startTime,
                periodDuration,
                breakDuration,
                breakAfterPeriod,
                dayTotalSlots,
              );
            }
          }
          slot++;
        }
      }
    }
    return generatedSchedule;
  }

  void _assignSlot(
    List<ScheduleModel> schedule,
    String day,
    int slot,
    StudentCoursesModel subject,
    TeacherDataModel teacher,
    TeacherClassModels schoolClass,
    Map<String, Map<int, Set<int>>> busyMap,
    Map<String, Set<int>> classDailySubjects,
    Map<int, int> firstPeriodCount,
    Map<int, int> lastPeriodCount,
    Map<int, Map<String, int>> consecutiveMap,
    TimeOfDay configStartTime,
    int configPeriodDuration,
    int configBreakDuration,
    int configBreakAfterPeriod,
    int dayTotalSlots,
  ) {
    schedule.add(
      ScheduleModel(
        day: day,
        period: slot,
        subjectName: subject.courseNameAr,
        subjectCode: subject.courseCode,
        teacherName: teacher.teacherNameAr,
        teacherCode: teacher.teacherCode,
        classCode: schoolClass.classCode,
        startTime: _calculateStartTime(
          slot,
          configStartTime,
          configPeriodDuration,
          configBreakDuration,
          configBreakAfterPeriod,
        ),
        endTime: _calculateEndTime(
          slot,
          configStartTime,
          configPeriodDuration,
          configBreakDuration,
          configBreakAfterPeriod,
        ),
        room: schoolClass.floorName ?? 'Room ${schoolClass.classCode}',
      ),
    );

    busyMap[day]![slot]!.add(teacher.teacherCode);
    classDailySubjects[day]!.add(subject.courseCode);

    // Rule: Equity in 1st and Last periods
    if (slot == 1)
      firstPeriodCount[teacher.teacherCode] = (firstPeriodCount[teacher.teacherCode] ?? 0) + 1;
    if (slot == dayTotalSlots)
      lastPeriodCount[teacher.teacherCode] = (lastPeriodCount[teacher.teacherCode] ?? 0) + 1;

    // Track consecutive periods per day
    consecutiveMap[teacher.teacherCode] ??= {};
    consecutiveMap[teacher.teacherCode]![day] =
        (consecutiveMap[teacher.teacherCode]![day] ?? 0) + 1;
  }

  TeacherDataModel? _findSuitableTeacher(
    List<TeacherDataModel> pool,
    int? preferredCode,
    String day,
    int slot,
    Map<String, Map<int, Set<int>>> busyMap,
    Map<int, int> firstPeriodCount,
    Map<int, int> lastPeriodCount,
    Map<int, Map<String, int>> consecutiveMap, {
    required int dayTotalSlots,
    bool checkNextPeriod = false,
  }) {
    if (preferredCode != null) {
      if (_isTeacherAvailable(preferredCode, day, slot, busyMap, dayTotalSlots: dayTotalSlots)) {
        if (!checkNextPeriod ||
            _isTeacherAvailable(
              preferredCode,
              day,
              slot + 1,
              busyMap,
              dayTotalSlots: dayTotalSlots,
              isOccupiedAtPeriod: slot,
            )) {
          return pool.firstWhere((t) => t.teacherCode == preferredCode, orElse: () => pool[0]);
        }
      }
    }
    final available = pool.where((t) {
      bool ok = _isTeacherAvailable(
        t.teacherCode,
        day,
        slot,
        busyMap,
        dayTotalSlots: dayTotalSlots,
      );
      if (ok && checkNextPeriod)
        ok = _isTeacherAvailable(
          t.teacherCode,
          day,
          slot + 1,
          busyMap,
          dayTotalSlots: dayTotalSlots,
          isOccupiedAtPeriod: slot,
        );

      return ok;
    }).toList();
    if (available.isNotEmpty) {
      available.sort((a, b) {
        // Preference 1: Consecutive periods (fewer is better)
        int aLoad = (consecutiveMap[a.teacherCode]?[day] ?? 0);
        int bLoad = (consecutiveMap[b.teacherCode]?[day] ?? 0);
        if (aLoad != bLoad) return aLoad.compareTo(bLoad);

        // Preference 2: Equity in First periods (only applies if current slot is 1)
        if (slot == 1) {
          int aFirst = firstPeriodCount[a.teacherCode] ?? 0;
          int bFirst = firstPeriodCount[b.teacherCode] ?? 0;
          if (aFirst != bFirst) return aFirst.compareTo(bFirst);
        }

        // Preference 3: Equity in Last periods (only applies if current slot is last)
        if (slot == dayTotalSlots) {
          int aLast = lastPeriodCount[a.teacherCode] ?? 0;
          int bLast = lastPeriodCount[b.teacherCode] ?? 0;
          if (aLast != bLast) return aLast.compareTo(bLast);
        }

        return 0;
      });
      return available[0];
    }
    return null;
  }

  bool _isTeacherAvailable(
    int tCode,
    String day,
    int slot,
    Map<String, Map<int, Set<int>>> busyMap, {
    required int dayTotalSlots,
    int? isOccupiedAtPeriod,
  }) {
    if (slot > dayTotalSlots) return false;
    // Break slot is always unavailable for teaching
    // We assume slot indexing is 1-based, and break handles itself in the main loop
    // But let's add a safety check if we pass the break slot here.
    // However, the main loop skips the break slot for teachers.

    // Basic availability
    if (busyMap[day]![slot]!.contains(tCode)) return false;

    // Rule 3: Max 3 consecutive periods (increased from 2 for better flexibility)
    if (slot >= 2) {
      bool p1 =
          (isOccupiedAtPeriod == slot - 1) || (busyMap[day]![slot - 1]?.contains(tCode) ?? false);
      if (slot >= 3) {
        bool p2 =
            (isOccupiedAtPeriod == slot - 2) || (busyMap[day]![slot - 2]?.contains(tCode) ?? false);
        if (slot >= 4) {
          bool p3 =
              (isOccupiedAtPeriod == slot - 3) ||
              (busyMap[day]![slot - 3]?.contains(tCode) ?? false);
          if (p1 && p2 && p3) return false;
        }
      }
    }

    return true;
  }

  bool _requiresDoublePeriod(String name) {
    final n = name.toLowerCase();
    return n.contains('art') ||
        n.contains('رسم') ||
        n.contains('فنية') ||
        n.contains('comp') ||
        n.contains('حاسب') ||
        n.contains('lab') ||
        n.contains('معمل') ||
        n.contains('نشاط') ||
        n.contains('activity');
  }

  bool _isHighFocus(String name) {
    final n = name.toLowerCase();
    return n.contains('math') ||
        n.contains('رياضيات') ||
        n.contains('science') ||
        n.contains('علوم') ||
        n.contains('english') ||
        n.contains('إنجليزي') ||
        n.contains('arabic') ||
        n.contains('عربي') ||
        n.contains('لغتي') ||
        n.contains('إسلامية') ||
        n.contains('قرآن') ||
        n.contains('دين');
  }

  bool _isPractical(String name) {
    final n = name.toLowerCase();
    return n.contains('pe') ||
        n.contains('بدنية') ||
        n.contains('رياضية') ||
        n.contains('art') ||
        n.contains('رسم') ||
        n.contains('فنية') ||
        n.contains('comp') ||
        n.contains('حاسب') ||
        n.contains('مهارات');
  }

  String _calculateStartTime(
    int slot,
    TimeOfDay start,
    int duration,
    int breakDur,
    int breakAfter,
  ) {
    int startMins = start.hour * 60 + start.minute;
    int currentMins = startMins;
    for (int i = 1; i < slot; i++) {
      if (i == breakAfter + 1) {
        currentMins += breakDur;
      } else {
        currentMins += duration;
      }
    }
    int h = (currentMins ~/ 60) % 24;
    int m = currentMins % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  String _calculateEndTime(int slot, TimeOfDay start, int duration, int breakDur, int breakAfter) {
    int startMins = start.hour * 60 + start.minute;
    int currentMins = startMins;
    for (int i = 1; i <= slot; i++) {
      if (i == breakAfter + 1) {
        currentMins += breakDur;
      } else {
        currentMins += duration;
      }
    }
    int h = (currentMins ~/ 60) % 24;
    int m = currentMins % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }
}
