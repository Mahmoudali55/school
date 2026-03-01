import 'dart:math';

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
    int thursdayPeriodsCount = 6,
    int breakAfterPeriod = 3,
    List<int> prioritySubjectCodes = const [],
    List<int> doublePeriodSubjectCodes = const [],
  }) {
    List<ScheduleModel> generatedSchedule = [];
    if (subjects.isEmpty || teachers.isEmpty) return [];

    // --- 1. Global Constraints & Setup ---
    int totalSlots(String day) => (day == 'Thursday' ? thursdayPeriodsCount : periodsCount) + 1;
    final int baseMaxTeacherPeriodsPerDay = 5; // Saudi typical max per day (approx 20-24 per week)

    // Categorize Subjects
    final highFocusSubjects = subjects.where((s) {
      if (prioritySubjectCodes.contains(s.courseCode)) return true;
      return _isHighFocus(s.courseNameAr);
    }).toList();

    final practicalSubjects = subjects.where((s) {
      return _isPractical(s.courseNameAr);
    }).toList();

    final normalSubjects = subjects
        .where((s) => !highFocusSubjects.contains(s) && !practicalSubjects.contains(s))
        .toList();

    // Subject frequency limits (heuristics for Saudi curriculum)
    // E.g. Math/Lughati -> 5 times a week, Science -> 4, etc.
    Map<int, int> maxSubjectPeriodsPerWeek = {};
    for (var sub in subjects) {
      if (_isHighFocus(sub.courseNameAr)) {
        maxSubjectPeriodsPerWeek[sub.courseCode] = 5; // Once a day maximum ideally
      } else if (sub.courseNameAr.contains('قرآن') || sub.courseNameAr.contains('قراءات')) {
        maxSubjectPeriodsPerWeek[sub.courseCode] = 4;
      } else if (_isPractical(sub.courseNameAr)) {
        maxSubjectPeriodsPerWeek[sub.courseCode] = 2; // Art/PE -> twice a week
      } else {
        maxSubjectPeriodsPerWeek[sub.courseCode] = 3; // Others
      }
    }

    // --- 2. Trackers ---
    Map<String, Map<int, Set<int>>> teacherBusyMap = {};
    Map<int, int> teacherFirstPeriodCount = {}; // Track first periods for equity
    Map<int, int> teacherLastPeriodCount = {}; // Track last periods for equity
    Map<int, Map<String, int>> teacherDailyLoad = {}; // Track daily total load
    Map<int, Map<String, int>> teacherConsecutivePeriods = {}; // Track consecutive load

    // Map to ensure (classCode, subjectCode) -> assignedTeacherCode
    Map<int, Map<int, int>> classSubjectTeacherMap = {};

    // Track weekly subject counts per class to avoid exceeding plan
    Map<int, Map<int, int>> classWeeklySubjectCounts = {};

    for (var day in days) {
      teacherBusyMap[day] = {};
      for (int i = 1; i <= periodsCount + 1; i++) {
        teacherBusyMap[day]![i] = {};
      }
    }

    // Unique Classes to process
    final uniqueClasses = <int, TeacherClassModels>{};
    for (var tc in allTeacherClasses) {
      uniqueClasses[tc.classCode] = tc;
      classWeeklySubjectCounts[tc.classCode] = {for (var s in subjects) s.courseCode: 0};
    }

    final rand = Random();

    // --- 3. Generation Loop ---
    for (var schoolClass in uniqueClasses.values) {
      Map<String, Set<int>> classDailySubjects = {for (var day in days) day: {}};

      for (var day in days) {
        int slot = 1;
        int academicPeriod = 1;
        int dayTotalSlots = totalSlots(day);

        while (slot <= dayTotalSlots) {
          // Rule: Insert Break
          if (slot == breakAfterPeriod + 1) {
            generatedSchedule.add(
              ScheduleModel(
                day: day,
                period: 0,
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

          // Rule: Priority sorting based on slot time
          List<StudentCoursesModel> possibleSubjects = [];
          if (slot <= 3 && highFocusSubjects.isNotEmpty) {
            possibleSubjects = List.from(highFocusSubjects)..shuffle(rand);
            possibleSubjects.addAll(List.from(normalSubjects)..shuffle(rand));
            possibleSubjects.addAll(List.from(practicalSubjects)..shuffle(rand));
          } else if (slot >= dayTotalSlots - 1) {
            possibleSubjects = List.from(practicalSubjects)..shuffle(rand);
            possibleSubjects.addAll(List.from(normalSubjects)..shuffle(rand));
            possibleSubjects.addAll(List.from(highFocusSubjects)..shuffle(rand));
          } else {
            possibleSubjects = List.from(subjects)..shuffle(rand);
          }

          // Filter out subjects that have exceeded their weekly limit
          possibleSubjects.removeWhere((s) {
            int currentCount = classWeeklySubjectCounts[schoolClass.classCode]![s.courseCode] ?? 0;
            return currentCount >= (maxSubjectPeriodsPerWeek[s.courseCode] ?? 5);
          });

          // Rule: Avoid repeating same core subject in one day
          possibleSubjects.removeWhere((s) {
            // Allow PE/Art to repeat on the same day ONLY IF it's a consecutive double period
            // So for general selection, don't allow it if it already exists that day.
            return classDailySubjects[day]!.contains(s.courseCode);
          });

          // Fallback if strict limits are causing dead-ends (rare, but prevents infinite loop)
          if (possibleSubjects.isEmpty) {
            possibleSubjects = List.from(subjects)..shuffle(rand);
            possibleSubjects.removeWhere((s) => classDailySubjects[day]!.contains(s.courseCode));
            if (possibleSubjects.isEmpty)
              possibleSubjects = List.from(subjects)..shuffle(rand); // Absolute fallback
          }

          TeacherDataModel? selectedTeacher;
          StudentCoursesModel? selectedSubject;
          bool isDouble = false;

          for (var subject in possibleSubjects) {
            bool needsDouble =
                doublePeriodSubjectCodes.contains(subject.courseCode) ||
                _requiresDoublePeriod(subject.courseNameAr);

            // Cannot span across break, and consecutive cannot exceed day limits
            bool canDoDouble =
                needsDouble && (slot + 1 <= dayTotalSlots && slot + 1 != breakAfterPeriod + 1);

            int? assignedTeacherCode =
                classSubjectTeacherMap[schoolClass.classCode]?[subject.courseCode];

            final subjectTeachersPool = teachers.where((t) {
              if (t.COURSE_CODE != subject.courseCode) return false;
              if (assignedTeacherCode != null && t.teacherCode != assignedTeacherCode) return false;

              // Check max daily load
              int currentLoad = teacherDailyLoad[t.teacherCode]?[day] ?? 0;
              if (currentLoad >= baseMaxTeacherPeriodsPerDay) return false;
              if (canDoDouble && currentLoad + 1 >= baseMaxTeacherPeriodsPerDay) return false;

              return true;
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
              classWeeklySubjectCounts,
              teacherDailyLoad,
              teacherFirstPeriodCount,
              teacherLastPeriodCount,
              teacherConsecutivePeriods,
              startTime,
              periodDuration,
              breakDuration,
              breakAfterPeriod,
              academicPeriod,
              dayTotalSlots,
            );

            if (isDouble) {
              slot++;
              academicPeriod++;
              _assignSlot(
                generatedSchedule,
                day,
                slot,
                selectedSubject,
                selectedTeacher,
                schoolClass,
                teacherBusyMap,
                classDailySubjects,
                classWeeklySubjectCounts,
                teacherDailyLoad,
                teacherFirstPeriodCount,
                teacherLastPeriodCount,
                teacherConsecutivePeriods,
                startTime,
                periodDuration,
                breakDuration,
                breakAfterPeriod,
                academicPeriod,
                dayTotalSlots,
              );
            }
            academicPeriod++;
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
    Map<int, Map<int, int>> weeklyCounts,
    Map<int, Map<String, int>> teacherDailyLoad,
    Map<int, int> firstPeriodCount,
    Map<int, int> lastPeriodCount,
    Map<int, Map<String, int>> consecutiveMap,
    TimeOfDay configStartTime,
    int configPeriodDuration,
    int configBreakDuration,
    int configBreakAfterPeriod,
    int academicPeriod,
    int dayTotalSlots,
  ) {
    schedule.add(
      ScheduleModel(
        day: day,
        period: academicPeriod,
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

    // Track class subject
    classDailySubjects[day]!.add(subject.courseCode);
    weeklyCounts[schoolClass.classCode]![subject.courseCode] =
        (weeklyCounts[schoolClass.classCode]![subject.courseCode] ?? 0) + 1;

    // Track teacher occupation
    busyMap[day]![slot]!.add(teacher.teacherCode);
    teacherDailyLoad[teacher.teacherCode] ??= {};
    teacherDailyLoad[teacher.teacherCode]![day] =
        (teacherDailyLoad[teacher.teacherCode]![day] ?? 0) + 1;

    // Equity tracking
    if (slot == 1)
      firstPeriodCount[teacher.teacherCode] = (firstPeriodCount[teacher.teacherCode] ?? 0) + 1;
    if (slot == dayTotalSlots)
      lastPeriodCount[teacher.teacherCode] = (lastPeriodCount[teacher.teacherCode] ?? 0) + 1;

    // Consecutive tracking
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
    // 1. Check preferred teacher first
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
          final t = pool.where((t) => t.teacherCode == preferredCode).firstOrNull;
          if (t != null) return t;
        }
      }
    }

    // 2. Filter available pool
    final available = pool.where((t) {
      if (!_isTeacherAvailable(t.teacherCode, day, slot, busyMap, dayTotalSlots: dayTotalSlots))
        return false;
      if (checkNextPeriod &&
          !_isTeacherAvailable(
            t.teacherCode,
            day,
            slot + 1,
            busyMap,
            dayTotalSlots: dayTotalSlots,
            isOccupiedAtPeriod: slot,
          )) {
        return false;
      }
      return true;
    }).toList();

    if (available.isEmpty) return null;

    // 3. Sort by Equity Rules
    available.sort((a, b) {
      int aLoad = (consecutiveMap[a.teacherCode]?[day] ?? 0);
      int bLoad = (consecutiveMap[b.teacherCode]?[day] ?? 0);
      if (aLoad != bLoad)
        return aLoad.compareTo(bLoad); // Prefer teacher with less consecutive periods today

      if (slot == 1) {
        int aFirst = firstPeriodCount[a.teacherCode] ?? 0;
        int bFirst = firstPeriodCount[b.teacherCode] ?? 0;
        if (aFirst != bFirst) return aFirst.compareTo(bFirst); // Fairness in 1st period
      }

      if (slot == dayTotalSlots) {
        int aLast = lastPeriodCount[a.teacherCode] ?? 0;
        int bLast = lastPeriodCount[b.teacherCode] ?? 0;
        if (aLast != bLast) return aLast.compareTo(bLast); // Fairness in last period
      }

      return 0; // Equal
    });

    return available.first;
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

    // Safety check: is it already busy?
    if (busyMap[day]?[slot]?.contains(tCode) ?? false) return false;

    // Rule: Max 3 consecutive periods strictly enforced
    if (slot >= 3) {
      bool p1 =
          (isOccupiedAtPeriod == slot - 1) || (busyMap[day]![slot - 1]?.contains(tCode) ?? false);
      bool p2 =
          (isOccupiedAtPeriod == slot - 2) || (busyMap[day]![slot - 2]?.contains(tCode) ?? false);
      if (p1 && p2) {
        return false; // Already teaching 2 periods right before this, so a 3rd would make it 3 consecutive which is the absolute limit, but giving them a break is preferred.
      }
    }

    return true;
  }

  String _normalize(String text) {
    return text
        .toLowerCase()
        .replaceAll('إ', 'ا')
        .replaceAll('أ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .trim();
  }

  bool _requiresDoublePeriod(String name) {
    final n = _normalize(name);
    return n.contains('art') ||
        n.contains('رسم') ||
        n.contains('فنيه') ||
        n.contains('comp') ||
        n.contains('حاسب') ||
        n.contains('lab') ||
        n.contains('معمل') ||
        n.contains('اسريه') ||
        n.contains('نشاط');
  }

  bool _isHighFocus(String name) {
    final n = _normalize(name);
    return n.contains('math') ||
        n.contains('رياضيات') ||
        n.contains('science') ||
        n.contains('علوم') ||
        n.contains('english') ||
        n.contains('انجيليزي') ||
        n.contains('انجليزيه') ||
        n.contains('arabic') ||
        n.contains('عربي') ||
        n.contains('لغتي') ||
        n.contains('اسلاميه') ||
        n.contains('قران') ||
        n.contains('دين');
  }

  bool _isPractical(String name) {
    final n = _normalize(name);
    return n.contains('pe') ||
        n.contains('بدنيه') ||
        n.contains('رياضيه') ||
        n.contains('art') ||
        n.contains('رسم') ||
        n.contains('فنيه') ||
        n.contains('comp') ||
        n.contains('حاسب') ||
        n.contains('اسريه') ||
        n.contains('مهارات');
  }

  String _calculateStartTime(
    int slot,
    TimeOfDay start,
    int duration,
    int breakDur,
    int breakAfter,
  ) {
    int currentMins = start.hour * 60 + start.minute;
    for (int i = 1; i < slot; i++) {
      if (i == breakAfter + 1)
        currentMins += breakDur;
      else
        currentMins += duration;
    }
    return '${(currentMins ~/ 60) % 24}'.padLeft(2, '0') +
        ':' +
        '${currentMins % 60}'.padLeft(2, '0');
  }

  String _calculateEndTime(int slot, TimeOfDay start, int duration, int breakDur, int breakAfter) {
    int currentMins = start.hour * 60 + start.minute;
    for (int i = 1; i <= slot; i++) {
      if (i == breakAfter + 1)
        currentMins += breakDur;
      else
        currentMins += duration;
    }
    return '${(currentMins ~/ 60) % 24}'.padLeft(2, '0') +
        ':' +
        '${currentMins % 60}'.padLeft(2, '0');
  }
}
