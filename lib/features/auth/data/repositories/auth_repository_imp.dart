import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nawah/core/erros/failures.dart';
import 'package:nawah/core/network/dio_exception.dart';
import 'package:nawah/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:nawah/features/auth/data/datasource/local_remote_data_source.dart';
import 'package:nawah/features/auth/data/model/requests/forget_password_request_model.dart';
import 'package:nawah/features/auth/data/model/requests/login_request_model.dart';
import 'package:nawah/features/auth/data/model/requests/register_request_model.dart';
import 'package:nawah/features/auth/data/model/requests/resend_code_request_model.dart';
import 'package:nawah/features/auth/data/model/requests/reset_password_request_model.dart';
import 'package:nawah/features/auth/data/model/requests/verify_otp_request_model.dart';
import 'package:nawah/features/auth/data/model/requests/update_profile_request_model.dart';
import 'package:nawah/features/auth/data/model/responses/login_response_model.dart';
import 'package:nawah/features/auth/data/model/responses/register_response_model.dart';
import 'package:nawah/features/auth/data/model/shared/auth_response_model.dart';
import 'package:nawah/features/auth/data/model/shared/user_model.dart';
import 'package:nawah/features/auth/presentation/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.localDataSource,
  });
  @override
  Future<Either<Failure, RegisterModel>> register(
    RegisterRequestModel params,
  ) async {
    try {
      final response = await authRemoteDataSource.registerUser(params);

      return Right(response);
    } on DioException catch (dioError) {
      return Left(handleDioException(dioError));
    } catch (error) {
      return Left(ServerFailure('Failed to register user: $error'));
    }
  }

  @override
  Future<Either<Failure, LoginModel>> login(LoginRequestModel params) async {
    try {
      final response = await authRemoteDataSource.loginUser(params);

      return Right(response);
    } on DioException catch (dioError) {
      return Left(handleDioException(dioError));
    } catch (error) {
      return Left(ServerFailure('Failed to login user: $error'));
    }
  }

  @override
  Future<Either<Failure, void>> clearUserData() async {
    try {
      await localDataSource.deleteSavedUser();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getSavedUserData() async {
    try {
      final user = await localDataSource.getSavedUser();

      if (user == null) {
        return const Left(CacheFailure(" There is No Saved User "));
      }
      return Right(user);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginModel>> refreshTokenLogin() async {
    try {
      final response = await authRemoteDataSource.refreshTokenLogin();

      return Right(response);
    } on DioException catch (dioError) {
      return Left(handleDioException(dioError));
    } catch (error) {
      return Left(ServerFailure('Failed to refreshTokenLogin: $error'));
    }
  }

  @override
  Future<Either<Failure, void>> saveUserData(UserModel user) async {
    try {
      await localDataSource.saveUser(user);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginModel>> forgotPassword(
    ForgetPasswordRequestModel params,
  ) async {
    try {
      final response = await authRemoteDataSource.forgotPassword(params);

      return Right(response);
    } on DioException catch (dioError) {
      return Left(handleDioException(dioError));
    } catch (error) {
      return Left(ServerFailure('Failed to forgotPassword: $error'));
    }
  }

  @override
  Future<Either<Failure, LoginModel>> resendCode(
    ResendCodeRequestModel params,
  ) async {
    try {
      final response = await authRemoteDataSource.resendCode(params);

      return Right(response);
    } on DioException catch (dioError) {
      return Left(handleDioException(dioError));
    } catch (error) {
      return Left(ServerFailure('Failed to resendCode: $error'));
    }
  }

  @override
  Future<Either<Failure, LoginModel>> resetPassword(
    ResetPasswordRequestModel params,
  ) async {
    try {
      final response = await authRemoteDataSource.resetPassword(params);

      return Right(response);
    } on DioException catch (dioError) {
      return Left(handleDioException(dioError));
    } catch (error) {
      return Left(ServerFailure('Failed to resetPassword: $error'));
    }
  }

  @override
  Future<Either<Failure, LoginModel>> verifyOtpForRegistration(
    VerifyOtpRequestModel params,
  ) async {
    try {
      final response = await authRemoteDataSource.verifyOtpForRegistration(
        params,
      );

      return Right(response);
    } on DioException catch (dioError) {
      return Left(handleDioException(dioError));
    } catch (error) {
      return Left(ServerFailure('Failed to verifyOtpForRegistration: $error'));
    }
  }

  @override
  Future<Either<Failure, LoginModel>> verifyOtpForPasswordReset(
    VerifyOtpRequestModel params,
  ) async {
    try {
      final response = await authRemoteDataSource.verifyOtpForPasswordReset(
        params,
      );

      return Right(response);
    } on DioException catch (dioError) {
      return Left(handleDioException(dioError));
    } catch (error) {
      return Left(ServerFailure('Failed to verifyOtpForPasswordReset: $error'));
    }
  }

  @override
  Future<Either<Failure, LoginModel>> logout() async {
    try {
      final response = await authRemoteDataSource.logout();

      return Right(response);
    } on DioException catch (dioError) {
      return Left(handleDioException(dioError));
    } catch (error) {
      return Left(ServerFailure('Failed to verifyOtpForPasswordReset: $error'));
    }
  }

  @override
  Future<Either<Failure, LoginModel>> updateProfile(
    UpdateProfileRequestModel params,
  ) async {
    try {
      final response = await authRemoteDataSource.updateProfile(params);

      return Right(response);
    } on DioException catch (dioError) {
      return Left(handleDioException(dioError));
    } catch (error) {
      return Left(ServerFailure('Failed to updateProfile: $error'));
    }
  }
}
