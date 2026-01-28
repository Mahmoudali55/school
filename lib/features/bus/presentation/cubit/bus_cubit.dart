import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/bus/data/model/bus_tracking_models.dart';
import 'package:my_template/features/bus/data/repo/bus_repo.dart';

import 'bus_state.dart';

class BusCubit extends Cubit<BusState> {
  final BusRepo _busRepo;
  Timer? _updateTimer;

  BusCubit(this._busRepo) : super(const BusState());

  Future<void> getBusData(String userTypeId, {int? code}) async {
    if (state.classes.isEmpty && state.studentsOnBus.isEmpty) {
      emit(state.copyWith(isLoading: true));
    }

    // Map numeric types to named types with robust normalization
    final cleanType = userTypeId.trim();
    String normalizedType;
    if (cleanType == '1' || cleanType == 'student') {
      normalizedType = 'student';
    } else if (cleanType == '2' || cleanType == 'parent') {
      normalizedType = 'parent';
    } else if (cleanType == '3' || cleanType == 'teacher') {
      normalizedType = 'teacher';
    } else {
      normalizedType = 'admin';
    }

    try {
      final classes = await _busRepo.getBusClasses(normalizedType);
      final studentsOnBus = await _busRepo.getStudentsOnBus(normalizedType);
      final fieldTrips = await _busRepo.getFieldTrips(normalizedType);
      final buses = await _busRepo.getAdminBuses(normalizedType);
      List<BusClass> parentChildrenBuses = [];
      if (normalizedType == 'parent' && code != null) {
        parentChildrenBuses = await _busRepo.getParentChildrenBuses(code: code);
      }
      final overviewStats = _busRepo.getOverviewStats(normalizedType);

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

  final List<Map<String, dynamic>> _routePoints = [
    {'name': 'المحطة 1', 'lat': 24.7136, 'lng': 46.6753},
    {'name': 'المحطة 2', 'lat': 24.7150, 'lng': 46.6780},
    {'name': 'المحطة 3', 'lat': 24.7180, 'lng': 46.6800},
    {'name': 'المحطة 4', 'lat': 24.7200, 'lng': 46.6850},
    {'name': 'المحطة 5', 'lat': 24.7250, 'lng': 46.6900},
  ];

  void updateBusLocation(String busId, double lat, double lng) {
    final updatedClasses = state.classes.map((busClass) {
      if (busClass.id == busId) {
        return busClass.copyWith(lat: lat, lng: lng);
      }
      return busClass;
    }).toList();
    // Also update parentChildrenBuses if the bus is in there
    final updatedParentBuses = state.parentChildrenBuses.map((busClass) {
      if (busClass.id == busId) {
        return busClass.copyWith(lat: lat, lng: lng);
      }
      return busClass;
    }).toList();

    BusClass? selectedClass = state.selectedClass;
    if (selectedClass != null && selectedClass.id == busId) {
      selectedClass = selectedClass.copyWith(lat: lat, lng: lng);
    }

    emit(
      state.copyWith(
        classes: updatedClasses,
        parentChildrenBuses: updatedParentBuses,
        selectedClass: selectedClass,
      ),
    );
  }

  void _startPeriodicUpdates() {
    _updateTimer?.cancel();
    int index = 0;
    _updateTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (state.classes.isNotEmpty || state.parentChildrenBuses.isNotEmpty) {
        final point = _routePoints[index % _routePoints.length];

        // Update both lists
        for (var bus in state.classes) {
          updateBusLocation(bus.id, point['lat'], point['lng']);
        }
        for (var bus in state.parentChildrenBuses) {
          updateBusLocation(bus.id, point['lat'], point['lng']);
        }
        index++;
      }
    });
  }

  Future<void> busLine(int code) async {
    emit(state.copyWith(busStatus: StatusState.loading()));

    final result = await _busRepo.getBusLines(code: code);
    result.fold(
      (error) => emit(state.copyWith(busStatus: StatusState.failure(error.errMessage))),
      (success) => emit(state.copyWith(busStatus: StatusState.success(success))),
    );
  }

  @override
  Future<void> close() {
    _updateTimer?.cancel();
    return super.close();
  }
}
