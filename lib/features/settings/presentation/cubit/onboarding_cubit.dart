import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawah/features/settings/presentation/cubit/onboarding_state.dart';
import 'package:nawah/features/settings/presentation/repository/app_prefs_repository.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final SettingsRepository _repository;

  OnboardingCubit(this._repository) : super(const OnboardingState.initial());

  Future<void> loadOnboardingData() async {
    emit(const OnboardingState.loading());

    final result = await _repository.getAppIntro();
    result.fold(
      (failure) {
        emit(OnboardingState.error(failure.message));
      },
      (data) {
        emit(OnboardingState.loaded(data));
      },
    );
  }

  void goToNextPage() {
    state.whenOrNull(
      loaded: (onboardingData, currentPageIndex) {
        final totalPages = onboardingData.pages?.length;
        if (currentPageIndex < totalPages! - 1) {
          emit(
            OnboardingState.loaded(
              onboardingData,
              currentPageIndex: currentPageIndex + 1,
            ),
          );
        }
      },
    );
  }

  void goToPreviousPage() {
    state.whenOrNull(
      loaded: (onboardingData, currentPageIndex) {
        if (currentPageIndex > 0) {
          emit(
            OnboardingState.loaded(
              onboardingData,
              currentPageIndex: currentPageIndex - 1,
            ),
          );
        }
      },
    );
  }

  void goToPage(int pageIndex) {
    state.whenOrNull(
      loaded: (onboardingData, currentPageIndex) {
        final totalPages = onboardingData.pages?.length;
        if (pageIndex >= 0 && pageIndex < totalPages!) {
          emit(
            OnboardingState.loaded(onboardingData, currentPageIndex: pageIndex),
          );
        }
      },
    );
  }

  void resetToInitial() {
    emit(const OnboardingState.initial());
  }

  // Additional helper methods you might find useful:

  bool get canGoNext {
    return state.whenOrNull(
          loaded: (onboardingData, currentPageIndex) {
            return currentPageIndex < onboardingData.pages!.length - 1;
          },
        ) ??
        false;
  }

  bool get canGoPrevious {
    return state.whenOrNull(
          loaded: (onboardingData, currentPageIndex) {
            return currentPageIndex > 0;
          },
        ) ??
        false;
  }

  bool get isLastPage {
    return state.whenOrNull(
          loaded: (onboardingData, currentPageIndex) {
            return currentPageIndex == onboardingData.pages!.length - 1;
          },
        ) ??
        false;
  }

  bool get isFirstPage {
    return state.whenOrNull(
          loaded: (onboardingData, currentPageIndex) {
            return currentPageIndex == 0;
          },
        ) ??
        false;
  }
}
