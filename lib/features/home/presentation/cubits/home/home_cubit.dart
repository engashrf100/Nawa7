import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawah/features/home/data/model/branch_model/app_branches_model.dart';
import 'package:nawah/features/home/presentation/repository/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;

  HomeCubit(this._homeRepository)
    : super(HomeState(status: HomeStatus.initial));

  Future<void> getInitData() async {
    emit(state.copyWith(status: HomeStatus.loading));
    /*
    if (state.allBranches.isEmpty && state.homeData == null) {
      emit(state.copyWith(status: HomeStatus.loading));
    }
*/
    final homeDataResult = await _homeRepository.getHomeData();
    final branchesResult = await _homeRepository.getBranches(1);

    final homeDataFailure = homeDataResult.fold(
      (failure) => failure,
      (data) => null,
    );
    final branchFailure = branchesResult.fold(
      (failure) => failure,
      (data) => null,
    );

    if (homeDataFailure != null) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: homeDataFailure.message,
        ),
      );
      return;
    }

    if (branchFailure != null) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: branchFailure.message,
        ),
      );
      return;
    }

    final homeData = homeDataResult.fold((failure) => null, (data) => data);
    final branches = branchesResult.fold((failure) => null, (data) => data);

    emit(
      state.copyWith(
        status: HomeStatus.loaded,
        homeData: homeData,
        allBranches: branches?.branches ?? [],
        currentPage: 1,
        hasMoreData: _checkHasMoreData(branches!),
      ),
    );
  }

  Future<void> getHomeData() async {
    emit(state.copyWith(status: HomeStatus.loading));

    final result = await _homeRepository.getHomeData();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: HomeStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (homeData) {
        emit(state.copyWith(status: HomeStatus.loaded, homeData: homeData));
      },
    );
  }

  Future<void> getBranchById(int id) async {
    emit(state.copyWith(status: HomeStatus.loading));

    final result = await _homeRepository.getBranchById(id);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: HomeStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (branch) {
        emit(state.copyWith(status: HomeStatus.branchLoaded, branch: branch));
      },
    );
  }

  Future<void> getBranches({bool refresh = false}) async {
    if (refresh) {
      emit(
        state.copyWith(
          status: HomeStatus.loading,
          currentPage: 1,
          allBranches: [],
          hasMoreData: true,
        ),
      );
    } else if (state.allBranches.isEmpty) {
      emit(state.copyWith(status: HomeStatus.loading));
    }

    final result = await _homeRepository.getBranches(
      refresh ? 1 : state.currentPage,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: HomeStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (branches) {
        final newBranches = branches.branches ?? [];
        final updatedBranches = refresh
            ? newBranches
            : [...state.allBranches, ...newBranches];
        final hasMore = _checkHasMoreData(branches);

        emit(
          state.copyWith(
            status: HomeStatus.branchesLoaded,
            allBranches: updatedBranches,
            currentPage: refresh ? 1 : state.currentPage,
            hasMoreData: hasMore,
          ),
        );
      },
    );
  }

  Future<void> loadMoreBranches() async {
    // Prevent multiple simultaneous requests
    if (!state.hasMoreData || state.isLoadingMore) return;

    emit(state.copyWith(status: HomeStatus.branchesLoadingMore));

    final nextPage = state.currentPage + 1;
    final result = await _homeRepository.getBranches(nextPage);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: HomeStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (branches) {
        final newBranches = branches.branches ?? [];
        final updatedBranches = [...state.allBranches, ...newBranches];
        final hasMore = _checkHasMoreData(branches);

        emit(
          state.copyWith(
            status: HomeStatus.branchesLoaded,
            allBranches: updatedBranches,
            currentPage: nextPage,
            hasMoreData: hasMore,
          ),
        );
      },
    );
  }

  bool _checkHasMoreData(AppBranches appBranches) {
    final meta = appBranches.meta;
    if (meta == null) return false;

    final currentPage = meta.currentPage ?? 1;
    final lastPage = meta.lastPage ?? 1;

    return currentPage < lastPage;
  }

  void resetBranches() {
    emit(
      state.copyWith(
        allBranches: [],
        currentPage: 1,
        hasMoreData: true,
        status: HomeStatus.initial,
      ),
    );
  }
}
