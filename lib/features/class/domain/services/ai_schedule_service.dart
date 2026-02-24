import 'package:my_template/features/class/data/model/schedule_model.dart';
import 'package:my_template/features/class/data/model/student_courses_model.dart';
import 'package:my_template/features/home/data/models/teacher_class_model.dart';
import 'package:my_template/features/home/data/models/teacher_data_model.dart';

class AIScheduleService {
  final List<String> days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'];
  final int totalSlotsPerDay = 8; // 7 teaching periods + 1 break

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
    Map<int, Map<int, int>> classSubjectTeacherMap = {};

    // Map to ensure a teacher only teaches ONE subject in a specific class
    Map<int, Set<int>> classAssignedTeachersMap = {};

    for (var day in days) {
      teacherBusyMap[day] = {for (int i = 1; i <= totalSlotsPerDay; i++) i: {}};
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
        while (slot <= totalSlotsPerDay) {
          // Rule: Insert Break after 3rd teaching period (Slot 4)
          if (slot == 4) {
            generatedSchedule.add(
              ScheduleModel(
                day: day,
                period: 4,
                subjectName: "فسحة / Break",
                subjectCode: 0,
                teacherName: "",
                teacherCode: 0,
                classCode: schoolClass.classCode,
                startTime: _getStartTime(4),
                endTime: _getEndTime(4),
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
            // Double periods cannot span across the break (Slot 4)
            bool canDoDouble =
                needsDouble &&
                (slot + 1 <= totalSlotsPerDay && slot + 1 != 4) &&
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
        startTime: _getStartTime(slot),
        endTime: _getEndTime(slot),
        room: schoolClass.floorName ?? 'Room ${schoolClass.classCode}',
      ),
    );

    busyMap[day]![slot]!.add(teacher.teacherCode);
    classDailySubjects[day]!.add(subject.courseCode);

    // Rule: Equity in 1st and Last periods (Slot 1 and Slot 8)
    if (slot == 1)
      firstPeriodCount[teacher.teacherCode] = (firstPeriodCount[teacher.teacherCode] ?? 0) + 1;
    if (slot == totalSlotsPerDay)
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
    bool checkNextPeriod = false,
  }) {
    if (preferredCode != null) {
      if (_isTeacherAvailable(
        preferredCode,
        day,
        slot,
        busyMap,
        firstPeriodCount,
        lastPeriodCount,
      )) {
        if (!checkNextPeriod ||
            _isTeacherAvailable(
              preferredCode,
              day,
              slot + 1,
              busyMap,
              firstPeriodCount,
              lastPeriodCount,
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
        firstPeriodCount,
        lastPeriodCount,
      );
      if (ok && checkNextPeriod)
        ok = _isTeacherAvailable(
          t.teacherCode,
          day,
          slot + 1,
          busyMap,
          firstPeriodCount,
          lastPeriodCount,
          isOccupiedAtPeriod: slot,
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
    int slot,
    Map<String, Map<int, Set<int>>> busyMap,
    Map<int, int> firstPeriodCount,
    Map<int, int> lastPeriodCount, {
    int? isOccupiedAtPeriod,
  }) {
    if (slot > totalSlotsPerDay) return false;
    // Slot 4 is always a break, but we shouldn't be assigning teachers here anyway
    if (slot == 4) return false;

    // Basic availability
    if (busyMap[day]![slot]!.contains(tCode)) return false;

    // Rule: Equity in first/last periods
    if (slot == 1 && (firstPeriodCount[tCode] ?? 0) >= 2) return false;
    if (slot == totalSlotsPerDay && (lastPeriodCount[tCode] ?? 0) >= 2) return false;

    // Rule 3: Max 2 consecutive periods
    if (slot >= 2) {
      bool p1 =
          (isOccupiedAtPeriod == slot - 1) || (busyMap[day]![slot - 1]?.contains(tCode) ?? false);
      if (slot >= 3) {
        bool p2 =
            (isOccupiedAtPeriod == slot - 2) || (busyMap[day]![slot - 2]?.contains(tCode) ?? false);
        if (p1 && p2) return false;
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

  // Saudi School Times 1447H: 7:00 AM Start, 45 min periods, 15 min break after 3rd
  String _getStartTime(int slot) {
    List<String> times = [
      '07:00',
      '07:45',
      '08:30',
      '09:15', // Break starts
      '09:30',
      '10:15',
      '11:00',
      '11:45',
    ];
    return times[slot - 1];
  }

  String _getEndTime(int slot) {
    List<String> times = [
      '07:45',
      '08:30',
      '09:15',
      '09:30', // Break ends
      '10:15',
      '11:00',
      '11:45',
      '12:30',
    ];
    return times[slot - 1];
  }
}
