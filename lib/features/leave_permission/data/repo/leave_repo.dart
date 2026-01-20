import '../model/leave_model.dart';

class LeaveRepo {
  final List<LeaveRequest> _dummyLeaves = [
    LeaveRequest(
      id: "LV-001",
      studentId: "ST-101",
      studentName: "أحمد بن محمد",
      studentGrade: "الصف الرابع - أ",
      date: DateTime.now().add(const Duration(days: 1)),
      startTime: "10:30 AM",
      endTime: "12:30 PM",
      reason: "موعد طبي بمستشفى الملك فيصل",
      status: LeaveStatus.approved,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    LeaveRequest(
      id: "LV-002",
      studentId: "ST-102",
      studentName: "سارة العتيبي",
      studentGrade: "الصف الثاني - ب",
      date: DateTime.now().add(const Duration(days: 2)),
      startTime: "09:00 AM",
      reason: "مواكبة عائلية طارئة",
      status: LeaveStatus.pending,
      createdAt: DateTime.now(),
    ),
    LeaveRequest(
      id: "LV-003",
      studentId: "ST-101",
      studentName: "أحمد بن محمد",
      studentGrade: "الصف الرابع - أ",
      date: DateTime.now().subtract(const Duration(days: 5)),
      startTime: "11:00 AM",
      endTime: "01:00 PM",
      reason: "ظرف عائلي",
      status: LeaveStatus.rejected,
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
  ];

  Future<List<LeaveRequest>> getLeavesForStudent(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _dummyLeaves.where((l) => l.studentId == studentId).toList();
  }

  Future<List<LeaveRequest>> getAllLeaves() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return List.from(_dummyLeaves);
  }

  Future<void> updateLeaveStatus(String leaveId, LeaveStatus status) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _dummyLeaves.indexWhere((l) => l.id == leaveId);
    if (index != -1) {
      _dummyLeaves[index] = _dummyLeaves[index].copyWith(status: status);
    }
  }

  Future<void> placeLeaveRequest(LeaveRequest request) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _dummyLeaves.add(request);
  }
}
