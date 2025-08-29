import 'dart:io';
import 'package:dio/dio.dart';
import 'package:nawah/core/network/app_links.dart';
import 'package:nawah/features/auth/data/model/responses/login_response_model.dart';
import 'package:nawah/features/auth/data/model/responses/register_response_model.dart';
import 'package:nawah/features/home/data/model/branch_model/app_branch_model.dart';
import 'package:nawah/features/home/data/model/branch_model/app_branches_model.dart';
import 'package:nawah/features/home/data/model/home_model.dart';
import 'package:nawah/features/settings/data/model/country_model.dart';
import 'package:nawah/features/settings/data/model/settings_response_model.dart';
import 'package:nawah/features/settings/data/model/onboarding_model.dart';

import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: AppLinks.baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST(AppLinks.registerUrl)
  @MultiPart()
  Future<HttpResponse<RegisterModel>> registerUser({
    @Part(name: 'name') required String name,
    @Part(name: 'phone') required String phone,
    @Part(name: 'password') required String password,
    @Part(name: 'device_id') required String deviceId,
    @Part(name: 'device_type') required String deviceType,
    @Part(name: 'country_id') required String countryId,
    @Part(name: 'dob') required String dob,
    @Part(name: 'gender') required String gender,
    @Part(name: 'password_confirmation') required String passwordConfirmation,
  });

  @POST(AppLinks.loginurl)
  @MultiPart()
  Future<HttpResponse<LoginModel>> loginUser({
    @Part(name: 'phone') required String phone,
    @Part(name: 'password') required String password,
    @Part(name: 'device_id') required String deviceId,
    @Part(name: 'device_type') required String deviceType,
    @Part(name: 'country_id') required String countryId,
  });

  @POST(AppLinks.refreshToken)
  @MultiPart()
  Future<HttpResponse<LoginModel>> refreshTokenLogin();

  @POST(AppLinks.forgetPasswordUrl)
  @MultiPart()
  Future<HttpResponse<LoginModel>> forgotPassword(
    @Part(name: 'country_id') String countryId,
    @Part(name: 'phone') String phone,
  );

  @POST(AppLinks.resetPasswordUrl)
  @MultiPart()
  Future<HttpResponse<LoginModel>> resetPassword({
    @Part(name: 'country_id') required String countryId,
    @Part(name: 'phone') required String phone,
    @Part(name: 'otp') required String otp,
    @Part(name: 'password') required String newPassword,
    @Part(name: 'password_confirmation') required String passwordConfirmation,
  });

  @POST(AppLinks.resendCodeUrl)
  @MultiPart()
  Future<HttpResponse<LoginModel>> resendCode({
    @Part(name: 'country_id') required String countryId,
    @Part(name: 'phone') required String phone,
  });

  @POST(AppLinks.logoutUrl)
  @MultiPart()
  Future<HttpResponse<LoginModel>> logout();

  @POST(AppLinks.checkOtpUrl)
  @MultiPart()
  Future<HttpResponse<LoginModel>> checkOtp({
    @Part(name: 'country_id') required String countryId,
    @Part(name: 'phone') required String phone,
    @Part(name: 'otp') required String code,
  });

  @POST(AppLinks.profileUpdateUrl)
  @MultiPart()
  Future<HttpResponse<LoginModel>> updateProfile({
    @Part(name: 'name') String? name,
    @Part(name: 'email') String? email,
    @Part(name: 'phone') String? phone,
    @Part(name: 'gender') String? gender,
    @Part(name: 'dob') String? dob,
    @Part(name: 'country_id') String? countryId,
    @Part(name: 'avatar') File? avatar,
  });

  @GET(AppLinks.countries)
  Future<HttpResponse<CountriesModel>> getCountries();

  @GET(AppLinks.home)
  Future<HttpResponse<HomeModel>> getHome();

  @GET('${AppLinks.branchDetails}/{id}')
  Future<HttpResponse<AppBranch>> getBranchById(@Path('id') int id);

  @GET(AppLinks.branchDetails)
  Future<HttpResponse<AppBranches>> getBranches({
    @Query('page') required int page,
    @Query('limit') required int limit,
  });

  @GET(AppLinks.settingsUrl)
  Future<HttpResponse<SettingsModel>> getSettings();

  @GET('${AppLinks.settingsUrl}?key={key}')
  Future<HttpResponse<SettingsModel>> getSettingsByKey(@Query('key') String key);

  @GET(AppLinks.appIntro)
  Future<HttpResponse<OnboardingModel>> getAppIntro();
}
