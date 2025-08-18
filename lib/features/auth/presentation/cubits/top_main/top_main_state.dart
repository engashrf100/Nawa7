import 'package:nawah/features/auth/data/model/shared/user_model.dart';
import 'package:nawah/features/auth/data/model/shared/validation_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'top_main_state.freezed.dart';

@freezed
class TopMainState with _$TopMainState {
  const factory TopMainState({
    @Default(AuthStatus.initial) AuthStatus status,
    UserModel? user,
    String? message,
    ValidationErrors? validationErrors,
  }) = _TopMainState;
}

enum AuthStatus {
  initial,
  loading,
  loginSuccess,
  registerSuccess,
  forgotPasswordSuccess,
  resendCodeSuccess,
  otpRegistrationSuccess,
  otpForPasswordSuccess,
  resetPasswordSuccess,
  validationError,
  failure,
  loggedOut,
  biometricSuccess,
  biometricFailure,
  biometricErorr,
  profileUpdateSuccess,
  profileUpdateFailure,
}

extension TopMainStateErrorExtension on TopMainState {
  List<String>? get nameError => validationErrors?.fieldErrors["name"];

  List<String>? get emailError => validationErrors?.fieldErrors["email"];

  List<String>? get phoneError => validationErrors?.fieldErrors["phone"];

  List<String>? get genderError => validationErrors?.fieldErrors["gender"];

  List<String>? get dobError => validationErrors?.fieldErrors["dob"];

  List<String>? get countryIdError =>
      validationErrors?.fieldErrors["country_id"];

  List<String>? get avatarError => validationErrors?.fieldErrors["avatar"];
}
