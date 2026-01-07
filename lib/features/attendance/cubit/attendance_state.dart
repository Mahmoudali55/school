part of 'attendance_cubit.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceSaving extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  final List<AttendanceRecordModel> records;

  const AttendanceLoaded(this.records);

  @override
  List<Object?> get props => [records];
}

class AttendanceSaved extends AttendanceState {
  final List<AttendanceRecordModel> records;

  const AttendanceSaved(this.records);

  @override
  List<Object?> get props => [records];
}

class AttendanceRecordSaved extends AttendanceState {
  final AttendanceRecordModel record;

  const AttendanceRecordSaved(this.record);

  @override
  List<Object?> get props => [record];
}

class AttendanceRecordUpdated extends AttendanceState {
  final AttendanceRecordModel record;

  const AttendanceRecordUpdated(this.record);

  @override
  List<Object?> get props => [record];
}

class AttendanceRecordDeleted extends AttendanceState {}

class AttendanceStatsLoaded extends AttendanceState {
  final Map<String, int> stats;

  const AttendanceStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class StudentAttendanceHistoryLoaded extends AttendanceState {
  final List<AttendanceRecordModel> records;

  const StudentAttendanceHistoryLoaded(this.records);

  @override
  List<Object?> get props => [records];
}

class AttendancePercentageLoaded extends AttendanceState {
  final double percentage;

  const AttendancePercentageLoaded(this.percentage);

  @override
  List<Object?> get props => [percentage];
}

class AttendanceError extends AttendanceState {
  final String message;

  const AttendanceError(this.message);

  @override
  List<Object?> get props => [message];
}
