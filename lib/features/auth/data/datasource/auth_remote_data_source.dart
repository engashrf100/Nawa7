import 'package:nawah/features/auth/data/model/requests/forget_password_request_model.dart';
import 'package:nawah/features/auth/data/model/requests/register_request_model.dart';
import 'package:nawah/core/network/api_service.dart';
import 'package:nawah/features/auth/data/model/requests/login_request_model.dart';
import 'package:nawah/features/auth/data/model/requests/resend_code_request_model.dart';
import 'package:nawah/features/auth/data/model/requests/reset_password_request_model.dart';
import 'package:nawah/features/auth/data/model/requests/verify_otp_request_model.dart';
import 'package:nawah/features/auth/data/model/requests/update_profile_request_model.dart';
import 'package:nawah/features/auth/data/model/responses/login_response_model.dart';
import 'package:nawah/features/auth/data/model/responses/register_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<RegisterModel> registerUser(RegisterRequestModel request);
  Future<LoginModel> loginUser(LoginRequestModel request);
  Future<LoginModel> refreshTokenLogin();
  Future<LoginModel> logout();

  Future<LoginModel> forgotPassword(ForgetPasswordRequestModel request);
  Future<LoginModel> resetPassword(ResetPasswordRequestModel request);
  Future<LoginModel> resendCode(ResendCodeRequestModel request);
  Future<LoginModel> verifyOtpForRegistration(VerifyOtpRequestModel request);
  Future<LoginModel> verifyOtpForPasswordReset(VerifyOtpRequestModel request);
  Future<LoginModel> updateProfile(UpdateProfileRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl({required this.apiService});

  @override
  Future<RegisterModel> registerUser(RegisterRequestModel request) async {
    final httpResponse = await apiService.registerUser(
      name: request.name,
      phone: request.phone,
      password: request.password,
      deviceId: request.deviceId ?? '',
      deviceType: request.deviceType ?? '',
      countryId: request.countryId,
      dob: request.dob,
      gender: request.gender ?? "",
      passwordConfirmation: request.passwordConfirmation,
    );

    return httpResponse.data.copyWith(status: httpResponse.response.statusCode);
  }

  @override
  Future<LoginModel> loginUser(LoginRequestModel request) async {
    final httpResponse = await apiService.loginUser(
      phone: request.phone,
      password: request.password,
      deviceId: request.deviceId ?? '',
      deviceType: request.deviceType ?? '',
      countryId: request.countryId,
    );

    return httpResponse.data.copyWith(status: httpResponse.response.statusCode);
  }

  @override
  Future<LoginModel> refreshTokenLogin() async {
    final httpResponse = await apiService.refreshTokenLogin();

    return httpResponse.data.copyWith(status: httpResponse.response.statusCode);
  }

  @override
  Future<LoginModel> forgotPassword(ForgetPasswordRequestModel request) async {
    final httpResponse = await apiService.forgotPassword(
      request.countryId,
      request.phone,
    );

    return httpResponse.data.copyWith(status: httpResponse.response.statusCode);
  }

  @override
  Future<LoginModel> resendCode(ResendCodeRequestModel request) async {
    final httpResponse = await apiService.resendCode(
      countryId: request.countryId,
      phone: request.phone,
    );

    return httpResponse.data.copyWith(status: httpResponse.response.statusCode);
  }

  @override
  Future<LoginModel> resetPassword(ResetPasswordRequestModel request) async {
    final httpResponse = await apiService.resetPassword(
      countryId: request.countryId,
      phone: request.phone,
      otp: request.otp,
      newPassword: request.password,
      passwordConfirmation: request.passwordConfirmation,
    );

    return httpResponse.data.copyWith(status: httpResponse.response.statusCode);
  }

  @override
  Future<LoginModel> verifyOtpForPasswordReset(
    VerifyOtpRequestModel request,
  ) async {
    final httpResponse = await apiService.checkOtp(
      countryId: request.countryId,
      phone: request.phone,
      code: request.code,
    );

    return httpResponse.data.copyWith(status: httpResponse.response.statusCode);
  }

  @override
  Future<LoginModel> verifyOtpForRegistration(
    VerifyOtpRequestModel request,
  ) async {
    final httpResponse = await apiService.checkOtp(
      countryId: request.countryId,
      phone: request.phone,
      code: request.code,
    );

    return httpResponse.data.copyWith(status: httpResponse.response.statusCode);
  }

  @override
  Future<LoginModel> logout() async {
    final httpResponse = await apiService.logout();

    return httpResponse.data.copyWith(status: httpResponse.response.statusCode);
  }

  @override
  Future<LoginModel> updateProfile(UpdateProfileRequestModel request) async {
    final httpResponse = await apiService.updateProfile(
      name: request.name,
      email: request.email,
      phone: request.phone,
      gender: request.gender,
      dob: request.dob,
      countryId: request.countryId,
      avatar: request.avatar,
    );

    return httpResponse.data.copyWith(status: httpResponse.response.statusCode);
  }
}
