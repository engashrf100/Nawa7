import 'dart:io';

class UpdateProfileRequestModel {
  final String? name;
  final String? email;
  final String? phone;
  final String? gender;
  final String? dob;
  final String? countryId;
  final File? avatar;

  UpdateProfileRequestModel({
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.dob,
    this.countryId,
    this.avatar,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (name != null && name!.isNotEmpty) {
      data['name'] = name;
    }
    if (email != null && email!.isNotEmpty) {
      data['email'] = email;
    }
    if (phone != null && phone!.isNotEmpty) {
      data['phone'] = phone;
    }
    if (gender != null && gender!.isNotEmpty) {
      data['gender'] = gender;
    }
    if (dob != null && dob!.isNotEmpty) {
      data['dob'] = dob;
    }
    if (countryId != null && countryId!.isNotEmpty) {
      data['country_id'] = countryId;
    }
    // Note: avatar is handled separately in the API service as a file

    return data;
  }

  UpdateProfileRequestModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? dob,
    String? countryId,
    File? avatar,
  }) {
    return UpdateProfileRequestModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      countryId: countryId ?? this.countryId,
      avatar: avatar ?? this.avatar,
    );
  }
}
