class CountriesModel {
  List<Country>? countries;
  int? status;

  CountriesModel({this.countries, this.status});

  CountriesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      countries = <Country>[];
      json['data'].forEach((v) {
        countries!.add(Country.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (countries != null) {
      data['data'] = countries!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class Country {
  int? id;
  String? name;
  String? flag;
  String? countryCode;

  Country({this.id, this.name, this.flag, this.countryCode});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    flag = json['flag'];
    countryCode = json['country_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['flag'] = flag;
    data['country_code'] = countryCode;
    return data;
  }
}
