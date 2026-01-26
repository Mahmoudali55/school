import 'dart:ui';

import 'package:equatable/equatable.dart';

class BusClass extends Equatable {
  final String id;
  final String? childName;
  final String className;
  final String subject;
  final String totalStudents;
  final String studentsOnBus;
  final String busNumber;
  final String driverName;
  final String estimatedArrival;
  final String currentLocation;
  final String nextStop;
  final String status;
  final String attendanceRate;
  final Color classColor;
  final Color busColor;
  final double? lat;
  final double? lng;

  const BusClass({
    required this.id,
    this.childName,
    required this.className,
    required this.subject,
    required this.totalStudents,
    required this.studentsOnBus,
    required this.busNumber,
    required this.driverName,
    required this.estimatedArrival,
    required this.currentLocation,
    required this.nextStop,
    required this.status,
    required this.attendanceRate,
    required this.classColor,
    required this.busColor,
    this.lat,
    this.lng,
  });

  @override
  List<Object?> get props => [
    id,
    childName,
    className,
    subject,
    totalStudents,
    studentsOnBus,
    busNumber,
    driverName,
    estimatedArrival,
    currentLocation,
    nextStop,
    status,
    attendanceRate,
    classColor,
    busColor,
    lat,
    lng,
  ];

  BusClass copyWith({
    String? id,
    String? childName,
    String? className,
    String? subject,
    String? totalStudents,
    String? studentsOnBus,
    String? busNumber,
    String? driverName,
    String? estimatedArrival,
    String? currentLocation,
    String? nextStop,
    String? status,
    String? attendanceRate,
    Color? classColor,
    Color? busColor,
    double? lat,
    double? lng,
  }) {
    return BusClass(
      id: id ?? this.id,
      childName: childName ?? this.childName,
      className: className ?? this.className,
      subject: subject ?? this.subject,
      totalStudents: totalStudents ?? this.totalStudents,
      studentsOnBus: studentsOnBus ?? this.studentsOnBus,
      busNumber: busNumber ?? this.busNumber,
      driverName: driverName ?? this.driverName,
      estimatedArrival: estimatedArrival ?? this.estimatedArrival,
      currentLocation: currentLocation ?? this.currentLocation,
      nextStop: nextStop ?? this.nextStop,
      status: status ?? this.status,
      attendanceRate: attendanceRate ?? this.attendanceRate,
      classColor: classColor ?? this.classColor,
      busColor: busColor ?? this.busColor,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }
}

class StudentOnBus extends Equatable {
  final String id;
  final String name;
  final String grade;
  final String boardingStop;
  final String status;
  final String attendance;
  final String seatNumber;
  final Color avatarColor;

  const StudentOnBus({
    required this.id,
    required this.name,
    required this.grade,
    required this.boardingStop,
    required this.status,
    required this.attendance,
    required this.seatNumber,
    required this.avatarColor,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    grade,
    boardingStop,
    status,
    attendance,
    seatNumber,
    avatarColor,
  ];

  StudentOnBus copyWith({
    String? id,
    String? name,
    String? grade,
    String? boardingStop,
    String? status,
    String? attendance,
    String? seatNumber,
    Color? avatarColor,
  }) {
    return StudentOnBus(
      id: id ?? this.id,
      name: name ?? this.name,
      grade: grade ?? this.grade,
      boardingStop: boardingStop ?? this.boardingStop,
      status: status ?? this.status,
      attendance: attendance ?? this.attendance,
      seatNumber: seatNumber ?? this.seatNumber,
      avatarColor: avatarColor ?? this.avatarColor,
    );
  }
}

class FieldTrip extends Equatable {
  final String id;
  final String tripName;
  final String date;
  final String time;
  final String bus;
  final String driver;
  final String students;
  final String status;
  final Color color;

  const FieldTrip({
    required this.id,
    required this.tripName,
    required this.date,
    required this.time,
    required this.bus,
    required this.driver,
    required this.students,
    required this.status,
    required this.color,
  });

  @override
  List<Object?> get props => [id, tripName, date, time, bus, driver, students, status, color];

  FieldTrip copyWith({
    String? id,
    String? tripName,
    String? date,
    String? time,
    String? bus,
    String? driver,
    String? students,
    String? status,
    Color? color,
  }) {
    return FieldTrip(
      id: id ?? this.id,
      tripName: tripName ?? this.tripName,
      date: date ?? this.date,
      time: time ?? this.time,
      bus: bus ?? this.bus,
      driver: driver ?? this.driver,
      students: students ?? this.students,
      status: status ?? this.status,
      color: color ?? this.color,
    );
  }
}
