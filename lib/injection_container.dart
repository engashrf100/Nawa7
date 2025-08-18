import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:nawah/core/network/api_service.dart';
import 'package:nawah/core/network/dio_factory.dart';
import 'package:nawah/core/services/device_info_service.dart';
import 'package:nawah/core/services/network_info.dart';
import 'package:nawah/core/services/secure_storage_service.dart';
import 'package:nawah/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:nawah/features/auth/data/datasource/local_remote_data_source.dart';
import 'package:nawah/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:nawah/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:nawah/features/auth/presentation/cubits/otp_cubit/otp_cubit.dart';
import 'package:nawah/features/auth/presentation/cubits/pass_cubit/forget_pass_cubit.dart';
import 'package:nawah/features/auth/presentation/cubits/register_cubit/register_cuibt.dart';
import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_cubit.dart';
import 'package:nawah/features/auth/presentation/repositories/auth_repository.dart';

import 'package:nawah/features/home/data/datasource/home_remote_data_source.dart';
import 'package:nawah/features/home/data/repositories/home_repository_imp.dart';
import 'package:nawah/features/home/presentation/cubits/home/home_cubit.dart';
import 'package:nawah/features/home/presentation/repository/home_repository.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nawah/features/settings/presentation/cubit/onboarding_cubit.dart';

import 'package:nawah/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:nawah/features/settings/presentation/repository/app_prefs_repository.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'core/services/shared_pref_service.dart';
import 'features/settings/data/datasources/settings_local_data_source.dart';
import 'features/settings/data/repositories/app_prefs_repository_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initCore();
  await _settings();
  await _auth();

  await _home();
}

Future<void> _initCore() async {
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(storage: sl<FlutterSecureStorage>()),
  );

  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  sl.registerLazySingleton<SharedPrefService>(() => SharedPrefService(sl()));

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(Connectivity()));
  sl.registerLazySingleton<DioFactory>(
    () => DioFactory(sl<SharedPrefService>(), sl<SecureStorageService>()),
  );

  final dio = await sl<DioFactory>().createDio();
  sl.registerLazySingleton<ApiService>(() => ApiService(dio));

  sl.registerLazySingleton<DeviceInfoService>(() => DeviceInfoService());
}

Future<void> _home() async {
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(apiService: sl()),
  );

  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(homeRemoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton<HomeCubit>(() => HomeCubit(sl()));
}

Future<void> _settings() async {
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<SettingsRemoteDataSource>(
    () => SettingsRemoteDataSourceImpl(apiService: sl()),
  );

  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton<SettingsCubit>(() => SettingsCubit(sl()));
  sl.registerLazySingleton<OnboardingCubit>(() => OnboardingCubit(sl()));
}

Future<void> _auth() async {
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiService: sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authRemoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<TopMainCubit>(() => TopMainCubit(sl()));

  sl.registerFactory<RegisterCubit>(() => RegisterCubit(sl(), sl(), sl()));
  sl.registerFactory<LoginCubit>(() => LoginCubit(sl(), sl(), sl()));
  sl.registerFactory<ForgetPassCubit>(() => ForgetPassCubit(sl()));
  sl.registerFactory<OtpCubit>(() => OtpCubit(sl()));
}
