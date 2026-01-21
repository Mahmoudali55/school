import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/pickup_model.dart';
import '../../data/repo/pickup_repo.dart';
import 'pickup_state.dart';

class PickUpCubit extends Cubit<PickUpState> {
  final PickUpRepo _repo;
  PickUpCubit(this._repo) : super(PickUpInitial());

  Future<void> getPickUpRequests() async {
    emit(PickUpLoading());
    try {
      final requests = await _repo.getPickUpRequests();
      emit(PickUpLoaded(requests));
    } catch (e) {
      emit(PickUpError(e.toString()));
    }
  }

  Future<void> sendPickUpSignal(PickUpRequest request) async {
    emit(PickUpLoading());
    try {
      await _repo.sendPickUpSignal(request);
      emit(PickUpSignalSent());
      // Re-load if needed or stay in signal sent state for success UI
    } catch (e) {
      emit(PickUpError(e.toString()));
    }
  }

  Future<void> updatePickUpStatus(String requestId, PickUpStatus status) async {
    try {
      await _repo.updatePickUpStatus(requestId, status);
      await getPickUpRequests(); // Refresh list after update
    } catch (e) {
      emit(PickUpError(e.toString()));
    }
  }
}
