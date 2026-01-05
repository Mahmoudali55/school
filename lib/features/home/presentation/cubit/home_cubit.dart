import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;

  HomeCubit(this._homeRepo) : super(HomeInitial());

  Future<void> getHomeData(String userTypeId) async {
    emit(HomeLoading());
    try {
      if (userTypeId == 'student') {
        final data = await _homeRepo.getStudentHomeData();
        emit(HomeLoaded(data));
      } else if (userTypeId == 'parent') {
        final data = await _homeRepo.getParentHomeData();
        emit(HomeLoaded(data));
      } else if (userTypeId == 'teacher') {
        final data = await _homeRepo.getTeacherHomeData();
        emit(HomeLoaded(data));
      } else if (userTypeId == 'admin') {
        final data = await _homeRepo.getAdminHomeData();
        emit(HomeLoaded(data));
      } else {
        emit(const HomeError("Invalid User Type"));
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
