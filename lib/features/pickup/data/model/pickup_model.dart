enum PickUpStatus { pending, preparing, ready, pickedUp }

class PickUpRequest {
  final String id;
  final String studentId;
  final String studentName;
  final String studentGrade;
  final PickUpStatus status;
  final DateTime requestTime;

  PickUpRequest({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentGrade,
    required this.status,
    required this.requestTime,
  });

  PickUpRequest copyWith({PickUpStatus? status}) {
    return PickUpRequest(
      id: id,
      studentId: studentId,
      studentName: studentName,
      studentGrade: studentGrade,
      status: status ?? this.status,
      requestTime: requestTime,
    );
  }
}
