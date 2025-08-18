import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nawah/features/auth/data/model/shared/validation_model.dart';

part 'register_state.freezed.dart';

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState({
    @Default(AuthStatus.initial) AuthStatus status,
    ValidationErrors? errors,
    String? message,
    @Default(false) bool isPolicyChecked,
    @Default("1") String selectedGender,
  }) = _RegisterState;
}

extension RegisterStateErrorExtension<T> on RegisterState {
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
