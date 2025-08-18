import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawah/core/erros/failures.dart';
import 'package:nawah/features/settings/data/model/app_preferences_model.dart';
import 'package:nawah/features/settings/data/model/country_model.dart';
import 'package:nawah/features/settings/data/model/settings_response_model.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_state.dart';
import 'package:nawah/features/settings/presentation/repository/app_prefs_repository.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _repository;
  static const int totalOnboardingPages = 4;

  SettingsCubit(this._repository) : super(const SettingsState());

  Future<void> loadSettings() async {
    emit(state.copyWith(settingsState: SettingsLoadingState.loading));

    final result = await _repository.fetchSettings();

    result.fold(
      (failure) {
        emit(
          state.withSettingsResult(
            state: failure is NoInternetFailure
                ? SettingsLoadingState.noInternet
                : SettingsLoadingState.error,
            errorMessage: failure.message,
          ),
        );
      },
      (settings) {
        emit(
          state.withSettingsResult(
            state: SettingsLoadingState.loaded,
            settings: settings,
          ),
        );
      },
    );
  }

  Future<void> initApp() async {
    final result = await _repository.getPreferences();

    result.fold(
      (_) => emit(
        const SettingsState(
          themeMode: AppThemeMode.light,
          flowStatus: AppFlowStatus.choosingLang,
        ),
      ),
      (prefs) {
        emit(
          state.copyWith(
            themeMode: prefs.theme ?? state.themeMode,
            flowStatus: prefs.flowStatus ?? state.flowStatus,
          ),
        );
      },
    );
  }

  Future<void> savePreferences(AppPreferencesModel prefs) async {
    final mergedPrefs = AppPreferencesModel(
      theme: prefs.theme ?? state.themeMode,
      flowStatus: prefs.flowStatus ?? state.flowStatus,
      languageCode: prefs.languageCode,
    );

    await _repository.savePreferences(mergedPrefs);

    emit(
      state.copyWith(
        themeMode: mergedPrefs.theme!,
        flowStatus: mergedPrefs.flowStatus!,
      ),
    );
  }

  Future<void> toggleTheme() async {
    final newTheme = state.themeMode.toggled;

    await savePreferences(AppPreferencesModel(theme: newTheme));
  }

  Future<void> resetAppPreferences() async {
    final result = await _repository.clearPreferences();

    result.fold((_) => null, (_) => _emitDefaultState());
  }

  void _emitDefaultState() {
    emit(
      const SettingsState(
        themeMode: AppThemeMode.light,
        flowStatus: AppFlowStatus.choosingLang,
      ),
    );
  }

  void goToNextOnboardingPage() {
    if (state.onboardingPageIndex < totalOnboardingPages - 1) {
      emit(state.copyWith(onboardingPageIndex: state.onboardingPageIndex + 1));
    }
  }

  void goToPreviousOnboardingPage() {
    if (state.onboardingPageIndex > 0) {
      emit(state.copyWith(onboardingPageIndex: state.onboardingPageIndex - 1));
    }
  }

  void goToOnboardingPage(int index) {
    if (index >= 0 && index < totalOnboardingPages) {
      emit(state.copyWith(onboardingPageIndex: index));
    }
  }

  void setOnboardingFlowStatus() {
    emit(state.copyWith(flowStatus: AppFlowStatus.onboarding));
  }

  Future<void> loadCountries() async {
    final result = await _repository.fetchCountries();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            countriesState: failure is NoInternetFailure
                ? CountriesState.noInternet
                : CountriesState.error,
            errorMessage: failure.message,
          ),
        );  
      },
      (countries) {
        emit(
          state.copyWith(
            countriesState: CountriesState.loaded,
            countries: countries,
            selectedCountry: countries.countries?.first,
          ),
        );
      },
    );
  }

  void selectCountry(Country country) {
    emit(state.copyWith(selectedCountry: country));
  }
}
