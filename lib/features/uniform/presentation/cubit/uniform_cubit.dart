import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/uniform_model.dart';
import '../../data/repo/uniform_repo.dart';

abstract class UniformState {}

class UniformInitial extends UniformState {}

class UniformLoading extends UniformState {}

class UniformLoaded extends UniformState {
  final List<UniformOrder> orders;
  final List<SizeChart> sizeCharts;
  UniformLoaded({required this.orders, required this.sizeCharts});
}

class UniformError extends UniformState {
  final String message;
  UniformError(this.message);
}

class UniformCubit extends Cubit<UniformState> {
  final UniformRepo _repo;

  UniformCubit(this._repo) : super(UniformInitial());

  Future<void> loadParentData(String studentId) async {
    emit(UniformLoading());
    try {
      final orders = await _repo.getStudentOrders(studentId);
      final sizeCharts = await _repo.getSizeCharts();
      emit(UniformLoaded(orders: orders, sizeCharts: sizeCharts));
    } catch (e) {
      emit(UniformError(e.toString()));
    }
  }

  Future<void> loadAdminData() async {
    emit(UniformLoading());
    try {
      final orders = await _repo.getAllOrders();
      final sizeCharts = await _repo.getSizeCharts();
      emit(UniformLoaded(orders: orders, sizeCharts: sizeCharts));
    } catch (e) {
      emit(UniformError(e.toString()));
    }
  }

  Future<void> updateOrderStatus(String orderId, UniformOrderStatus newStatus) async {
    try {
      await _repo.updateOrderStatus(orderId, newStatus);
      await loadAdminData(); // Refresh list
    } catch (e) {
      emit(UniformError(e.toString()));
    }
  }

  Future<void> placeOrder(UniformOrder order) async {
    try {
      await _repo.placeOrder(order);
      await loadParentData(order.studentId); // Refresh list
    } catch (e) {
      emit(UniformError(e.toString()));
    }
  }
}
