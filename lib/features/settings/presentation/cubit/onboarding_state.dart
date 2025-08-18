import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nawah/features/settings/data/model/onboarding_model.dart';

part 'onboarding_state.freezed.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState.initial() = _Initial;
  const factory OnboardingState.loading() = _Loading;
  const factory OnboardingState.loaded(
    OnboardingModel onboardingData, {
    @Default(0) int currentPageIndex,
  }) = _Loaded;
  const factory OnboardingState.error(String message) = _Error;
}
