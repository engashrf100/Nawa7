import 'dart:io';
import 'package:dio/dio.dart';
import 'package:nawah/core/erros/failures.dart';
import 'package:nawah/features/auth/data/model/shared/validation_model.dart';

Failure handleDioException(Object error) {
  if (error is DioException) {
    final statusCode = error.response?.statusCode;
    final message =
        error.response?.data?['message'] ??
        error.response?.statusMessage ??
        "Unexpected server error";

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NoInternetFailure();

      case DioExceptionType.badResponse:
        if (statusCode != null) {
          if (statusCode == 422) {
            return ValidationFailure(
              ValidationErrors.fromJson(error.response?.data?['errors'] ?? {}),
            );
          } else if (statusCode == 401) {
            return UnauthenticatedFailure(
              "Unauthenticated: $message",
            ); // handle aunathoraized token key
          } else if (statusCode == 400) {
            return UnauthenticatedFailure(
              error.response?.data?['errors']['message'][0] ??
                  {}, // hadndle wrong credentials
            );
          } else if (statusCode == 403) {
            return ForbiddenFailure("Forbidden: $message");
          } else if (statusCode == 404) {
            return NotFoundFailure("Not found: $message");
          } else if (statusCode >= 500) {
            return ServerFailure("Server error: $message");
          }
        }
        return ServerFailure("[$statusCode] $message");

      case DioExceptionType.cancel:
        return UnexpectedFailure("Request was cancelled");

      default:
        return UnexpectedFailure("Unexpected Dio error: ${error.message}");
    }
  }
  if (error.toString().contains("HandshakeException")) {
    return ServerFailure(
      "TLS/SSL Handshake failed: possibly server misconfiguration.",
    );
  }
  if (error is SocketException) {
    return NoInternetFailure();
  }

  return UnexpectedFailure("Unexpected error: $error");
}
