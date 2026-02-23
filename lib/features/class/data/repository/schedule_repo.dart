import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_template/core/error/failures.dart';
import 'package:my_template/core/network/api_consumer.dart';
import 'package:my_template/core/network/end_points.dart';
import 'package:my_template/features/class/data/model/add_timetable_request_model.dart';
import 'package:my_template/features/class/data/model/add_timetable_response_model.dart';
import 'package:my_template/features/class/data/model/schedule_model.dart';

abstract interface class ScheduleRepo {
  Future<Either<Failure, List<ScheduleModel>>> getSchedule({required int classCode});
  Future<Either<Failure, AddTimetableResponseModel>> saveSchedule({
    required int classCode,
    required List<ScheduleModel> schedule,
  });
}

class ScheduleRepoImpl implements ScheduleRepo {
  final Box appBox;
  final ApiConsumer apiConsumer;

  ScheduleRepoImpl({required this.appBox, required this.apiConsumer});

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
  Future<Either<Failure, AddTimetableResponseModel>> saveSchedule({
    required int classCode,
    required List<ScheduleModel> schedule,
  }) async {
    try {
      AddTimetableResponseModel? lastResponse;

      for (final item in schedule) {
        final request = AddTimetableRequestModel.fromScheduleModel(item);
        final response = await apiConsumer.post(
          EndPoints.addSchoolTimeTable,
          body: request.toJson(),
        );
        lastResponse = AddTimetableResponseModel.fromJson(response);

        // Stop immediately if any row fails
        if (!lastResponse.success) {
          return Left(ServerFailure(lastResponse.msg));
        }
      }

      // After successful API save, persist locally as cache
      final String scheduleStr = jsonEncode(schedule.map((e) => e.toJson()).toList());
      await appBox.put('schedule_$classCode', scheduleStr);

      return Right(
        lastResponse ??
            const AddTimetableResponseModel(success: true, id: 0, msg: 'تم الحفظ بنجاح'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
