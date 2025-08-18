class LoginRequestModel {
  final String countryId;
  final String phone;
  final String password;
  final String? deviceType;
  final String? deviceId;

  LoginRequestModel({
    required this.countryId,
    required this.phone,
    required this.password,
    this.deviceType,
    this.deviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      "country_id": countryId,
      "phone": phone,
      "password": password,
      if (deviceType != null) "device_type": deviceType,
      if (deviceId != null) "device_id": deviceId,
    };
  }

  LoginRequestModel copyWith({
    String? countryId,
    String? phone,
    String? password,
    String? deviceType,
    String? deviceId,
  }) {
    return LoginRequestModel(
      countryId: countryId ?? this.countryId,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      deviceType: deviceType ?? this.deviceType,
      deviceId: deviceId ?? this.deviceId,
    );
  }
}
