import 'package:dartz/dartz.dart';
import 'package:my_template/core/network/api_consumer.dart';
import 'package:my_template/core/network/end_points.dart';
import 'package:my_template/core/network/handle_dio_request.dart';
import 'package:my_template/features/auth/data/model/registration_response_model.dart';

import '../../../../core/error/failures.dart' hide handleDioRequest;
import '../model/registration_model.dart';

abstract interface class AuthRepo {
  Future<Either<Failure, RegistrationResponse>> register({
    required String username,
    required int nationalId,
    required String password,
    required String email,
  });
}

class AuthRepoImpl implements AuthRepo {
  final ApiConsumer apiConsumer;
  AuthRepoImpl(this.apiConsumer);

  @override
  Future<Either<Failure, RegistrationResponse>> register({
    required String username,
    required int nationalId,
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
}
