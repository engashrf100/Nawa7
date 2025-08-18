class UserModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? gender;
  String? dob;
  String? countryId;
  String? deviceType;
  String? deviceId;
  String? accessToken;
  String? createdAt;
  String? updatedAt;
  String? isActive;
  bool? isBiometric;
  String? message;
  String? otp;
  String? avatar;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.dob,
    this.countryId,
    this.deviceType,
    this.deviceId,
    this.accessToken,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.isBiometric,
    this.message,
    this.otp,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      dob: json['dob'],
      countryId: json['country_id'],
      deviceType: json['device_type'],
      deviceId: json['device_id'],
      accessToken: json['accessToken'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isActive: json['is_active'],
      isBiometric: json['is_biometric'],
      message: json['message'],
      otp: json['otp'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'dob': dob,
      'country_id': countryId,
      'device_type': deviceType,
      'device_id': deviceId,
      'accessToken': accessToken,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_active': isActive,
      'is_biometric': isBiometric,
      'message': message,
      'otp': otp,
      'avatar': avatar,
    };
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? dob,
    String? countryId,
    String? deviceType,
    String? deviceId,
    String? accessToken,
    String? createdAt,
    String? updatedAt,
    String? isActive,
    bool? isBiometric,
    String? message,
    String? otp,
    String? avatar,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      countryId: countryId ?? this.countryId,
      deviceType: deviceType ?? this.deviceType,
      deviceId: deviceId ?? this.deviceId,
      accessToken: accessToken ?? this.accessToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      isBiometric: isBiometric ?? this.isBiometric,
      message: message ?? this.message,
      otp: otp ?? this.otp,
      avatar: avatar ?? this.avatar,
    );
  }
}

extension UserModelX on UserModel {
  UserModel merge(UserModel? other) {
    if (other == null) return this;
    return copyWith(
      id: other.id ?? id,
      name: other.name ?? name,
      email: other.email ?? email,
      phone: other.phone ?? phone,
      gender: other.gender ?? gender,
      dob: other.dob ?? dob,
      countryId: other.countryId ?? countryId,
      deviceType: other.deviceType ?? deviceType,
      deviceId: other.deviceId ?? deviceId,
      accessToken: other.accessToken ?? accessToken,
      createdAt: other.createdAt ?? createdAt,
      updatedAt: other.updatedAt ?? updatedAt,
      isActive: other.isActive ?? isActive,
      isBiometric: other.isBiometric ?? isBiometric,
      message: other.message ?? message,
      otp: other.otp ?? otp,
      avatar: other.avatar ?? avatar,
    );
  }
}
