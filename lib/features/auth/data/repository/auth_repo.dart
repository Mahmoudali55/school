import 'package:dartz/dartz.dart';
import 'package:my_template/core/network/api_consumer.dart';
import 'package:my_template/core/network/end_points.dart';
import 'package:my_template/core/network/handle_dio_request.dart';

import '../../../../core/error/failures.dart' hide handleDioRequest;
import '../model/user_model.dart';

abstract interface class AuthRepo {
  Future<Either<Failure, AuthResponseModel>> login({
    required String mobile,
    required String password,
    required bool rememberMe,
    required String accountType,
  });
}

class AuthRepoImpl implements AuthRepo {
  final ApiConsumer apiConsumer;
  AuthRepoImpl(this.apiConsumer);

  @override
  Future<Either<Failure, AuthResponseModel>> login({
    required String mobile,
    required String password,
    required bool rememberMe,
    required String accountType,
  }) {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.post(
          EndPoints.login,
          body: {
            'mobile': mobile,
            'password': password,
            'remember_me': rememberMe,
            'account_type': accountType,
          },
        );
        return AuthResponseModel.fromJson(response);
      },
    );
  }
}
