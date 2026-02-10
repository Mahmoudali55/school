import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/calendar/data/model/add_event_request_model.dart';
import 'package:my_template/features/calendar/data/model/calendar_event_model.dart';
import 'package:my_template/features/calendar/data/repo/calendar_repo.dart';
import 'package:my_template/features/home/data/models/teacher_class_model.dart';
import 'package:my_template/features/home/data/repository/home_repo.dart';

import 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final CalendarRepo _calendarRepo;
  final HomeRepo _homeRepo;

  CalendarCubit(this._calendarRepo, this._homeRepo)
    : super(CalendarState(selectedDate: DateTime.now(), currentView: CalendarView.monthly));

  // ================== LOAD CALENDAR DATA ==================
  Future<void> getCalendarData(String userTypeId) async {
    if (state.classesStatus.isSuccess && state.eventsStatus.isSuccess) return;

    emit(
      state.copyWith(
        classesStatus: const StatusState.loading(),
        eventsStatus: const StatusState.loading(),
      ),
    );

    final cleanType = userTypeId.trim();
    final normalizedType = switch (cleanType) {
      '1' || 'student' => 'student',
      '2' || 'parent' => 'parent',
      '3' || 'teacher' => 'teacher',
      _ => 'admin',
    };

    final classesResult = await _calendarRepo.getClasses(userTypeId: normalizedType);
    final eventsResult = await _calendarRepo.getEvents(userTypeId: normalizedType);

    classesResult.fold(
      (failure) {
        emit(state.copyWith(classesStatus: StatusState.failure(failure.errMessage)));
      },
      (classes) {
        eventsResult.fold(
          (failure) {
            emit(state.copyWith(eventsStatus: StatusState.failure(failure.errMessage)));
          },
          (events) {
            emit(
              state.copyWith(
                classesStatus: StatusState.success(classes),
                eventsStatus: StatusState.success(events),
                selectedClass: state.selectedClass ?? (classes.isNotEmpty ? classes.first : null),
              ),
            );
          },
        );
      },
    );
  }

  // ================== LOAD TEACHER CLASSES ==================
  Future<void> loadTeacherClasses() async {
    emit(state.copyWith(classesStatus: const StatusState.loading()));

    try {
      final sectionCode = int.tryParse(HiveMethods.getUserSection().toString()) ?? 0;
      final stageCode = int.tryParse(HiveMethods.getUserStage().toString()) ?? 0;
      final levelCode = 111;

      final result = await _homeRepo.teacherClasses(
        sectionCode: sectionCode,
        stageCode: stageCode,
        levelCode: levelCode,
      );

      result.fold(
        (failure) {
          emit(state.copyWith(classesStatus: StatusState.failure(failure.errMessage)));
        },
        (teacherClasses) {
          final classInfoList = _mapTeacherClassesToClassInfo(teacherClasses);
          emit(
            state.copyWith(
              classesStatus: StatusState.success(classInfoList),
              selectedClass: classInfoList.isNotEmpty ? classInfoList.first : null,
            ),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(classesStatus: StatusState.failure(e.toString())));
    }
  }

  List<ClassInfo> _mapTeacherClassesToClassInfo(List<TeacherClassModels> teacherClasses) {
    return teacherClasses
        .map(
          (teacherClass) => ClassInfo(
            id: teacherClass.classCode.toString(),
            name: teacherClass.classNameAr,
            grade: '',
            specialization: teacherClass.classNameAr,
          ),
        )
        .toList();
  }

  // ================== UI ACTIONS ==================
  void changeDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void changeView(CalendarView view) {
    emit(state.copyWith(currentView: view));
  }

  void changeClass(ClassInfo? selectedClass) {
    emit(state.copyWith(selectedClass: selectedClass));
  }

  void goToPrevious() {
    final newDate = switch (state.currentView) {
      CalendarView.monthly => DateTime(state.selectedDate.year, state.selectedDate.month - 1),
      CalendarView.weekly => state.selectedDate.subtract(const Duration(days: 7)),
      CalendarView.daily => state.selectedDate.subtract(const Duration(days: 1)),
    };
    emit(state.copyWith(selectedDate: newDate));
  }

  void goToNext() {
    final newDate = switch (state.currentView) {
      CalendarView.monthly => DateTime(state.selectedDate.year, state.selectedDate.month + 1),
      CalendarView.weekly => state.selectedDate.add(const Duration(days: 7)),
      CalendarView.daily => state.selectedDate.add(const Duration(days: 1)),
    };
    emit(state.copyWith(selectedDate: newDate));
  }

  // ================== LOCAL EVENTS ==================
  void addEventLocal(TeacherCalendarEvent event) {
    final List<TeacherCalendarEvent> events = [
      ...state.eventsStatus.data ?? <TeacherCalendarEvent>[],
      event,
    ];
    emit(state.copyWith(eventsStatus: StatusState.success(events)));
  }

  void updateEventLocal(TeacherCalendarEvent event) {
    final List<TeacherCalendarEvent> events = (state.eventsStatus.data ?? <TeacherCalendarEvent>[])
        .map((e) => e.id == event.id ? event : e)
        .toList();
    emit(state.copyWith(eventsStatus: StatusState.success(events)));
  }

  void deleteEventLocal(String eventId) {
    final List<TeacherCalendarEvent> events = (state.eventsStatus.data ?? <TeacherCalendarEvent>[])
        .where((e) => e.id != eventId)
        .toList();
    emit(state.copyWith(eventsStatus: StatusState.success(events)));
  }

  void toggleTaskStatus(String eventId) {
    final List<TeacherCalendarEvent> events = (state.eventsStatus.data ?? <TeacherCalendarEvent>[])
        .map((event) {
          if (event.id == eventId) {
            return event.copyWith(status: event.status == 'مكتمل' ? 'مخطط' : 'مكتمل');
          }
          return event;
        })
        .toList();

    emit(state.copyWith(eventsStatus: StatusState.success(events)));
  }

  Future<void> addEvent(AddEventRequestModel event) async {
    emit(state.copyWith(addEventStatus: StatusState.loading()));

    final result = await _calendarRepo.addEvent(event);
    result.fold(
      (error) => emit(state.copyWith(addEventStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(addEventStatus: StatusState.success(success))),
    );
  }
}
