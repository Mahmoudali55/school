import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

import '../models/attendance_record_model.dart';

class AttendanceRepo {
  static const String _boxName = 'attendance_records';

  Future<Box<AttendanceRecordModel>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<AttendanceRecordModel>(_boxName);
    }
    return Hive.box<AttendanceRecordModel>(_boxName);
  }

  /// Save attendance record
  Future<Either<String, AttendanceRecordModel>> saveAttendanceRecord(
    AttendanceRecordModel record,
  ) async {
    try {
      final box = await _getBox();
      await box.put(record.id, record);
      return Right(record);
    } catch (e) {
      return Left('Failed to save attendance: ${e.toString()}');
    }
  }

  /// Save multiple attendance records
  Future<Either<String, List<AttendanceRecordModel>>> saveAttendanceRecords(
    List<AttendanceRecordModel> records,
  ) async {
    try {
      final box = await _getBox();
      final Map<String, AttendanceRecordModel> recordsMap = {
        for (var record in records) record.id: record,
      };
      await box.putAll(recordsMap);
      return Right(records);
    } catch (e) {
      return Left('Failed to save attendance records: ${e.toString()}');
    }
  }

  /// Get attendance records for a specific date and class
  Future<Either<String, List<AttendanceRecordModel>>> getAttendanceByDateAndClass({
    required DateTime date,
    required String classId,
  }) async {
    try {
      final box = await _getBox();
      final records = box.values.where((record) {
        final isSameDate =
            record.date.year == date.year &&
            record.date.month == date.month &&
            record.date.day == date.day;
        return isSameDate && record.classId == classId;
      }).toList();

      return Right(records);
    } catch (e) {
      return Left('Failed to get attendance: ${e.toString()}');
    }
  }

  /// Get attendance records for a student
  Future<Either<String, List<AttendanceRecordModel>>> getStudentAttendance({
    required String studentId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final box = await _getBox();
      var records = box.values.where((record) => record.studentId == studentId);

      if (startDate != null) {
        records = records.where((record) => record.date.isAfter(startDate));
      }

      if (endDate != null) {
        records = records.where((record) => record.date.isBefore(endDate));
      }

      return Right(records.toList());
    } catch (e) {
      return Left('Failed to get student attendance: ${e.toString()}');
    }
  }

  /// Get attendance statistics for a class
  Future<Either<String, Map<String, int>>> getClassAttendanceStats({
    required String classId,
    required DateTime date,
  }) async {
    try {
      final result = await getAttendanceByDateAndClass(date: date, classId: classId);

      return result.fold((error) => Left(error), (records) {
        final stats = {
          'total': records.length,
          'present': records.where((r) => r.status == AttendanceStatus.present).length,
          'absent': records.where((r) => r.status == AttendanceStatus.absent).length,
          'late': records.where((r) => r.status == AttendanceStatus.late).length,
          'excused': records.where((r) => r.status == AttendanceStatus.excused).length,
        };
        return Right(stats);
      });
    } catch (e) {
      return Left('Failed to get attendance stats: ${e.toString()}');
    }
  }

  /// Update attendance record
  Future<Either<String, AttendanceRecordModel>> updateAttendanceRecord(
    AttendanceRecordModel record,
  ) async {
    try {
      final box = await _getBox();
      await box.put(record.id, record);
      return Right(record);
    } catch (e) {
      return Left('Failed to update attendance: ${e.toString()}');
    }
  }

  /// Delete attendance record
  Future<Either<String, bool>> deleteAttendanceRecord(String recordId) async {
    try {
      final box = await _getBox();
      await box.delete(recordId);
      return const Right(true);
    } catch (e) {
      return Left('Failed to delete attendance: ${e.toString()}');
    }
  }

  /// Check if attendance exists for student on date
  Future<bool> hasAttendanceRecord({required String studentId, required DateTime date}) async {
    try {
      final box = await _getBox();
      return box.values.any((record) {
        final isSameDate =
            record.date.year == date.year &&
            record.date.month == date.month &&
            record.date.day == date.day;
        return record.studentId == studentId && isSameDate;
      });
    } catch (e) {
      return false;
    }
  }

  /// Get attendance percentage for a student
  Future<Either<String, double>> getStudentAttendancePercentage({
    required String studentId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final result = await getStudentAttendance(
        studentId: studentId,
        startDate: startDate,
        endDate: endDate,
      );

      return result.fold((error) => Left(error), (records) {
        if (records.isEmpty) return const Right(0.0);

        final presentCount = records.where((r) => r.status == AttendanceStatus.present).length;
        final percentage = (presentCount / records.length) * 100;

        return Right(percentage);
      });
    } catch (e) {
      return Left('Failed to calculate attendance percentage: ${e.toString()}');
    }
  }
}
