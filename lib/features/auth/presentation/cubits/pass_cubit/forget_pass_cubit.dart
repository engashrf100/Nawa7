import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_state.dart';
import 'package:nawah/features/auth/presentation/cubits/pass_cubit/forget_pass_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawah/core/erros/failures.dart';
import 'package:nawah/features/auth/data/model/requests/forget_password_request_model.dart';
import 'package:nawah/features/auth/data/model/requests/reset_password_request_model.dart';
import 'package:nawah/features/auth/presentation/repositories/auth_repository.dart';

class ForgetPassCubit extends Cubit<ForgetPassState> {
  final AuthRepository authRepository;

  ForgetPassCubit(this.authRepository) : super(const ForgetPassState());

  Future<void> forgotPassword(ForgetPasswordRequestModel request) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await authRepository.forgotPassword(request);

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
          status: AuthStatus.forgotPasswordSuccess,
          message: model.message,
        ),
      ),
    );
  }

  Future<void> resetPassword(ResetPasswordRequestModel request) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await authRepository.resetPassword(request);

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
          status: AuthStatus.resetPasswordSuccess,
          message: model.message,
        ),
      ),
    );
  }
}
