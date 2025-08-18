import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:nawah/core/network/custom_dio_interceptor.dart';
import 'package:nawah/core/services/secure_storage_service.dart';
import 'package:nawah/core/services/shared_pref_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  final SharedPrefService _prefs;
  final SecureStorageService _secureStorage;

  DioFactory(this._prefs, this._secureStorage);

  Future<Dio> createDio() async {
    final dio = Dio(
      BaseOptions(
        baseUrl: '',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'multipart/form-data',
          'Accept': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          requestHeader: true,
          responseHeader: true,
        ),
      );
    }

    dio.interceptors.add(CustomDioInterceptor(
      _secureStorage,
      _prefs,
    ));

    return dio;
  }
}

//    RetryInterceptor.currentRetryAction?.call();
