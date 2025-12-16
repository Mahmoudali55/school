import 'package:flutter/material.dart';

class BusModel {
  final String busNumber;
  final String busName;
  final String driverName;
  final String driverPhone;
  final String currentLocation;
  final String nextStop;
  final String estimatedTime;
  final String distance;
  final String speed;
  final String capacity;
  final String occupiedSeats;
  final String status;
  final Color busColor;
  final String route;
  final String attendanceRate;
  final String fuelLevel;
  final String maintenanceStatus;
  final String studentsOnBoard;

  BusModel({
    required this.busNumber,
    required this.busName,
    required this.driverName,
    required this.driverPhone,
    required this.currentLocation,
    required this.nextStop,
    required this.estimatedTime,
    required this.distance,
    required this.speed,
    required this.capacity,
    required this.occupiedSeats,
    required this.status,
    required this.busColor,
    required this.route,
    required this.attendanceRate,
    required this.fuelLevel,
    required this.maintenanceStatus,
    required this.studentsOnBoard,
  });
}
