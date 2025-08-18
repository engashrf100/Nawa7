import 'package:nawah/features/auth/data/model/requests/login_request_model.dart';
import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_state.dart';
import 'package:nawah/features/auth/presentation/cubits/login_cubit/login_state.dart';
import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawah/core/erros/failures.dart';
import 'package:nawah/core/services/device_info_service.dart';
import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_state.dart';
import 'package:nawah/features/auth/presentation/repositories/auth_repository.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;
  final DeviceInfoService deviceInfoService;
  final TopMainCubit topMainCubit;

  LoginCubit(this.authRepository, this.deviceInfoService, this.topMainCubit)
    : super(const LoginState());

  Future<void> login(LoginRequestModel request) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final deviceType = await deviceInfoService.getDeviceType();
    final deviceId = await deviceInfoService.getDeviceId();
    final result = await authRepository.login(
      request.copyWith(deviceType: deviceType, deviceId: deviceId),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: failure is ValidationFailure
              ? AuthStatus.validationError
              : AuthStatus.failure,
          errors: failure is ValidationFailure ? failure.errors : null,
          message: failure.message,
        ),
      ),
      (loginModel) {
        topMainCubit.handleSuccess(loginModel.user!);
        emit(state.copyWith(status: AuthStatus.loginSuccess));
      },
    );
  }
}
