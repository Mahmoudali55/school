enum LeaveStatus { pending, approved, rejected }

class LeaveRequest {
  final String id;
  final String studentId;
  final String studentName;
  final String studentGrade;
  final DateTime date;
  final String startTime;
  final String? endTime;
  final String reason;
  final LeaveStatus status;
  final DateTime createdAt;

  LeaveRequest({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentGrade,
    required this.date,
    required this.startTime,
    this.endTime,
    required this.reason,
    required this.status,
    required this.createdAt,
  });

  LeaveRequest copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? studentGrade,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? reason,
    LeaveStatus? status,
    DateTime? createdAt,
  }) {
    return LeaveRequest(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentGrade: studentGrade ?? this.studentGrade,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
