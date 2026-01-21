// lib/core/network/error_handler.dart

import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../network/status_code.dart';

/// Base class for all failures, holds an error message.
abstract class Failure {
  final String errMessage;
  const Failure(this.errMessage);
}

/// Represents a failure coming from Dio / the server.
class ServerFailure extends Failure {
  ServerFailure(super.errMessage);

  /// Map Dio exceptions to our ServerFailure, extracting server‑side messages when present.
  factory ServerFailure.fromDioError(DioException dioError) {
    try {
      // Attempt to parse raw response data into a Map<String, dynamic>
      final raw = dioError.response?.data;
      Map<String, dynamic>? map;
      if (raw != null) {
        if (raw is Map<String, dynamic>) {
          map = raw;
        } else if (raw is String) {
          try {
            map = jsonDecode(raw) as Map<String, dynamic>;
          } catch (_) {
            map = null;
          }
        }
      }

      // If we got a JSON map with a "message" or "Message" field, return it immediately
      if (map != null) {
        if (map['message'] is String) return ServerFailure(map['message'] as String);
        if (map['Message'] is String) return ServerFailure(map['Message'] as String);
        if (map['error'] is String) return ServerFailure(map['error'] as String);
        if (map['error_description'] is String)
          return ServerFailure(map['error_description'] as String);
      }

      // Otherwise fall back based on DioException type
      switch (dioError.type) {
        case DioExceptionType.connectionTimeout:
          return ServerFailure('Connection timeout with API server');
        case DioExceptionType.sendTimeout:
          return ServerFailure('Send timeout with API server');
        case DioExceptionType.receiveTimeout:
          return ServerFailure('Receive timeout with API server');
        case DioExceptionType.cancel:
          return ServerFailure('Request to API server was cancelled');
        case DioExceptionType.connectionError:
          return ServerFailure('No internet connection');
        case DioExceptionType.unknown:
          return ServerFailure('Unexpected error, please try again!');
        case DioExceptionType.badResponse:
          return ServerFailure.fromResponse(dioError.response?.statusCode, map ?? raw);
        default:
          return ServerFailure('Oops! There was an error, please try again.');
      }
    } catch (e, stack) {
      log('ServerFailure.fromDioError error: $e\n$stack');
      return ServerFailure('An unknown error occurred');
    }
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    try {
      if (response is Map<String, dynamic>) {
        if (response['message'] is String) return ServerFailure(response['message'] as String);
        if (response['Message'] is String) return ServerFailure(response['Message'] as String);
        if (response['error'] is String) return ServerFailure(response['error'] as String);
        if (response['error_description'] is String)
          return ServerFailure(response['error_description'] as String);
      }

      switch (statusCode) {
        case StatusCode.badRequest:
        case StatusCode.unauthorized:
        case StatusCode.forbidden:
          return ServerFailure('Invalid request, please check your input');
        case StatusCode.notFound:
          return ServerFailure('Requested resource not found');
        case StatusCode.internalServerError:
          return ServerFailure('Internal server error, please try later');
        default:
          return ServerFailure('Request failed with status $statusCode');
      }
    } catch (e) {
      return ServerFailure('Failed to parse server response');
    }
  }
}

/// Executes any Dio request and returns either the parsed data or a Failure.
Future<Either<Failure, T>> handleDioRequest<T>({required Future<T> Function() request}) async {
  try {
    final response = await request();
    return Right(response);
  } on DioException catch (e) {
    // Debug logs
    log('[DioException] ➜ ${e.message}');
    if (e.response?.data != null) {
      final serverMsg = _extractServerMessage(e.response!.data);
      log('[Server message] ➜ $serverMsg');
    }
    return Left(ServerFailure.fromDioError(e));
  } catch (e, stack) {
    log('[Unknown Error] ➜ $e');
    log('[StackTrace] ➜ $stack');
    return Left(ServerFailure(e.toString()));
  }
}

String? _extractServerMessage(dynamic rawData) {
  try {
    if (rawData is Map<String, dynamic>) {
      if (rawData['message'] is String) return rawData['message'] as String;
      if (rawData['Message'] is String) return rawData['Message'] as String;
      // Also handle "error" field often returned by OAuth servers
      if (rawData['error'] is String) return rawData['error'] as String;
      // Some servers might return "error_description"
      if (rawData['error_description'] is String) return rawData['error_description'] as String;
    }
    if (rawData is String) {
      final decoded = jsonDecode(rawData);
      if (decoded is Map<String, dynamic>) {
        if (decoded['message'] is String) return decoded['message'] as String;
        if (decoded['Message'] is String) return decoded['Message'] as String;
        if (decoded['error'] is String) return decoded['error'] as String;
        if (decoded['error_description'] is String) return decoded['error_description'] as String;
      }
    }
  } catch (_) {}
  return null;
}
