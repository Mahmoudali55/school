import 'package:dio/dio.dart';

import 'package:my_template/core/cache/hive/hive_methods.dart';

import '../utils/common_methods.dart';

class AppInterceptors extends Interceptor {
  AppInterceptors();
  static bool isInternet = true;
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    isInternet = true;

    options.headers['Content-Type'] = 'application/x-www-form-urlencoded';

    final lang = HiveMethods.getLang();
    options.headers['lang'] = lang == 'en' ? 'en-GB' : lang;

    // Check internet connectivity before sending request
    if (!await CommonMethods.hasConnection()) {
      isInternet = false;
      return handler.reject(
        DioException(
          requestOptions: options,
          error: 'No Internet Connection',
          type: DioExceptionType.connectionError,
        ),
      );
    }

    super.onRequest(options, handler);
  }
}
