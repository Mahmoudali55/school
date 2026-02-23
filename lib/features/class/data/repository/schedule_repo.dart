import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_template/core/error/failures.dart';
import 'package:my_template/features/class/data/model/schedule_model.dart';

abstract interface class ScheduleRepo {
  Future<Either<Failure, List<ScheduleModel>>> getSchedule({required int classCode});
  Future<Either<Failure, bool>> saveSchedule({
    required int classCode,
    required List<ScheduleModel> schedule,
  });
}

class ScheduleRepoImpl implements ScheduleRepo {
  final Box appBox;

  ScheduleRepoImpl({required this.appBox});

  @override
  Future<Either<Failure, List<ScheduleModel>>> getSchedule({required int classCode}) async {
    try {
      final String? scheduleStr = appBox.get('schedule_$classCode');
      if (scheduleStr != null && scheduleStr.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(scheduleStr);
        return Right(ScheduleModel.fromList(decoded));
      }
      return const Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> saveSchedule({
    required int classCode,
    required List<ScheduleModel> schedule,
  }) async {
    try {
      final String scheduleStr = jsonEncode(schedule.map((e) => e.toJson()).toList());
      await appBox.put('schedule_$classCode', scheduleStr);
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
