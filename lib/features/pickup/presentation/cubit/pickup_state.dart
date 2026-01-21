import '../../data/model/pickup_model.dart';

abstract class PickUpState {}

class PickUpInitial extends PickUpState {}

class PickUpLoading extends PickUpState {}

class PickUpLoaded extends PickUpState {
  final List<PickUpRequest> requests;
  PickUpLoaded(this.requests);
}

class PickUpSignalSent extends PickUpState {}

class PickUpError extends PickUpState {
  final String message;
  PickUpError(this.message);
}
