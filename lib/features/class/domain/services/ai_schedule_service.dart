import 'package:my_template/features/class/data/model/schedule_model.dart';
import 'package:my_template/features/class/data/model/student_courses_model.dart';
import 'package:my_template/features/home/data/models/teacher_class_model.dart';
import 'package:my_template/features/home/data/models/teacher_data_model.dart';

class AIScheduleService {
  final List<String> days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'];
  final int periodsPerDay = 7;

  /// Rules-based Schedule Generation for Saudi Schools (1447H)
  List<ScheduleModel> generateSchedules({
    required List<TeacherClassModels> allTeacherClasses,
    required List<StudentCoursesModel> subjects,
    required List<TeacherDataModel> teachers,
  }) {
    List<ScheduleModel> generatedSchedule = [];
    if (subjects.isEmpty || teachers.isEmpty) return [];

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
    // Rule 1: One teacher per subject per class
    Map<int, Map<int, int>> classSubjectTeacherMap = {};

    // Map to ensure a teacher only teaches ONE subject in a specific class
    // Rule 2: One subject per teacher per class
    Map<int, Set<int>> classAssignedTeachersMap = {};

    for (var day in days) {
      teacherBusyMap[day] = {for (int i = 1; i <= periodsPerDay; i++) i: {}};
    }

    // Process unique classes to avoid duplicate schedules for the same group
    final uniqueClasses = <int, TeacherClassModels>{};
    for (var tc in allTeacherClasses) {
      uniqueClasses[tc.classCode] = tc;
    }

    for (var schoolClass in uniqueClasses.values) {
      Map<String, Set<int>> classDailySubjects = {for (var day in days) day: {}};
      for (var day in days) {
        int period = 1;
        while (period <= periodsPerDay) {
          List<StudentCoursesModel> possibleSubjects = [];

          // Rule: Priority for Quran, Islamic, Lughati in early periods (1-3)
          if (period <= 3 && highFocusSubjects.isNotEmpty) {
            possibleSubjects = List.from(highFocusSubjects);
          }
          // Rule: Practical/Activity/Skills in late periods (6-7)
          else if (period >= 6) {
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
            bool canDoDouble =
                needsDouble &&
                (period + 1 <= periodsPerDay) &&
                !classDailySubjects[day]!.contains(subject.courseCode);

            // 1. Check if we already have a consistent teacher assigned for this (class, subject)
            int? assignedTeacherCode =
                classSubjectTeacherMap[schoolClass.classCode]?[subject.courseCode];

            // 2. Filter available teachers for THIS subject only (by COURSE_CODE)
            // AND ensure they aren't already teaching ANOTHER different subject in this class
            final subjectTeachersPool = teachers.where((t) {
              final isQualifiedForSubject = t.COURSE_CODE == subject.courseCode;
              if (!isQualifiedForSubject) return false;

              // If a teacher is already assigned to THIS specific (class, subject), they are the ONLY choice
              if (assignedTeacherCode != null) {
                return t.teacherCode == assignedTeacherCode;
              }

              // Otherwise, ensure this teacher isn't assigned to ANOTHER subject in this class (Rule 2)
              final isAssignedToOtherSubjectInClass =
                  classAssignedTeachersMap[schoolClass.classCode]?.contains(t.teacherCode) ?? false;

              return !isAssignedToOtherSubjectInClass;
            }).toList();

            if (subjectTeachersPool.isEmpty)
              continue; // No eligible teacher for this subject in this class

            // Find teacher considering Saudi justice rules
            final t = _findSuitableTeacher(
              subjectTeachersPool,
              assignedTeacherCode ?? schoolClass.teacherCode,
              day,
              period,
              teacherBusyMap,
              teacherFirstPeriodCount,
              teacherLastPeriodCount,
              teacherConsecutivePeriods,
              checkNextPeriod: canDoDouble,
            );

            if (t != null) {
              selectedTeacher = t;
              selectedSubject = subject;
              isDouble = canDoDouble;

              // Register the assignment for Rule 1 (Consistency)
              classSubjectTeacherMap[schoolClass.classCode] ??= {};
              classSubjectTeacherMap[schoolClass.classCode]![subject.courseCode] = t.teacherCode;

              // Register the assignment for Rule 2 (Uniqueness per Class)
              classAssignedTeachersMap[schoolClass.classCode] ??= {};
              classAssignedTeachersMap[schoolClass.classCode]!.add(t.teacherCode);
              break;
            }
          }

          if (selectedTeacher != null && selectedSubject != null) {
            _assignSlot(
              generatedSchedule,
              day,
              period,
              selectedSubject,
              selectedTeacher,
              schoolClass,
              teacherBusyMap,
              classDailySubjects,
              teacherFirstPeriodCount,
              teacherLastPeriodCount,
              teacherConsecutivePeriods,
            );
            if (isDouble) {
              period++;
              _assignSlot(
                generatedSchedule,
                day,
                period,
                selectedSubject,
                selectedTeacher,
                schoolClass,
                teacherBusyMap,
                classDailySubjects,
                teacherFirstPeriodCount,
                teacherLastPeriodCount,
                teacherConsecutivePeriods,
              );
            }
          }
          period++;
        }
      }
    }
    return generatedSchedule;
  }

