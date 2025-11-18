import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:my_template/core/error/failures.dart';

Future<Either<Failure, T>> handleDioRequest<T>({
  required Future<T> Function() request,
  String? message,
}) async {
  try {
    final response = await request();
    return Right(response);
  } on DioException catch (e) {
    // Optional: log the Dio error
    log('[DioException] ➜ ${e.message}');
    log(e.response?.data['message']);
    return Left(ServerFailure.fromDioError(e));
  } catch (e, stack) {
    // Optional: log unknown errors
    log('[Unknown Error] ➜ $e');
    log('[StackTrace] ➜ $stack');

    return Left(ServerFailure(e.toString()));
  }
}
