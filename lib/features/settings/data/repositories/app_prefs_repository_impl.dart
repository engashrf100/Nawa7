import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nawah/core/erros/failures.dart';
import 'package:nawah/core/network/dio_exception.dart';
import 'package:nawah/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:nawah/features/settings/data/model/app_preferences_model.dart';
import 'package:nawah/features/settings/data/model/country_model.dart';
import 'package:nawah/features/settings/data/model/onboarding_model.dart';
import 'package:nawah/features/settings/data/model/settings_response_model.dart';
import 'package:nawah/features/settings/presentation/repository/app_prefs_repository.dart';
import '../datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;
  final SettingsRemoteDataSource dataSource;

  SettingsRepositoryImpl(this.localDataSource, this.dataSource);

  @override
  Future<Either<Failure, AppPreferencesModel>> getPreferences() async {
    try {
      final prefs = await localDataSource.getPreferences();
      return Right(prefs);
    } catch (e) {
      return Left(CacheFailure('Failed to load preferences: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> savePreferences(
    AppPreferencesModel newPrefs,
  ) async {
    try {
      final oldPrefsResult = await getPreferences();
      final oldPrefs = oldPrefsResult.fold<AppPreferencesModel?>(
        (_) => null,
        (p) => p,
      );

      final mergedPrefs = (oldPrefs ?? AppPreferencesModel()).merge(newPrefs);

      await localDataSource.savePreferences(mergedPrefs);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Failed to save preferences: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearPreferences() async {
    try {
      await localDataSource.clearPreferences();
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, SettingsModel>> fetchSettings() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, SettingsModel>> fetchSettingsByKey(String key) async {
    try {
      final settingsData = await dataSource.getSettingsByKey(key);
      return Right(settingsData);
    } on DioException catch (dioError) {
      return Left(handleDioException(dioError));
    } catch (error) {
      return Left(ServerFailure('Failed to load settings data: $error'));
    }
  }

  @override
  Future<Either<Failure, OnboardingModel>> getAppIntro() async {
    try {
      final appIntroData = await dataSource.getAppIntro();
      return Right(appIntroData);
    } on DioException catch (dioError) {
      return Left(handleDioException(dioError));
    } catch (error) {
      return Left(ServerFailure('Failed to load getAppIntro data: $error'));
    }
  }

  @override
  Future<Either<Failure, CountriesModel>> fetchCountries() async {
    try {
      final countriesData = await dataSource.getCountries();
      return Right(countriesData);
    } catch (e) {
      return Left(ServerFailure('Failed to load countries data: $e'));
    }
  }
}
