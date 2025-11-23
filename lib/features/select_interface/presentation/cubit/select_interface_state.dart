import 'package:equatable/equatable.dart';
import 'package:my_template/features/select_interface/data/model/user_type_model.dart';

class InterfaceState extends Equatable {
  final UserTypeModel? selectedUser;

  const InterfaceState({this.selectedUser});

  InterfaceState copyWith({UserTypeModel? selectedUser}) {
    return InterfaceState(
      selectedUser: selectedUser ?? this.selectedUser,
    );
  }

  @override
  List<Object?> get props => [selectedUser ?? ''];
}
