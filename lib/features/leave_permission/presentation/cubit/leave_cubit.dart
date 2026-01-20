import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/leave_model.dart';
import '../../data/repo/leave_repo.dart';
import 'leave_state.dart';

class LeaveCubit extends Cubit<LeaveState> {
  final LeaveRepo _repo;
  LeaveCubit(this._repo) : super(LeaveInitial());

  Future<void> fetchStudentLeaves(String studentId) async {
    emit(LeaveLoading());
    try {
      final leaves = await _repo.getLeavesForStudent(studentId);
      emit(LeaveLoaded(leaves));
    } catch (e) {
      emit(LeaveError(e.toString()));
    }
  }

  Future<void> fetchAllLeaves() async {
    emit(LeaveLoading());
    try {
      final leaves = await _repo.getAllLeaves();
      emit(LeaveLoaded(leaves));
    } catch (e) {
      emit(LeaveError(e.toString()));
    }
  }

  Future<void> placeLeaveRequest(LeaveRequest request) async {
    emit(LeaveLoading());
    try {
      await _repo.placeLeaveRequest(request);
      final leaves = await _repo.getLeavesForStudent(request.studentId);
      emit(LeaveLoaded(leaves));
    } catch (e) {
      emit(LeaveError(e.toString()));
    }
  }

  Future<void> updateLeaveStatus(String leaveId, LeaveStatus status) async {
    try {
      await _repo.updateLeaveStatus(leaveId, status);
      await fetchAllLeaves();
    } catch (e) {
      emit(LeaveError(e.toString()));
    }
  }
}