  void _assignSlot(
    List<ScheduleModel> schedule,
    String day,
    int period,
    StudentCoursesModel subject,
    TeacherDataModel teacher,
    TeacherClassModels schoolClass,
    Map<String, Map<int, Set<int>>> busyMap,
    Map<String, Set<int>> classDailySubjects,
    Map<int, int> firstPeriodCount,
    Map<int, int> lastPeriodCount,
    Map<int, Map<String, int>> consecutiveMap,
  ) {
    schedule.add(
      ScheduleModel(
        day: day,
        period: period,
        subjectName: subject.courseNameAr,
        subjectCode: subject.courseCode,
        teacherName: teacher.teacherNameAr,
        teacherCode: teacher.teacherCode,
        classCode: schoolClass.classCode,
        startTime: _getStartTime(period),
        endTime: _getEndTime(period),
        room: schoolClass.floorName ?? 'Room ${schoolClass.classCode}',
      ),
    );

    busyMap[day]![period]!.add(teacher.teacherCode);
    classDailySubjects[day]!.add(subject.courseCode);

    // Rule: Equity in 1st and Last periods
    if (period == 1)
      firstPeriodCount[teacher.teacherCode] = (firstPeriodCount[teacher.teacherCode] ?? 0) + 1;
    if (period == periodsPerDay)
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
    int period,
    Map<String, Map<int, Set<int>>> busyMap,
    Map<int, int> firstPeriodCount,
    Map<int, int> lastPeriodCount,
    Map<int, Map<String, int>> consecutiveMap, {
    bool checkNextPeriod = false,
  }) {
    if (preferredCode != null) {
      if (_isTeacherAvailable(
        preferredCode,
        day,
        period,
        busyMap,
        firstPeriodCount,
        lastPeriodCount,
      )) {
        if (!checkNextPeriod ||
            _isTeacherAvailable(
              preferredCode,
              day,
              period + 1,
              busyMap,
              firstPeriodCount,
              lastPeriodCount,
              isOccupiedAtPeriod: period, // For Rule 3 check in period + 1
            )) {
          return pool.firstWhere((t) => t.teacherCode == preferredCode, orElse: () => pool[0]);
        }
      }
    }
    final available = pool.where((t) {
      bool ok = _isTeacherAvailable(
        t.teacherCode,
        day,
        period,
        busyMap,
        firstPeriodCount,
        lastPeriodCount,
      );
      if (ok && checkNextPeriod)
        ok = _isTeacherAvailable(
          t.teacherCode,
          day,
          period + 1,
          busyMap,
          firstPeriodCount,
          lastPeriodCount,
          isOccupiedAtPeriod: period, // For Rule 3 check in period + 1
        );
      return ok;
    }).toList();
    if (available.isNotEmpty) {
      available.sort((a, b) {
        int aLoad = (consecutiveMap[a.teacherCode]?[day] ?? 0);
        int bLoad = (consecutiveMap[b.teacherCode]?[day] ?? 0);
        return aLoad.compareTo(bLoad);
      });
      return available[0];
    }
    return null;
  }

  bool _isTeacherAvailable(
    int tCode,
    String day,
    int period,
    Map<String, Map<int, Set<int>>> busyMap,
    Map<int, int> firstPeriodCount,
    Map<int, int> lastPeriodCount, {
    int? isOccupiedAtPeriod,
  }) {
    if (period > periodsPerDay) return false;
    // Basic availability
    if (busyMap[day]![period]!.contains(tCode)) return false;
    // Rule: Equity in first/last periods (Max 2 per week as per Saudi preference)
    if (period == 1 && (firstPeriodCount[tCode] ?? 0) >= 2) return false;
    if (period == periodsPerDay && (lastPeriodCount[tCode] ?? 0) >= 2) return false;
    // Rule: If teacher has 1st period, avoid last period on the same day
    if (period == periodsPerDay && (busyMap[day]![1]?.contains(tCode) ?? false)) return false;

    // Rule 3: Max 2 consecutive periods (threshold changed from 3 to 2)
    if (period >= 2) {
      bool p1 =
          (isOccupiedAtPeriod == period - 1) ||
          (busyMap[day]![period - 1]?.contains(tCode) ?? false);
      if (period >= 3) {
        bool p2 =
            (isOccupiedAtPeriod == period - 2) ||
            (busyMap[day]![period - 2]?.contains(tCode) ?? false);
        if (p1 && p2) return false;
      } else {
        // At period 2, if p1 is busy and we are checking ahead for period 3,
        // it's only a violation if we have a chain.
        // Actually, the simple logic is: check if period-1 and period-2 are busy.
        // If we are at period 3, and 1 & 2 are busy, we are not available.
        if (p1 &&
            (isOccupiedAtPeriod == period - 2 ||
                (busyMap[day]![period - 2]?.contains(tCode) ?? false))) {
          return false;
        }
      }
    }
    // Correct sliding window for Rule 3:
    if (period > 2) {
      bool prev1 =
          (isOccupiedAtPeriod == period - 1) ||
          (busyMap[day]![period - 1]?.contains(tCode) ?? false);
      bool prev2 =
          (isOccupiedAtPeriod == period - 2) ||
          (busyMap[day]![period - 2]?.contains(tCode) ?? false);
      if (prev1 && prev2) return false;
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

  // Saudi School Times 1447H: 7:00 AM Start, 45 min periods, 15 min break after 3rd
  String _getStartTime(int period) {
    List<String> times = ['07:00', '07:45', '08:30', '09:30', '10:15', '11:00', '11:45'];
    return times[period - 1];
  }

  String _getEndTime(int period) {
    List<String> times = ['07:45', '08:30', '09:15', '10:15', '11:00', '11:45', '12:30'];
    return times[period - 1];
  }
}
