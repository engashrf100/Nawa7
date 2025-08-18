import 'package:nawah/features/auth/data/model/shared/user_model.dart';
import 'package:nawah/features/auth/data/model/shared/validation_model.dart';

class LoginModel {
  int? status;
  String? message;
  ValidationErrors? validationErrors;
  UserModel? user; // ✅ Added

  LoginModel({this.status, this.message, this.validationErrors, this.user});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    validationErrors = json['errors'] != null
        ? ValidationErrors.fromJson(json['errors'])
        : null;
    user = json['data'] != null ? UserModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (validationErrors != null) {
      data['errors'] = validationErrors!.toJson();
    }
    if (user != null) {
      data['data'] = user!.toJson();
    }
    return data;
  }

  LoginModel copyWith({
    int? status,
    String? message,
    ValidationErrors? validationErrors,
    UserModel? user,
  }) {
    return LoginModel(
      status: status ?? this.status,
      message: message ?? this.message,
      validationErrors: validationErrors ?? this.validationErrors,
      user: user ?? this.user,
    );
  }
}
