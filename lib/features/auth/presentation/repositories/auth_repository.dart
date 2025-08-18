import 'package:dartz/dartz.dart';
import 'package:nawah/core/erros/failures.dart';
import 'package:nawah/features/auth/data/model/requests/forget_password_request_model.dart';
import 'package:nawah/features/auth/data/model/requests/login_request_model.dart';
import 'package:nawah/features/auth/data/model/requests/register_request_model.dart';
import 'package:nawah/features/auth/data/model/requests/resend_code_request_model.dart';
import 'package:nawah/features/auth/data/model/requests/reset_password_request_model.dart';
import 'package:nawah/features/auth/data/model/requests/verify_otp_request_model.dart';
import 'package:nawah/features/auth/data/model/requests/update_profile_request_model.dart';
import 'package:nawah/features/auth/data/model/responses/login_response_model.dart';
import 'package:nawah/features/auth/data/model/responses/register_response_model.dart';
import 'package:nawah/features/auth/data/model/shared/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, RegisterModel>> register(RegisterRequestModel params);
  Future<Either<Failure, LoginModel>> login(LoginRequestModel params);
  Future<Either<Failure, LoginModel>> logout();

  Future<Either<Failure, void>> saveUserData(UserModel user);
  Future<Either<Failure, UserModel>> getSavedUserData();
  Future<Either<Failure, void>> clearUserData();
  Future<Either<Failure, LoginModel>> refreshTokenLogin();
  Future<Either<Failure, LoginModel>> forgotPassword(
    ForgetPasswordRequestModel params,
  );
  Future<Either<Failure, LoginModel>> resetPassword(
    ResetPasswordRequestModel params,
  );
  Future<Either<Failure, LoginModel>> resendCode(ResendCodeRequestModel params);
  Future<Either<Failure, LoginModel>> verifyOtpForRegistration(
    VerifyOtpRequestModel params,
  );
  Future<Either<Failure, LoginModel>> verifyOtpForPasswordReset(
    VerifyOtpRequestModel params,
  );
  Future<Either<Failure, LoginModel>> updateProfile(
    UpdateProfileRequestModel params,
  );
}
