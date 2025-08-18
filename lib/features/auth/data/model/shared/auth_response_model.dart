class AuthResponseModel {
  final int? status;
  final String? message;
  final String? otp;

  AuthResponseModel({
    this.status,
    this.message,
    this.otp,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return AuthResponseModel(
      status: json['status'],
      message:
          data != null ? data['message'] ?? json['message'] : json['message'],
      otp: data != null ? data['otp'] : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'otp': otp,
    };
  }

  AuthResponseModel copyWith({
    int? status,
    String? message,
    String? otp,
  }) {
    return AuthResponseModel(
      status: status ?? this.status,
      message: message ?? this.message,
      otp: otp ?? this.otp,
    );
  }
}
