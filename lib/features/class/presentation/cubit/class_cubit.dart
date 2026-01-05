import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/class/data/model/class_models.dart';
import 'package:my_template/features/class/data/repository/class_repo.dart';

import 'class_state.dart';

class ClassCubit extends Cubit<ClassState> {
  final ClassRepo _classRepo;

  ClassCubit(this._classRepo) : super(ClassInitial());

  Future<void> getClassData(String userTypeId) async {
    if (state is! ClassLoaded) {
      emit(ClassLoading());
    }
    try {
      List<ClassModel> data;
      if (userTypeId == 'student') {
        data = await _classRepo.getStudentClasses();
      } else if (userTypeId == 'teacher') {
        data = await _classRepo.getTeacherClasses();
      } else if (userTypeId == 'admin') {
        data = await _classRepo.getAdminClasses();
      } else if (userTypeId == 'parent') {
        data = await _classRepo.getParentStudentClasses();
      } else {
        emit(const ClassError("Unknown user type"));
        return;
      }
      emit(ClassLoaded(data));
    } catch (e) {
      emit(ClassError(e.toString()));
    }
  }
}
