class SettingsModel {
  List<AppSettings>? data;
  int? status;

  SettingsModel({this.data, this.status});

  SettingsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AppSettings>[];
      json['data'].forEach((v) {
        data!.add(AppSettings.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class AppSettings {
  String? key;
  String? value;

  AppSettings({this.key, this.value});

  AppSettings.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['value'] = value;
    return data;
  }


  
}
