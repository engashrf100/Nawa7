import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_state.dart';
import 'package:nawah/features/auth/presentation/cubits/register_cubit/register_state.dart';
import 'package:nawah/features/auth/presentation/cubits/top_main/top_main_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawah/core/erros/failures.dart';
import 'package:nawah/core/services/device_info_service.dart';
import 'package:nawah/features/auth/data/model/requests/register_request_model.dart';
import 'package:nawah/features/auth/presentation/repositories/auth_repository.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository authRepository;
  final DeviceInfoService deviceInfoService;
  final TopMainCubit topMainCubit;

  RegisterCubit(this.authRepository, this.deviceInfoService, this.topMainCubit)
    : super(const RegisterState());

  Future<void> register(RegisterRequestModel request) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final deviceType = await deviceInfoService.getDeviceType();
    final deviceId = await deviceInfoService.getDeviceId();
    final result = await authRepository.register(
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
        emit(state.copyWith(status: AuthStatus.registerSuccess));
      },
    );
  }

  void updatePolicyCheck(bool isChecked) {
    emit(state.copyWith(isPolicyChecked: isChecked));
  }

  void updateGender(String gender) {
    emit(state.copyWith(selectedGender: gender));
  }
}
