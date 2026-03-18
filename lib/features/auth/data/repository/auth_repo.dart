import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:my_template/core/network/api_consumer.dart';
import 'package:my_template/core/network/end_points.dart';
import 'package:my_template/core/network/handle_dio_request.dart';
import 'package:my_template/features/auth/data/model/edit_fCM_request_model.dart';
import 'package:my_template/features/auth/data/model/edit_fCM_response_model.dart';
import 'package:my_template/features/auth/data/model/registration_response_model.dart';
import 'package:my_template/features/auth/data/model/user_login_model.dart';

import '../../../../core/error/failures.dart' hide handleDioRequest;
import '../model/admission_request_model.dart';
import '../model/level_model.dart';
import '../model/nationality_model.dart';
import '../model/parent_registration_model.dart';
import '../model/registration_model.dart';
import '../model/religion_model.dart';
import '../model/section_model.dart';
import '../model/stage_model.dart';

abstract interface class AuthRepo {
  Future<Either<Failure, RegistrationResponse>> register({
    required String username,
    required String nationalId,
    required String password,
    required String email,
    String? fcmToken,
  });
  Future<Either<Failure, UserLoginModel>> login({
    required String username,
    required String password,
    String? fcmToken,
  });
  Future<Either<Failure, EditFCMResponseModel>> editFCM({required EditFCMModel editFCMModel});
  Future<Either<Failure, dynamic>> submitAdmissionRequest({
    required AdmissionRequestModel admissionRequestModel,
  });
  Future<Either<Failure, List<ReligionModel>>> getReligionCodes();
  Future<Either<Failure, List<NationalityModel>>> getNationalityCodes();
  Future<Either<Failure, List<SectionModel>>> getSections();
  Future<Either<Failure, List<StageModel>>> getStages(int sectionCode);
  Future<Either<Failure, List<LevelModel>>> getLevels(int sectionCode, int stageCode);
  Future<Either<Failure, dynamic>> registerParent({
    required ParentRegistrationModel parentRegistrationModel,
  });
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
    String? fcmToken,
  }) {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.post(
          EndPoints.register,
          body: RegistrationModel(
            userName: username,
            email: email,
            idNo: nationalId,
            password: password,
            fcm: fcmToken,
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
    String? fcmToken,
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

  @override
  Future<Either<Failure, List<StageModel>>> getStages(int sectionCode) {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.get(
          EndPoints.getStages,
          extra: {'skipAuth': true},
          queryParameters: {"sectioncode": sectionCode},
        );
        final List data = response['Data'] is String
            ? (jsonDecode(response['Data']) as List)
            : (response['Data'] as List);
        return data.map((e) => StageModel.fromJson(e)).toList();
      },
    );
  }

  @override
  Future<Either<Failure, List<LevelModel>>> getLevels(int sectionCode, int stageCode) {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.get(
          EndPoints.getLevels,
          extra: {'skipAuth': true},
          queryParameters: {"sectioncode": sectionCode, "stagecode": stageCode},
        );
        final List data = response['Data'] is String
            ? (jsonDecode(response['Data']) as List)
            : (response['Data'] as List);
        return data.map((e) => LevelModel.fromJson(e)).toList();
      },
    );
  }

  @override
  Future<Either<Failure, dynamic>> registerParent({
    required ParentRegistrationModel parentRegistrationModel,
  }) {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.post(
          EndPoints.addRegistrationParents,
          body: parentRegistrationModel.toJson(),
          extra: {'skipAuth': true},
        );
        return response;
      },
    );
  }

  Future<Either<Failure, EditFCMResponseModel>> editFCM({required EditFCMModel editFCMModel}) {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.put(EndPoints.editFCM, body: editFCMModel.toJson());
        return EditFCMResponseModel.fromJson(response);
      },
    );
  }
}
