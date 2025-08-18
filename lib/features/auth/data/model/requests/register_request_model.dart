class RegisterRequestModel {
  final String name;
  final String? email;
  final String phone;
  final String countryId;
  final String password;
  final String passwordConfirmation;
  final String? deviceType;
  final String? deviceId;
  final String? dob;
  final String? gender;

  RegisterRequestModel({
    required this.name,
    this.email,
    required this.phone,
    required this.countryId,
    required this.password,
    required this.passwordConfirmation,
    this.deviceType,
    this.deviceId,
    this.dob,
    this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      if (email != null) "email": email,
      "phone": phone,
      "country_id": countryId,
      "password": password,
      "password_confirmation": passwordConfirmation,
      if (deviceType != null) "device_type": deviceType,
      if (deviceId != null) "device_id": deviceId,
      if (dob != null) "dob": dob,
      if (gender != null) "gender": gender,
    };
  }

  RegisterRequestModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? countryId,
    String? password,
    String? passwordConfirmation,
    String? deviceType,
    String? deviceId,
    String? dob,
    String? gender,
  }) {
    return RegisterRequestModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      countryId: countryId ?? this.countryId,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      deviceType: deviceType ?? this.deviceType,
      deviceId: deviceId ?? this.deviceId,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
    );
  }
}
