import 'package:flutter/material.dart';

import '../model/admin_bus_model.dart';
import '../model/bus_tracking_models.dart';

class BusRepo {
  final List<BusModel> _dummyBuses = [
    BusModel(
      busNumber: 'BUS-2024',
      busName: 'الحافلة أ',
      driverName: 'أحمد محمد',
      driverPhone: '+966500000000',
      currentLocation: 'شارع الملك فهد',
      nextStop: 'محطة الجامعة',
      estimatedTime: '7 دقائق',
      distance: '1.2 كم',
      speed: '45 كم/ساعة',
      capacity: '40 طالب',
      occupiedSeats: '32',
      status: 'في الطريق',
      busColor: const Color(0xFF4CAF50),
      route: 'الطريق الرئيسي',
      attendanceRate: '94%',
      fuelLevel: '78%',
      maintenanceStatus: 'جيد',
      studentsOnBoard: '32 طالب',
    ),
    BusModel(
      busNumber: 'BUS-2025',
      busName: 'الحافلة ب',
      driverName: 'محمد علي',
      driverPhone: '+966500000001',
      currentLocation: 'حي السلام',
      nextStop: 'سوق المدينة',
      estimatedTime: '15 دقيقة',
      distance: '3.5 كم',
      speed: '35 كم/ساعة',
      capacity: '35 طالب',
      occupiedSeats: '28',
      status: 'في المحطة',
      busColor: const Color(0xFF2196F3),
      route: 'طريق الحي الشمالي',
      attendanceRate: '89%',
      fuelLevel: '45%',
      maintenanceStatus: 'يحتاج صيانة',
      studentsOnBoard: '28 طالب',
    ),
  ];

  final List<BusClass> _dummyParentBuses = [
    BusClass(
      id: 'p1',
      childName: 'أحمد',
      className: 'الصف العاشر',
      subject: 'مدرسة النخبة الثانوية',
      totalStudents: '40',
      studentsOnBus: '32',
      busNumber: 'BUS-2024',
      driverName: 'أحمد محمد',
      estimatedArrival: '7 دقائق',
      currentLocation: 'شارع الملك فهد',
      nextStop: 'محطة الجامعة',
      status: 'في الطريق',
      attendanceRate: '94%',
      classColor: const Color(0xFF4CAF50),
      busColor: const Color(0xFF4CAF50),
    ),
    BusClass(
      id: 'p2',
      childName: 'ليلى',
      className: 'الصف الرابع',
      subject: 'مدرسة الأمل الابتدائية',
      totalStudents: '35',
      studentsOnBus: '28',
      busNumber: 'BUS-2025',
      driverName: 'محمد علي',
      estimatedArrival: '15 دقيقة',
      currentLocation: 'حي السلام',
      nextStop: 'سوق المدينة',
      status: 'في المحطة',
      attendanceRate: '89%',
      classColor: const Color(0xFF2196F3),
      busColor: const Color(0xFF2196F3),
    ),
  ];

  final List<BusClass> _dummyClasses = [
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
      classColor: const Color(0xFF4CAF50),
      busColor: const Color(0xFF4CAF50),
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
      classColor: const Color(0xFF2196F3),
      busColor: const Color(0xFF2196F3),
    ),
  ];

  final List<StudentOnBus> _dummyStudents = [
    StudentOnBus(
      id: '1',
      name: 'محمد أحمد',
      grade: 'العاشر - أ',
      boardingStop: 'محطة الجامعة',
      status: 'في الحافلة',
      attendance: 'حاضر',
      seatNumber: 'A1',
      avatarColor: const Color(0xFF4CAF50),
    ),
    StudentOnBus(
      id: '2',
      name: 'فاطمة علي',
      grade: 'العاشر - أ',
      boardingStop: 'سوق المدينة',
      status: 'في الحافلة',
      attendance: 'حاضر',
      seatNumber: 'A2',
      avatarColor: const Color(0xFF2196F3),
    ),
  ];

  final List<FieldTrip> _dummyFieldTrips = [
    FieldTrip(
      id: '1',
      tripName: 'رحلة المتحف العلمي',
      date: 'الأحد 20 نوفمبر',
      time: '08:00 ص - 02:00 م',
      bus: 'BUS-2024',
      driver: 'أحمد محمد',
      students: '25 طالب',
      status: 'مخطط',
      color: const Color(0xFF4CAF50),
    ),
  ];

  Future<List<BusClass>> getBusClasses(String userTypeId) async {
    return _dummyClasses;
  }

  Future<List<StudentOnBus>> getStudentsOnBus(String userTypeId) async {
    return _dummyStudents;
  }

  Future<List<FieldTrip>> getFieldTrips(String userTypeId) async {
    return _dummyFieldTrips;
  }

  Future<List<BusModel>> getAdminBuses(String userTypeId) async {
    return _dummyBuses;
  }

  Future<List<BusClass>> getParentChildrenBuses(String userTypeId) async {
    return _dummyParentBuses;
  }

  Map<String, dynamic> getOverviewStats(String userTypeId) {
    return {
      'totalClasses': 3,
      'totalStudents': 37,
      'closestArrival': '8 د',
      'attendanceRate': '94%',
    };
  }
}
