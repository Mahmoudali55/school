import 'package:equatable/equatable.dart';
import 'package:my_template/features/bus/data/model/admin_bus_model.dart';
import 'package:my_template/features/bus/data/model/bus_tracking_models.dart';

class BusState extends Equatable {
  final BusClass? selectedClass;
  final BusModel? selectedAdminBus;
  final List<BusClass> classes;
  final List<StudentOnBus> studentsOnBus;
  final List<FieldTrip> fieldTrips;
  final List<BusModel> buses;
  final List<BusClass> parentChildrenBuses;
  final bool isLoading;
  final String? error;
  final Map<String, dynamic> overviewStats;

  const BusState({
    this.selectedClass,
    this.selectedAdminBus,
    this.classes = const [],
    this.studentsOnBus = const [],
    this.fieldTrips = const [],
    this.buses = const [],
    this.parentChildrenBuses = const [],
    this.isLoading = false,
    this.error,
    this.overviewStats = const {},
  });

  BusState copyWith({
    BusClass? selectedClass,
    BusModel? selectedAdminBus,
    List<BusClass>? classes,
    List<StudentOnBus>? studentsOnBus,
    List<FieldTrip>? fieldTrips,
    List<BusModel>? buses,
    List<BusClass>? parentChildrenBuses,
    bool? isLoading,
    String? error,
    Map<String, dynamic>? overviewStats,
  }) {
    return BusState(
      selectedClass: selectedClass ?? this.selectedClass,
      selectedAdminBus: selectedAdminBus ?? this.selectedAdminBus,
      classes: classes ?? this.classes,
      studentsOnBus: studentsOnBus ?? this.studentsOnBus,
      fieldTrips: fieldTrips ?? this.fieldTrips,
      buses: buses ?? this.buses,
      parentChildrenBuses: parentChildrenBuses ?? this.parentChildrenBuses,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      overviewStats: overviewStats ?? this.overviewStats,
    );
  }

  @override
  List<Object?> get props => [
    selectedClass,
    selectedAdminBus,
    classes,
    studentsOnBus,
    fieldTrips,
    buses,
    parentChildrenBuses,
    isLoading,
    error,
    overviewStats,
  ];
}
