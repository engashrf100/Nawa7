import 'package:nawah/core/network/api_service.dart';
import 'package:nawah/features/settings/data/model/country_model.dart';
import 'package:nawah/features/settings/data/model/onboarding_model.dart';
import 'package:nawah/features/settings/data/model/settings_response_model.dart';

abstract class SettingsRemoteDataSource {
  Future<SettingsModel> getSettings();
  Future<OnboardingModel> getAppIntro();
  Future<CountriesModel> getCountries();
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final ApiService apiService;

  SettingsRemoteDataSourceImpl({required this.apiService});

  @override
  Future<SettingsModel> getSettings() async {
    final httpResponse = await apiService.getSettings();

    return httpResponse.data;
  }

  @override
  Future<OnboardingModel> getAppIntro() async {
    final response = await apiService.getAppIntro();
    return response.data;
  }

  @override
  Future<CountriesModel> getCountries() async {
    final response = await apiService.getCountries();
    return response.data;
  }
}
