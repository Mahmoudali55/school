import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:my_template/core/network/api_consumer.dart';
import 'package:my_template/core/network/end_points.dart';
import 'package:my_template/core/network/handle_dio_request.dart';
import 'package:my_template/features/auth/data/model/registration_response_model.dart';
import 'package:my_template/features/auth/data/model/user_login_model.dart';

import '../../../../core/error/failures.dart' hide handleDioRequest;
import '../model/admission_request_model.dart';
import '../model/nationality_model.dart';
import '../model/registration_model.dart';
import '../model/religion_model.dart';
import '../model/section_model.dart';

abstract interface class AuthRepo {
  Future<Either<Failure, RegistrationResponse>> register({
    required String username,
    required String nationalId,
    required String password,
    required String email,
  });
  Future<Either<Failure, UserLoginModel>> login({
    required String username,
    required String password,
  });
  Future<Either<Failure, dynamic>> submitAdmissionRequest({
    required AdmissionRequestModel admissionRequestModel,
  });
  Future<Either<Failure, List<ReligionModel>>> getReligionCodes();
  Future<Either<Failure, List<NationalityModel>>> getNationalityCodes();
  Future<Either<Failure, List<SectionModel>>> getSections();
}

class AuthRepoImpl implements AuthRepo {
  final ApiConsumer apiConsumer;
  AuthRepoImpl(this.apiConsumer);

  @override
  Future<Either<Failure, RegistrationResponse>> register({
    required String username,
    required String nationalId,
    required String password,
    required String email,
  }) {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.post(
          EndPoints.register,
          body: RegistrationModel(
            UserName: username,
            email: email,
            iDNO: nationalId,
            password: password,
          ).toJson(),
        );
        return RegistrationResponse.fromJson(response);
      },
    );
  }

  @override
  Future<Either<Failure, UserLoginModel>> login({
    required String username,
    required String password,
  }) {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.post(
          EndPoints.login,
          body: {"grant_type": "password", "username": username, "password": password},
        );
        return UserLoginModel.fromJson(response);
      },
    );
  }

  @override
  Future<Either<Failure, dynamic>> submitAdmissionRequest({
    required AdmissionRequestModel admissionRequestModel,
  }) {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.post(
          EndPoints.admissionRequest,
          body: admissionRequestModel.toJson(),
        );
        return response;
      },
    );
  }

  @override
  Future<Either<Failure, List<ReligionModel>>> getReligionCodes() {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.get(
          EndPoints.getReligionCodes,
          extra: {'skipAuth': true},
        );
        final List data = response['Data'] is String
            ? (jsonDecode(response['Data']) as List)
            : (response['Data'] as List);
        return data.map((e) => ReligionModel.fromJson(e)).toList();
      },
    );
  }

  @override
  Future<Either<Failure, List<NationalityModel>>> getNationalityCodes() {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.get(
          EndPoints.getNationalityCodes,
          extra: {'skipAuth': true},
        );
        final List data = response['Data'] is String
            ? (jsonDecode(response['Data']) as List)
            : (response['Data'] as List);
        return data.map((e) => NationalityModel.fromJson(e)).toList();
      },
    );
  }

  @override
  Future<Either<Failure, List<SectionModel>>> getSections() {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.get(
          EndPoints.getSections,
          extra: {'skipAuth': true},
          queryParameters: {"SearchVal": null},
        );
        final List data = response['Data'] is String
            ? (jsonDecode(response['Data']) as List)
            : (response['Data'] as List);
        return data.map((e) => SectionModel.fromJson(e)).toList();
      },
    );
  }
}
