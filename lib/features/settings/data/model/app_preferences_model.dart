import 'package:nawah/features/settings/presentation/cubit/settings_state.dart';

class AppPreferencesModel {
  final AppFlowStatus? flowStatus;
  final AppThemeMode? theme;
  final String? languageCode;

  AppPreferencesModel({this.flowStatus, this.theme, this.languageCode});

  factory AppPreferencesModel.fromJson(Map<String, dynamic> json) {
    return AppPreferencesModel(
      flowStatus: json['flowStatus'] != null
          ? AppFlowStatus.values.byName(json['flowStatus'])
          : null,
      theme: json['theme'] != null
          ? AppThemeMode.values.byName(json['theme'])
          : null,
      languageCode: json['languageCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flowStatus': flowStatus?.name,
      'theme': theme?.name,
      'languageCode': languageCode,
    };
  }

  AppPreferencesModel copyWith({
    AppFlowStatus? flowStatus,
    AppThemeMode? theme,
    String? languageCode,
  }) {
    return AppPreferencesModel(
      flowStatus: flowStatus ?? this.flowStatus,
      theme: theme ?? this.theme,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  AppPreferencesModel merge(AppPreferencesModel? other) {
    if (other == null) return this;
    return AppPreferencesModel(
      flowStatus: other.flowStatus ?? flowStatus,
      theme: other.theme ?? theme,
      languageCode: other.languageCode ?? languageCode,
    );
  }
}
