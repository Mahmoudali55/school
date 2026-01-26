import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_template/core/network/api_consumer.dart';
import 'package:my_template/core/network/end_points.dart';

import '../model/admin_bus_model.dart';
import '../model/bus_tracking_models.dart';

abstract class BusRepo {
  Future<List<BusClass>> getBusClasses(String userTypeId);
  Future<List<StudentOnBus>> getStudentsOnBus(String userTypeId);
  Future<List<FieldTrip>> getFieldTrips(String userTypeId);
  Future<List<BusModel>> getAdminBuses(String userTypeId);
  Future<List<BusClass>> getParentChildrenBuses({required int code});
  Map<String, dynamic> getOverviewStats(String userTypeId);
}

class BusRepoImpl implements BusRepo {
  final ApiConsumer apiConsumer;
  BusRepoImpl(this.apiConsumer);

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
  Future<List<BusClass>> getBusClasses(String userTypeId) async => [];

  @override
  Future<List<StudentOnBus>> getStudentsOnBus(String userTypeId) async => [];

  @override
  Future<List<FieldTrip>> getFieldTrips(String userTypeId) async => [];

  @override
  Future<List<BusModel>> getAdminBuses(String userTypeId) async => [];

  @override
  Map<String, dynamic> getOverviewStats(String userTypeId) => {
    'totalClasses': 0,
    'totalStudents': 0,
    'closestArrival': '--',
    'attendanceRate': '--',
  };
}
