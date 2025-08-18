import 'package:nawah/core/erros/failures.dart';
import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawah/features/auth/data/model/shared/user_model.dart';
import 'package:nawah/features/auth/data/model/requests/update_profile_request_model.dart';
import 'package:nawah/features/auth/presentation/repositories/auth_repository.dart';

class TopMainCubit extends Cubit<TopMainState> {
  final AuthRepository authRepository;

  TopMainCubit(this.authRepository) : super(const TopMainState());

  void handleSuccess(UserModel user) {
    emit(state.copyWith(user: user));
    authRepository.saveUserData(user);
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await authRepository.logout();

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.failure, message: failure.message),
      ),
      (user) {
        emit(const TopMainState(status: AuthStatus.loggedOut));
        authRepository.clearUserData();
      },
    );
  }

  Future<void> getSavedUser() async {
    final result = await authRepository.getSavedUserData();
    result.fold((failure) {}, (user) => emit(state.copyWith(user: user)));
  }

  Future<void> updateProfile(UpdateProfileRequestModel request) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await authRepository.updateProfile(request);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: failure is ValidationFailure
              ? AuthStatus.validationError
              : AuthStatus.failure,
          validationErrors: failure is ValidationFailure
              ? failure.errors
              : null,
          message: failure.message,
        ),
      ),
      (response) {
        final mergedUser = state.user?.merge(response.user) ?? response.user;

        emit(
          state.copyWith(
            status: AuthStatus.profileUpdateSuccess,
            user: mergedUser,
            message: response.message,
            validationErrors: null,
          ),
        );

        if (mergedUser != null) {
          authRepository.saveUserData(mergedUser);
        }
      },
    );
  }
}
