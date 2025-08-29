import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nawah/features/settings/data/model/app_preferences_model.dart';
import 'package:nawah/features/settings/data/model/country_model.dart';
import 'package:nawah/features/settings/data/model/settings_response_model.dart';

part 'settings_state.freezed.dart';

enum AppThemeMode { light, dark }

enum AppFlowStatus { initial, choosingLang, onboarding, home }

enum SettingsLoadingState { initial, loading, loaded, error, noInternet }

enum CountriesState { initial, loaded, empty, error, noInternet }

enum AboutUsLoadingState { initial, loading, loaded, error, noInternet }

enum TermsLoadingState { initial, loading, loaded, error, noInternet }

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(AppThemeMode.light) AppThemeMode themeMode,
    @Default(AppFlowStatus.initial) AppFlowStatus flowStatus,
    @Default(0) int onboardingPageIndex,

    AppPreferencesModel? preferences,

    @Default(SettingsLoadingState.initial) SettingsLoadingState settingsState,
    SettingsModel? settings,
    String? settingsErrorMessage,

    @Default(CountriesState.initial) CountriesState countriesState,
    CountriesModel? countries,
    String? errorMessage,
    Country? selectedCountry,

    @Default(AboutUsLoadingState.initial) AboutUsLoadingState aboutUsState,
    SettingsModel? aboutUsData,
    String? aboutUsErrorMessage,

    @Default(TermsLoadingState.initial) TermsLoadingState termsState,
    SettingsModel? termsData,
    String? termsErrorMessage,
  }) = _SettingsState;
}

extension AppThemeToggle on AppThemeMode {
  AppThemeMode get toggled =>
      this == AppThemeMode.light ? AppThemeMode.dark : AppThemeMode.light;
}

extension SettingsStateX on SettingsState {
  SettingsState withSettingsResult({
    required SettingsLoadingState state,
    SettingsModel? settings,
    String? errorMessage,
  }) {
    return copyWith(
      settingsState: state,
      settings: settings,
      settingsErrorMessage: errorMessage,
    );
  }
}
