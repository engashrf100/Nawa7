class ResetPasswordRequestModel {
  final String countryId;
  final String phone;
  final String otp;
  final String password;
  final String passwordConfirmation;

  ResetPasswordRequestModel({
    required this.countryId,
    required this.phone,
    required this.otp,
    required this.password,
    required this.passwordConfirmation,
  });
}
