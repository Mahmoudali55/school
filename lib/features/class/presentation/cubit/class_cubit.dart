import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/class/data/repository/class_repo.dart';
import 'class_state.dart';

class ClassCubit extends Cubit<ClassState> {
  final ClassRepo _classRepo;

  ClassCubit(this._classRepo) : super(ClassInitial());

  Future<void> getClassData(String userTypeId) async {
    emit(ClassLoading());
    try {
      if (userTypeId == 'student') {
        final data = await _classRepo.getStudentClasses();
        emit(ClassLoaded(data));
      } else if (userTypeId == 'teacher') {
        final data = await _classRepo.getTeacherClasses();
        emit(ClassLoaded(data));
      } else if (userTypeId == 'admin') {
        final data = await _classRepo.getAdminClasses();
        emit(ClassLoaded(data));
      } else if (userTypeId == 'parent') {
        final data = await _classRepo.getParentStudentClasses();
        emit(ClassLoaded(data));
      } else {
        emit(const ClassError("Unknown user type"));
      }
    } catch (e) {
      emit(ClassError(e.toString()));
    }
  }
}
