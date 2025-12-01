import 'package:equatable/equatable.dart';
import 'package:my_template/features/bus/data/model/bus_tracking_models.dart';

class BusTrackingState extends Equatable {
  final BusClass? selectedClass;
  final List<BusClass> classes;
  final List<StudentOnBus> studentsOnBus;
  final List<FieldTrip> fieldTrips;
  final bool isLoading;
  final String? error;
  final Map<String, dynamic> overviewStats;

  const BusTrackingState({
    this.selectedClass,
    required this.classes,
    required this.studentsOnBus,
    required this.fieldTrips,
    this.isLoading = false,
    this.error,
    required this.overviewStats,
  });

  BusTrackingState copyWith({
    BusClass? selectedClass,
    List<BusClass>? classes,
    List<StudentOnBus>? studentsOnBus,
    List<FieldTrip>? fieldTrips,
    bool? isLoading,
    String? error,
    Map<String, dynamic>? overviewStats,
  }) {
    return BusTrackingState(
      selectedClass: selectedClass ?? this.selectedClass,
      classes: classes ?? this.classes,
      studentsOnBus: studentsOnBus ?? this.studentsOnBus,
      fieldTrips: fieldTrips ?? this.fieldTrips,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      overviewStats: overviewStats ?? this.overviewStats,
    );
  }

  @override
  List<Object?> get props => [
    selectedClass,
    classes,
    studentsOnBus,
    fieldTrips,
    isLoading,
    error,
    overviewStats,
  ];
}
