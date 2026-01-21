import 'package:my_template/features/pickup/data/model/pickup_model.dart';

class PickUpRepo {
  final List<PickUpRequest> _dummyRequests = [
    PickUpRequest(
      id: "PU-001",
      studentId: "ST-101",
      studentName: "أحمد بن محمد",
      studentGrade: "الصف الرابع - أ",
      status: PickUpStatus.pending,
      requestTime: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    PickUpRequest(
      id: "PU-002",
      studentId: "ST-102",
      studentName: "سارة العتيبي",
      studentGrade: "الصف الثاني - ب",
      status: PickUpStatus.preparing,
      requestTime: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
  ];

  Future<List<PickUpRequest>> getPickUpRequests() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return List.from(_dummyRequests);
  }

  Future<void> sendPickUpSignal(PickUpRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _dummyRequests.add(request);
  }

  Future<void> updatePickUpStatus(String requestId, PickUpStatus status) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _dummyRequests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      _dummyRequests[index] = _dummyRequests[index].copyWith(status: status);
    }
  }
}
