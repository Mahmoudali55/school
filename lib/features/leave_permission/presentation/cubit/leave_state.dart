import '../../data/model/leave_model.dart';

abstract class LeaveState {}

class LeaveInitial extends LeaveState {}

class LeaveLoading extends LeaveState {}

class LeaveLoaded extends LeaveState {
  final List<LeaveRequest> leaves;
  LeaveLoaded(this.leaves);
}

class LeaveError extends LeaveState {
  final String message;
  LeaveError(this.message);
}
