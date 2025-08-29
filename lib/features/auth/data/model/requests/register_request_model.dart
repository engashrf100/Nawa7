class RegisterRequestModel {
  final String name;
  final String dob;
  final String phone;
  final String countryId;
  final String password;
  final String passwordConfirmation;
  final String? deviceType;
  final String? deviceId;
  final String? dobOld;
  final String? gender;

  RegisterRequestModel({
    required this.name,
    required this.dob,
    required this.phone,
    required this.countryId,
    required this.password,
    required this.passwordConfirmation,
    this.deviceType,
    this.deviceId,
    this.dobOld,
    this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "dob": dob,
      "phone": phone,
      "country_id": countryId,
      "password": password,
      "password_confirmation": passwordConfirmation,
      if (deviceType != null) "device_type": deviceType,
      if (deviceId != null) "device_id": deviceId,
      if (dobOld != null) "dob": dobOld,
      if (gender != null) "gender": gender,
    };
  }

  RegisterRequestModel copyWith({
    String? name,
    String? dob,
    String? phone,
    String? countryId,
    String? password,
    String? passwordConfirmation,
    String? deviceType,
    String? deviceId,
    String? dobOld,
    String? gender,
  }) {
    return RegisterRequestModel(
      name: name ?? this.name,
      dob: dob ?? this.dob,
      phone: phone ?? this.phone,
      countryId: countryId ?? this.countryId,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      deviceType: deviceType ?? this.deviceType,
      deviceId: deviceId ?? this.deviceId,
      dobOld: dobOld ?? this.dobOld,
      gender: gender ?? this.gender,
    );
  }
}
