import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nawah/features/auth/data/model/shared/validation_model.dart';
import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_state.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default(AuthStatus.initial) AuthStatus status,
    ValidationErrors? errors,
    String? message,
  }) = _LoginState;
}

extension LoginStateErrorExtension<T> on LoginState {
  List<String>? get phoneError {
    final phoneErrors =
        (this as dynamic).errors?.fieldErrors["phone"] as List<String>?;
    final countryErrors =
        (this as dynamic).errors?.fieldErrors["country_id"] as List<String>?;

    final combined = <String>[...?phoneErrors, ...?countryErrors];

    return combined.isNotEmpty ? combined : null; // This line fixes it
  }

  List<String>? get emailError => 
      (this as dynamic).errors?.fieldErrors["email"];
  List<String>? get firstNameError =>
      (this as dynamic).errors?.fieldErrors["name"];

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
