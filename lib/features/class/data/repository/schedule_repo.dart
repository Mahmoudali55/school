import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_template/core/error/failures.dart';
import 'package:my_template/core/network/api_consumer.dart';
import 'package:my_template/core/network/end_points.dart';
import 'package:my_template/features/class/data/model/add_timetable_request_model.dart';
import 'package:my_template/features/class/data/model/add_timetable_response_model.dart';
import 'package:my_template/features/class/data/model/get_timetable_response_model.dart';
import 'package:my_template/features/class/data/model/schedule_model.dart';

abstract interface class ScheduleRepo {
  Future<Either<Failure, List<ScheduleModel>>> getSchedule({required int classCode});
  Future<Either<Failure, AddTimetableResponseModel>> saveSchedule({
    required int classCode,
    required List<ScheduleModel> schedule,
  });
  Future<Either<Failure, List<ScheduleModel>>> getScheduleFromApi({required int classCode});
}

class ScheduleRepoImpl implements ScheduleRepo {
  final Box appBox;
  final ApiConsumer apiConsumer;

  ScheduleRepoImpl({required this.appBox, required this.apiConsumer});

  // ─── Local cache read (Hive) ────────────────────────────────────────────────
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

  // ─── Remote GET ─────────────────────────────────────────────────────────────
  @override
  Future<Either<Failure, List<ScheduleModel>>> getScheduleFromApi({required int classCode}) async {
    try {
      final response = await apiConsumer.get(
        EndPoints.getSchoolTimeTable,
        queryParameters: {'ClassCode': classCode},
      );
      final result = GetTimetableResponseModel.fromJson(response);
      return Right(result.data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ─── Remote POST (one row per entry) ────────────────────────────────────────
  @override
  Future<Either<Failure, AddTimetableResponseModel>> saveSchedule({
    required int classCode,
    required List<ScheduleModel> schedule,
  }) async {
    try {
      final body = {
        "classCode": classCode,
        "School_Time_table": schedule
            .map(
              (e) => AddTimetableRequestModel.fromScheduleModel(
                model: e,
                classCode: classCode,
              ).toJson(),
            )
            .toList(),
      };

      final response = await apiConsumer.post(EndPoints.addSchoolTimeTable, body: body);

      final result = AddTimetableResponseModel.fromJson(response);

      if (!result.success) {
        return Left(ServerFailure(result.msg));
      }

      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
