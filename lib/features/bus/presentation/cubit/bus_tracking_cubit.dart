import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/bus/data/model/bus_tracking_models.dart';

import 'bus_tracking_state.dart';

class BusTrackingCubit extends Cubit<BusTrackingState> {
  Timer? _updateTimer;

  BusTrackingCubit()
    : super(
        BusTrackingState(
          classes: _dummyClasses,
          studentsOnBus: _dummyStudents,
          fieldTrips: _dummyFieldTrips,
          selectedClass: _dummyClasses.first,
          overviewStats: {
            'totalClasses': 3,
            'totalStudents': 37,
            'closestArrival': '8 د',
            'attendanceRate': '94%',
          },
        ),
      ) {
    _startPeriodicUpdates();
  }

  static final List<BusClass> _dummyClasses = [
    BusClass(
      id: '1',
      className: 'الصف العاشر - أ',
      subject: 'الرياضيات',
      totalStudents: '35 طالب',
      studentsOnBus: '12 طالب',
      busNumber: 'BUS-2024',
      driverName: 'أحمد محمد',
      estimatedArrival: '8 دقائق',
      currentLocation: 'شارع الملك فهد',
      nextStop: 'المدرسة',
      status: 'في الطريق',
      attendanceRate: '94%',
      classColor: Color(0xFF4CAF50),
      busColor: Color(0xFF4CAF50),
    ),
    BusClass(
      id: '2',
      className: 'الصف العاشر - ب',
      subject: 'الفيزياء',
      totalStudents: '32 طالب',
      studentsOnBus: '15 طالب',
      busNumber: 'BUS-2025',
      driverName: 'محمد علي',
      estimatedArrival: '15 دقيقة',
      currentLocation: 'حي السلام',
      nextStop: 'المدرسة',
      status: 'في المحطة',
      attendanceRate: '89%',
      classColor: Color(0xFF2196F3),
      busColor: Color(0xFF2196F3),
    ),
    BusClass(
      id: '3',
      className: 'الصف التاسع - أ',
      subject: 'الكيمياء',
      totalStudents: '28 طالب',
      studentsOnBus: '10 طالب',
      busNumber: 'BUS-2026',
      driverName: 'خالد أحمد',
      estimatedArrival: '22 دقيقة',
      currentLocation: 'حي الروضة',
      nextStop: 'المدرسة',
      status: 'متأخرة',
      attendanceRate: '92%',
      classColor: Color(0xFFFF9800),
      busColor: Color(0xFFFF9800),
    ),
  ];

  static final List<StudentOnBus> _dummyStudents = [
    StudentOnBus(
      id: '1',
      name: 'محمد أحمد',
      grade: 'العاشر - أ',
      boardingStop: 'محطة الجامعة',
      status: 'في الحافلة',
      attendance: 'حاضر',
      seatNumber: 'A1',
      avatarColor: Color(0xFF4CAF50),
    ),
    StudentOnBus(
      id: '2',
      name: 'فاطمة علي',
      grade: 'العاشر - أ',
      boardingStop: 'سوق المدينة',
      status: 'في الحافلة',
      attendance: 'حاضر',
      seatNumber: 'A2',
      avatarColor: Color(0xFF2196F3),
    ),
    StudentOnBus(
      id: '3',
      name: 'خالد محمد',
      grade: 'العاشر - أ',
      boardingStop: 'حديقة الحيوانات',
      status: 'في الحافلة',
      attendance: 'حاضر',
      seatNumber: 'A3',
      avatarColor: Color(0xFFFF9800),
    ),
    StudentOnBus(
      id: '4',
      name: 'سارة عبدالله',
      grade: 'العاشر - أ',
      boardingStop: 'المستشفى العام',
      status: 'في المحطة',
      attendance: 'متأخر',
      seatNumber: 'A4',
      avatarColor: Color(0xFF9C27B0),
    ),
    StudentOnBus(
      id: '5',
      name: 'عمر حسن',
      grade: 'العاشر - أ',
      boardingStop: 'المركز التجاري',
      status: 'في الطريق',
      attendance: 'متوقع',
      seatNumber: 'A5',
      avatarColor: Color(0xFFF44336),
    ),
  ];

  static final List<FieldTrip> _dummyFieldTrips = [
    FieldTrip(
      id: '1',
      tripName: 'رحلة المتحف العلمي',
      date: 'الأحد 20 نوفمبر',
      time: '08:00 ص - 02:00 م',
      bus: 'BUS-2024',
      driver: 'أحمد محمد',
      students: '25 طالب',
      status: 'مخطط',
      color: Color(0xFF4CAF50),
    ),
    FieldTrip(
      id: '2',
      tripName: 'زيارة حديقة الحيوانات',
      date: 'الثلاثاء 22 نوفمبر',
      time: '09:00 ص - 01:00 م',
      bus: 'BUS-2025',
      driver: 'محمد علي',
      students: '30 طالب',
      status: 'مؤكد',
      color: Color(0xFF2196F3),
    ),
    FieldTrip(
      id: '3',
      tripName: 'جولة في المكتبة العامة',
      date: 'الخميس 24 نوفمبر',
      time: '10:00 ص - 12:00 م',
      bus: 'BUS-2026',
      driver: 'خالد أحمد',
      students: '20 طالب',
      status: 'ملغى',
      color: Color(0xFFFF9800),
    ),
  ];

  void selectClass(String classId) {
    final selected = state.classes.firstWhere((c) => c.id == classId);
    emit(state.copyWith(selectedClass: selected));
  }

  void updateStudentStatus(String studentId, String newStatus) {
    final updatedStudents = state.studentsOnBus.map((student) {
      if (student.id == studentId) {
        return student.copyWith(status: newStatus);
      }
      return student;
    }).toList();
    emit(state.copyWith(studentsOnBus: updatedStudents));
  }

  void takeAttendance() {
    // محاكاة تسجيل الحضور
    final updatedStudents = state.studentsOnBus.map((student) {
      if (student.status == 'في الحافلة') {
        return student.copyWith(attendance: 'حاضر');
      }
      return student;
    }).toList();

    emit(state.copyWith(studentsOnBus: updatedStudents));
  }

  void addFieldTrip(FieldTrip newTrip) {
    final updatedTrips = List<FieldTrip>.from(state.fieldTrips)..add(newTrip);
    emit(state.copyWith(fieldTrips: updatedTrips));
  }

  void updateBusLocation(String busId, String newLocation) {
    final updatedClasses = state.classes.map((busClass) {
      if (busClass.id == busId) {
        return busClass.copyWith(currentLocation: newLocation);
      }
      return busClass;
    }).toList();

    emit(state.copyWith(classes: updatedClasses));
  }

  void _startPeriodicUpdates() {
    _updateTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      // محاكاة تحديثات الحافلة في الوقت الحقيقي
      if (state.classes.isNotEmpty) {
        final randomClass = state.classes[DateTime.now().second % state.classes.length];
        final newLocation = _getRandomLocation();
        updateBusLocation(randomClass.id, newLocation);
      }
    });
  }

  String _getRandomLocation() {
    final locations = [
      'شارع الملك فهد',
      'حي السلام',
      'حي الروضة',
      'وسط المدينة',
      'الطريق الدائري',
      'حي النخيل',
    ];
    return locations[DateTime.now().second % locations.length];
  }

  @override
  Future<void> close() {
    _updateTimer?.cancel();
    return super.close();
  }
}
