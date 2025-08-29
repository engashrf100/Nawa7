import 'package:dartz/dartz.dart';
import 'package:nawah/core/erros/failures.dart';
import 'package:nawah/features/settings/data/model/app_preferences_model.dart';
import 'package:nawah/features/settings/data/model/country_model.dart';
import 'package:nawah/features/settings/data/model/onboarding_model.dart';
import 'package:nawah/features/settings/data/model/settings_response_model.dart';

abstract class SettingsRepository {
  Future<Either<Failure, AppPreferencesModel>> getPreferences();
  Future<Either<Failure, Unit>> savePreferences(
    AppPreferencesModel appPreferencesModel,
  );
  Future<Either<Failure, Unit>> clearPreferences();
  Future<Either<Failure, SettingsModel>> fetchSettings();
  Future<Either<Failure, SettingsModel>> fetchSettingsByKey(String key);
  Future<Either<Failure, OnboardingModel>> getAppIntro();

  Future<Either<Failure, CountriesModel>> fetchCountries();
}
