import 'package:nawah/features/auth/presentation/cubits/otp_cubit/otp_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawah/core/erros/failures.dart';
import 'package:nawah/features/auth/data/model/requests/resend_code_request_model.dart';
import 'package:nawah/features/auth/data/model/requests/verify_otp_request_model.dart';
import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_state.dart';
import 'package:nawah/features/auth/presentation/repositories/auth_repository.dart';

class OtpCubit extends Cubit<OtpState> {
  final AuthRepository authRepository;

  OtpCubit(this.authRepository) : super(const OtpState());

  Future<void> resendCode(ResendCodeRequestModel request) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await authRepository.resendCode(request);

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.failure, message: failure.message),
      ),
      (model) => emit(
        state.copyWith(
          status: AuthStatus.resendCodeSuccess,
          message: model.message,
        ),
      ),
    );
  }

  Future<void> verifyOtpForRegistration(VerifyOtpRequestModel request) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await authRepository.verifyOtpForRegistration(request);

    result.fold(
      (failure) => failure is ValidationFailure
          ? emit(
              state.copyWith(
                status: AuthStatus.validationError,
                errors: failure.errors,
              ),
            )
          : emit(
              state.copyWith(
                status: AuthStatus.failure,
                message: failure.message,
                errors: null,
              ),
            ),
      (model) => emit(
        state.copyWith(
          status: AuthStatus.otpRegistrationSuccess,
          message: model.message,
        ),
      ),
    );
  }

  Future<void> verifyOtpForPasswordReset(VerifyOtpRequestModel request) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await authRepository.verifyOtpForPasswordReset(request);

    result.fold(
      (failure) => failure is ValidationFailure
          ? emit(
              state.copyWith(
                status: AuthStatus.validationError,
                errors: failure.errors,
              ),
            )
          : emit(
              state.copyWith(
                status: AuthStatus.failure,
                message: failure.message,
              ),
            ),
      (model) => emit(
        state.copyWith(
          status: AuthStatus.otpForPasswordSuccess,
          message: model.message,
        ),
      ),
    );
  }
}
