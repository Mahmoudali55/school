import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/error/failures.dart';
import 'package:my_template/core/network/api_consumer.dart';
import 'package:my_template/core/network/end_points.dart';
import 'package:my_template/features/calendar/data/model/add_event_request_model.dart';
import 'package:my_template/features/calendar/data/model/add_event_response_model.dart';

import '../model/calendar_event_model.dart';

abstract interface class CalendarRepo {
  Future<Either<Failure, List<ClassInfo>>> getClasses({required String userTypeId});

  Future<Either<Failure, List<TeacherCalendarEvent>>> getEvents({required String userTypeId});
  Future<Either<Failure, AddEventResponseModel>> addEvent(AddEventRequestModel event);
}

class CalendarRepoImpl implements CalendarRepo {
  final ApiConsumer apiConsumer;

  CalendarRepoImpl(this.apiConsumer);

  /// Dummy Classes
  final List<ClassInfo> _dummyClasses = [
    ClassInfo(id: '1', name: 'الصف العاشر', grade: 'العاشر', specialization: 'علمي'),
    ClassInfo(id: '2', name: 'الصف التاسع', grade: 'التاسع', specialization: 'أدبي'),
    ClassInfo(id: '3', name: 'الصف الحادي عشر', grade: 'الحادي عشر', specialization: 'علمي'),
  ];

  /// Dummy Events
  final List<TeacherCalendarEvent> _teacherEvents = [
    TeacherCalendarEvent(
      id: '1',
      title: 'حصّة الرياضيات',
      date: DateTime.now(),
      startTime: const TimeOfDay(hour: 8, minute: 0),
      endTime: const TimeOfDay(hour: 8, minute: 45),
      type: EventType.classEvent,
      location: 'القاعة ١٠١',
      description: 'الوحدة الثالثة - الجبر',
      className: 'الصف العاشر - علمي',
      subject: 'الرياضيات',
    ),
    TeacherCalendarEvent(
      id: '2',
      title: 'اجتماع المدرسين',
      date: DateTime.now().add(const Duration(days: 1)),
      startTime: const TimeOfDay(hour: 10, minute: 0),
      endTime: const TimeOfDay(hour: 11, minute: 0),
      type: EventType.meeting,
      location: 'قاعة الاجتماعات',
      description: 'مناقشة الخطط الدراسية',
      className: 'جميع الصفوف',
      subject: 'اجتماع',
    ),
  ];

  @override
  Future<Either<Failure, List<ClassInfo>>> getClasses({required String userTypeId}) {
    return handleDioRequest(
      request: () async {
        // 🔜 هنا تقدر تبدل Dummy بـ API
        return _dummyClasses;
      },
    );
  }

  @override
  Future<Either<Failure, List<TeacherCalendarEvent>>> getEvents({required String userTypeId}) {
    return handleDioRequest(
      request: () async {
        // 🔜 role-based filtering ممكن يتحط هنا
        return _teacherEvents;
      },
    );
  }

  @override
  Future<Either<Failure, AddEventResponseModel>> addEvent(AddEventRequestModel event) {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.post(EndPoints.addEvents, body: event.toJson());
        return AddEventResponseModel.fromJson(response);
      },
    );
  }
}
