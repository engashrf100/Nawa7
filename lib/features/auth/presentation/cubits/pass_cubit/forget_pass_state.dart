import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_state.dart';
import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawah/core/erros/failures.dart';
import 'package:nawah/features/auth/data/model/requests/forget_password_request_model.dart';
import 'package:nawah/features/auth/data/model/requests/reset_password_request_model.dart';
import 'package:nawah/features/auth/presentation/repositories/auth_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nawah/features/auth/data/model/shared/validation_model.dart';

part 'forget_pass_state.freezed.dart';

@freezed
class ForgetPassState with _$ForgetPassState {
  const factory ForgetPassState({
    @Default(AuthStatus.initial) AuthStatus status,
    ValidationErrors? errors,
    String? message,
  }) = _ForgetPassState;
}

extension ForgetPassErrorExtension<T> on ForgetPassState {
  List<String>? get emailError =>
      (this as dynamic).errors?.fieldErrors["email"];
  List<String>? get firstNameError =>
      (this as dynamic).errors?.fieldErrors["name"];
  List<String>? get phoneError =>
      (this as dynamic).errors?.fieldErrors["phone"];
  List<String>? get countryError =>
      (this as dynamic).errors?.fieldErrors["country_id"];
  List<String>? get passwordError =>
      (this as dynamic).errors?.fieldErrors["password"];
  List<String>? get confirmPasswordError =>
      (this as dynamic).errors?.fieldErrors["password_confirmation"];
  List<String>? get dobError => (this as dynamic).errors?.fieldErrors["dob"];
  List<String>? get genderError =>
      (this as dynamic).errors?.fieldErrors["gender"];
  List<String>? get codeError => (this as dynamic).errors?.fieldErrors["otp"];
}
