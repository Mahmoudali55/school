import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/bus/data/model/bus_tracking_models.dart';
import 'package:my_template/features/bus/data/repo/bus_repo.dart';

import 'bus_state.dart';

class BusCubit extends Cubit<BusState> {
  final BusRepo _busRepo;
  Timer? _updateTimer;

  BusCubit(this._busRepo) : super(const BusState());

  Future<void> getBusData(String userTypeId) async {
    if (state.classes.isEmpty && state.studentsOnBus.isEmpty) {
      emit(state.copyWith(isLoading: true));
    }
    try {
      final classes = await _busRepo.getBusClasses(userTypeId);
      final studentsOnBus = await _busRepo.getStudentsOnBus(userTypeId);
      final fieldTrips = await _busRepo.getFieldTrips(userTypeId);
      final buses = await _busRepo.getAdminBuses(userTypeId);
      final parentChildrenBuses = await _busRepo.getParentChildrenBuses(userTypeId);
      final overviewStats = _busRepo.getOverviewStats(userTypeId);

      emit(
        state.copyWith(
          classes: classes,
          studentsOnBus: studentsOnBus,
          fieldTrips: fieldTrips,
          buses: buses,
          parentChildrenBuses: parentChildrenBuses,
          overviewStats: overviewStats,
          selectedClass:
              state.selectedClass ??
              (classes.isNotEmpty
                  ? classes.first
                  : (parentChildrenBuses.isNotEmpty ? parentChildrenBuses.first : null)),
          selectedAdminBus: state.selectedAdminBus ?? (buses.isNotEmpty ? buses.first : null),
          isLoading: false,
        ),
      );
      _startPeriodicUpdates();
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void selectClass(String classId) {
    BusClass? selected;
    if (state.classes.any((c) => c.id == classId)) {
      selected = state.classes.firstWhere((c) => c.id == classId);
    } else if (state.parentChildrenBuses.any((c) => c.id == classId)) {
      selected = state.parentChildrenBuses.firstWhere((c) => c.id == classId);
    }

    if (selected != null) {
      emit(state.copyWith(selectedClass: selected));
    }
  }

  void selectAdminBus(String busNumber) {
    if (state.buses.any((b) => b.busNumber == busNumber)) {
      final selected = state.buses.firstWhere((b) => b.busNumber == busNumber);
      emit(state.copyWith(selectedAdminBus: selected));
    }
  }

  void updateStudentStatus(String studentId, String newStatus) {
    final updatedStudents = state.studentsOnBus.map((student) {
      if (student.id == studentId) {
        return student.copyWith(status: newStatus);
      }
      return student;
    }).toList();
    emit(state.copyWith(studentsOnBus: updatedStudents));
  }

  void takeAttendance() {
    final updatedStudents = state.studentsOnBus.map((student) {
      if (student.status == 'في الحافلة') {
        return student.copyWith(attendance: 'حاضر');
      }
      return student;
    }).toList();

    emit(state.copyWith(studentsOnBus: updatedStudents));
  }

  void addFieldTrip(FieldTrip newTrip) {
    final updatedTrips = List<FieldTrip>.from(state.fieldTrips)..add(newTrip);
    emit(state.copyWith(fieldTrips: updatedTrips));
  }

  void updateBusLocation(String busId, String newLocation) {
    final updatedClasses = state.classes.map((busClass) {
      if (busClass.id == busId) {
        return busClass.copyWith(currentLocation: newLocation);
      }
      return busClass;
    }).toList();

    emit(state.copyWith(classes: updatedClasses));
  }

  void _startPeriodicUpdates() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (state.classes.isNotEmpty) {
        final randomClass = state.classes[DateTime.now().second % state.classes.length];
        final newLocation = _getRandomLocation();
        updateBusLocation(randomClass.id, newLocation);
      }
    });
  }

  String _getRandomLocation() {
    final locations = [
      'شارع الملك فهد',
      'حي السلام',
      'حي الروضة',
      'وسط المدينة',
      'الطريق الدائري',
      'حي النخيل',
    ];
    return locations[DateTime.now().second % locations.length];
  }

  @override
  Future<void> close() {
    _updateTimer?.cancel();
    return super.close();
  }
}
