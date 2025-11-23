import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/select_interface/data/model/user_type_model.dart';
import 'package:my_template/features/select_interface/data/repo/user_type_repo.dart';
import 'package:my_template/features/select_interface/presentation/cubit/select_interface_state.dart';

class InterfaceCubit extends Cubit<InterfaceState> {
  final InterfaceRepository repository;

  InterfaceCubit({required this.repository}) : super(const InterfaceState());

  List<UserTypeModel> get userTypes => repository.getUserTypes();

  void selectUser(UserTypeModel user) {
    emit(state.copyWith(selectedUser: user));
  }

  void clearSelection() {
    emit(state.copyWith(selectedUser: null));
  }
}
