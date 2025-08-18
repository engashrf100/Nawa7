import 'package:nawah/core/services/shared_pref_service.dart';
import 'package:nawah/features/settings/data/model/app_preferences_model.dart';

abstract class SettingsLocalDataSource {
  Future<AppPreferencesModel> getPreferences();
  Future<void> savePreferences(AppPreferencesModel prefs);
  Future<void> clearPreferences();


}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPrefService _sharedPrefService;


  // Keys for app preferences
  static const String _preferencesKey = 'app_preferences';


  SettingsLocalDataSourceImpl(this._sharedPrefService);

  @override
  Future<AppPreferencesModel> getPreferences() async {
    try {
      final prefsData = _sharedPrefService.getObject(_preferencesKey);
      if (prefsData != null) {
        return AppPreferencesModel.fromJson(prefsData);
      }
    } catch (e) {
      print('Error loading preferences: $e');
    }

    // Return default preferences if none stored
    return AppPreferencesModel();
  }

  @override
  Future<void> savePreferences(AppPreferencesModel prefs) async {
    try {
      await _sharedPrefService.saveObject(_preferencesKey, prefs.toJson());
    } catch (e) {
      print('Error saving preferences: $e');
    }
  }

  @override
  Future<void> clearPreferences() async {
    try {
      await _sharedPrefService.remove(_preferencesKey);
    } catch (e) {
      print('Error clearing preferences: $e');
    }
  }

}
