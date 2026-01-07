import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/attendance_record_model.dart';
import '../data/repository/attendance_repo.dart';

part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final AttendanceRepo attendanceRepo;

  AttendanceCubit({required this.attendanceRepo}) : super(AttendanceInitial());

  /// Load attendance for a specific class and date
  Future<void> loadAttendance({required String classId, required DateTime date}) async {
    emit(AttendanceLoading());

    try {
      final result = await attendanceRepo.getAttendanceByDateAndClass(date: date, classId: classId);

      result.fold(
        (error) => emit(AttendanceError(error)),
        (records) => emit(AttendanceLoaded(records)),
      );
    } catch (e) {
      emit(AttendanceError('Failed to load attendance: ${e.toString()}'));
    }
  }

  /// Save attendance records
  Future<void> saveAttendanceRecords(List<AttendanceRecordModel> records) async {
    emit(AttendanceSaving());

    try {
      final result = await attendanceRepo.saveAttendanceRecords(records);

      result.fold(
        (error) => emit(AttendanceError(error)),
        (savedRecords) => emit(AttendanceSaved(savedRecords)),
      );
    } catch (e) {
      emit(AttendanceError('Failed to save attendance: ${e.toString()}'));
    }
  }

  /// Save single attendance record
  Future<void> saveAttendanceRecord(AttendanceRecordModel record) async {
    emit(AttendanceSaving());

    try {
      final result = await attendanceRepo.saveAttendanceRecord(record);

      result.fold(
        (error) => emit(AttendanceError(error)),
        (savedRecord) => emit(AttendanceRecordSaved(savedRecord)),
      );
    } catch (e) {
      emit(AttendanceError('Failed to save attendance: ${e.toString()}'));
    }
  }

  /// Update attendance record
  Future<void> updateAttendanceRecord(AttendanceRecordModel record) async {
    emit(AttendanceSaving());

    try {
      final result = await attendanceRepo.updateAttendanceRecord(record);

      result.fold(
        (error) => emit(AttendanceError(error)),
        (updatedRecord) => emit(AttendanceRecordUpdated(updatedRecord)),
      );
    } catch (e) {
      emit(AttendanceError('Failed to update attendance: ${e.toString()}'));
    }
  }

  /// Get attendance statistics for a class
  Future<void> getAttendanceStats({required String classId, required DateTime date}) async {
    emit(AttendanceLoading());

    try {
      final result = await attendanceRepo.getClassAttendanceStats(classId: classId, date: date);

      result.fold(
        (error) => emit(AttendanceError(error)),
        (stats) => emit(AttendanceStatsLoaded(stats)),
      );
    } catch (e) {
      emit(AttendanceError('Failed to load stats: ${e.toString()}'));
    }
  }

  /// Get student attendance history
  Future<void> getStudentAttendanceHistory({
    required String studentId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    emit(AttendanceLoading());

    try {
      final result = await attendanceRepo.getStudentAttendance(
        studentId: studentId,
        startDate: startDate,
        endDate: endDate,
      );

      result.fold(
        (error) => emit(AttendanceError(error)),
        (records) => emit(StudentAttendanceHistoryLoaded(records)),
      );
    } catch (e) {
      emit(AttendanceError('Failed to load student history: ${e.toString()}'));
    }
  }

  /// Get student attendance percentage
  Future<void> getStudentAttendancePercentage({
    required String studentId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    emit(AttendanceLoading());

    try {
      final result = await attendanceRepo.getStudentAttendancePercentage(
        studentId: studentId,
        startDate: startDate,
        endDate: endDate,
      );

      result.fold(
        (error) => emit(AttendanceError(error)),
        (percentage) => emit(AttendancePercentageLoaded(percentage)),
      );
    } catch (e) {
      emit(AttendanceError('Failed to calculate percentage: ${e.toString()}'));
    }
  }

  /// Check if attendance exists for student on date
  Future<bool> hasAttendanceRecord({required String studentId, required DateTime date}) async {
    return await attendanceRepo.hasAttendanceRecord(studentId: studentId, date: date);
  }

  /// Delete attendance record
  Future<void> deleteAttendanceRecord(String recordId) async {
    emit(AttendanceSaving());

    try {
      final result = await attendanceRepo.deleteAttendanceRecord(recordId);

      result.fold((error) => emit(AttendanceError(error)), (_) => emit(AttendanceRecordDeleted()));
    } catch (e) {
      emit(AttendanceError('Failed to delete record: ${e.toString()}'));
    }
  }
}
