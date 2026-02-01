import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/error/failures.dart';
import 'package:my_template/core/network/api_consumer.dart';
import 'package:my_template/core/network/end_points.dart';
import 'package:my_template/features/bus/data/model/bus_line_model.dart';

import '../model/admin_bus_model.dart';
import '../model/bus_tracking_models.dart';

abstract class BusRepo {
  Future<List<BusClass>> getBusClasses(String userTypeId);
  Future<List<StudentOnBus>> getStudentsOnBus(String userTypeId);
  Future<List<FieldTrip>> getFieldTrips(String userTypeId);
  Future<List<BusModel>> getAdminBuses(String userTypeId);
  Future<List<BusClass>> getParentChildrenBuses({required int code});
  Map<String, dynamic> getOverviewStats(String userTypeId);
  Future<Either<Failure, List<BusLine>>> getBusLines({required int code});
}

class BusRepoImpl implements BusRepo {
  final ApiConsumer apiConsumer;
  BusRepoImpl(this.apiConsumer);

  @override
  Future<Either<Failure, List<BusLine>>> getBusLines({required int code}) async {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.get(EndPoints.busLine, queryParameters: {"Code": code});
        final String dataString = response['Data'];
        if (dataString.isEmpty || dataString == "[]") return [];
        return BusLine.fromDataString(dataString);
      },
    );
  }

  @override
  Future<List<BusClass>> getParentChildrenBuses({required int code}) async {
    final response = await apiConsumer.get(EndPoints.studentData, queryParameters: {"Code": code});

    if (response == null || response['Data'] == null) return [];

    final List<dynamic> dataList = json.decode(response['Data']);
    return dataList
        .map(
          (data) => BusClass(
            id: data['STUDENT_CODE'].toString(),
            childName: data['S_NAME'] ?? "Unknown",
            className: "الصف",
            subject: "مدرسة",
            totalStudents: "0",
            studentsOnBus: "0",
            busNumber: "BUS-001",
            driverName: "السائق",
            estimatedArrival: "---",
            currentLocation: "---",
            nextStop: "---",
            status: "في الطريق",
            attendanceRate: "0%",
            classColor: const Color(0xFF4CAF50),
            busColor: const Color(0xFF4CAF50),
          ),
        )
        .toList();
  }

  @override
  Future<List<BusClass>> getBusClasses(String userTypeId) async {
    if (userTypeId == 'student') return [];
    return [
      const BusClass(
        id: '101',
        className: 'الصف العاشر - أ',
        subject: 'الرياضيات',
        totalStudents: '32',
        studentsOnBus: '28',
        busNumber: 'BUS-05',
        driverName: 'أحمد محمود',
        estimatedArrival: '07:45 ص',
        currentLocation: 'حي الملك فهد',
        nextStop: 'شارع التخصصي',
        status: 'في الطريق',
        attendanceRate: '92%',
        classColor: Color(0xFF3B82F6),
        busColor: Color(0xFF10B981),
        lat: 24.7136,
        lng: 46.6753,
      ),
      const BusClass(
        id: '102',
        className: 'الصف التاسع - ب',
        subject: 'العلوم',
        totalStudents: '25',
        studentsOnBus: '25',
        busNumber: 'BUS-12',
        driverName: 'خالد العتيبي',
        estimatedArrival: 'وصل',
        currentLocation: 'مبنى المدرسة',
        nextStop: '--',
        status: 'مكتمل',
        attendanceRate: '100%',
        classColor: Color(0xFFF59E0B),
        busColor: Color(0xFF6B7280),
        lat: 24.7150,
        lng: 46.6780,
      ),
    ];
  }

  @override
  Future<List<StudentOnBus>> getStudentsOnBus(String userTypeId) async {
    if (userTypeId == 'student') return [];
    return [
      const StudentOnBus(
        id: '1',
        name: 'ياسين محمد',
        grade: 'الصف العاشر',
        boardingStop: 'حي النخيل',
        status: 'في الحافلة',
        attendance: 'حاضر',
        seatNumber: 'A1',
        avatarColor: Color(0xFF3B82F6),
      ),
      const StudentOnBus(
        id: '2',
        name: 'سارة أحمد',
        grade: 'الصف العاشر',
        boardingStop: 'حي الياسمين',
        status: 'في الحافلة',
        attendance: 'حاضر',
        seatNumber: 'A2',
        avatarColor: Color(0xFFEC4899),
      ),
      const StudentOnBus(
        id: '3',
        name: 'عبدالله خالد',
        grade: 'الصف العاشر',
        boardingStop: 'حي العقيق',
        status: 'لم يصعد بعد',
        attendance: 'غائب',
        seatNumber: 'B1',
        avatarColor: Color(0xFF10B981),
      ),
    ];
  }

  @override
  Future<List<FieldTrip>> getFieldTrips(String userTypeId) async {
    if (userTypeId == 'student') return [];
    return [
      const FieldTrip(
        id: 't1',
        tripName: 'زيارة المتحف الوطني',
        date: '2024-05-15',
        time: '09:00 ص',
        bus: 'BUS-20',
        driver: 'فهد الرشيد',
        students: '45 طالب',
        status: 'قادم',
        color: Color(0xFF8B5CF6),
      ),
      const FieldTrip(
        id: 't2',
        tripName: 'رحلة حديقة الحيوان',
        date: '2024-05-20',
        time: '08:30 ص',
        bus: 'BUS-25',
        driver: 'سعد القحطاني',
        students: '38 طالب',
        status: 'تمت الموافقة',
        color: Color(0xFF10B981),
      ),
    ];
  }

  @override
  Future<List<BusModel>> getAdminBuses(String userTypeId) async {
    if (userTypeId != 'admin') return [];
    return [
      BusModel(
        busNumber: 'BUS-05',
        busName: 'حافلة شمال الرياض',
        driverName: 'أحمد محمود',
        driverPhone: '0501234567',
        currentLocation: 'حي الملك فهد',
        nextStop: 'شارع التخصصي',
        estimatedTime: '15 دقيقة',
        distance: '4.2 كم',
        speed: '45 كم/س',
        capacity: '50',
        occupiedSeats: '28',
        status: 'في الطريق',
        busColor: const Color(0xFF10B981),
        route: 'المسار أ - الصباحي',
        attendanceRate: '92%',
        fuelLevel: '75%',
        maintenanceStatus: 'جيد',
        studentsOnBoard: '28',
      ),
      BusModel(
        busNumber: 'BUS-12',
        busName: 'حافلة غرب الرياض',
        driverName: 'خالد العتيبي',
        driverPhone: '0509876543',
        currentLocation: 'مبنى المدرسة',
        nextStop: '--',
        estimatedTime: 'وصل',
        distance: '0 كم',
        speed: '0 كم/س',
        capacity: '40',
        occupiedSeats: '25',
        status: 'متوقف',
        busColor: const Color(0xFF6B7280),
        route: 'المسار ب - المسائي',
        attendanceRate: '100%',
        fuelLevel: '40%',
        maintenanceStatus: 'يحتاج صيانة',
        studentsOnBoard: '25',
      ),
    ];
  }

  @override
  Map<String, dynamic> getOverviewStats(String userTypeId) {
    if (userTypeId == 'teacher') {
      return {
        'totalClasses': 5,
        'totalStudents': 142,
        'closestArrival': '12 دقيقة',
        'attendanceRate': '94%',
      };
    }
    if (userTypeId == 'admin') {
      return {
        'totalClasses': 24,
        'totalStudents': 850,
        'closestArrival': '5 دقائق',
        'attendanceRate': '96%',
      };
    }
    return {'totalClasses': 0, 'totalStudents': 0, 'closestArrival': '--', 'attendanceRate': '--'};
  }
}
