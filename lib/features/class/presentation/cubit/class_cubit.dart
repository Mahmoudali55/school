import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/class/data/repository/class_repo.dart';

import 'class_state.dart';

class ClassCubit extends Cubit<ClassState> {
  final ClassRepo _classRepo;

  ClassCubit(this._classRepo) : super(ClassInitial());

  Future<void> getClassData(String userTypeId) async {
    emit(state.copyWith(classesStatus: const StatusState.loading()));

    try {
      final List<dynamic> data;
      if (userTypeId == 'student') {
        data = await _classRepo.getStudentClasses();
      } else if (userTypeId == 'teacher') {
        data = await _classRepo.getTeacherClasses();
      } else if (userTypeId == 'admin') {
        data = await _classRepo.getAdminClasses();
      } else if (userTypeId == 'parent') {
        data = await _classRepo.getParentStudentClasses();
      } else {
        emit(state.copyWith(classesStatus: const StatusState.failure("Unknown user type")));
        return;
      }
      emit(state.copyWith(classesStatus: StatusState.success(data.cast())));
    } catch (e) {
      emit(state.copyWith(classesStatus: StatusState.failure(e.toString())));
    }
  }

  Future<void> getHomeWork({required int code, required String hwDate}) async {
    emit(state.copyWith(homeWorkStatus: const StatusState.loading()));

    final result = await _classRepo.getHomeWork(code: code, hwDate: hwDate);
    result.fold(
      (failure) => emit(state.copyWith(homeWorkStatus: StatusState.failure(failure.errMessage))),
      (homeWorkList) => emit(state.copyWith(homeWorkStatus: StatusState.success(homeWorkList))),
    );
  }
}
