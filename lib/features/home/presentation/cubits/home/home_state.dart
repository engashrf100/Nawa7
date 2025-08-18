import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nawah/features/home/data/model/branch_model/app_branch_model.dart';
import 'package:nawah/features/home/data/model/branch_model/app_branches_model.dart';
import 'package:nawah/features/home/data/model/branch_model/branch_model.dart';
import 'package:nawah/features/home/data/model/home_model.dart';

part 'home_state.freezed.dart';

enum HomeStatus {
  initial,
  loading,
  loaded,
  error,
  noInternet,
  branchLoaded,
  branchesLoaded,
  branchesLoadingMore,
  branchesRefreshing,
}


@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeStatus.initial) HomeStatus status,
    HomeModel? homeData,
    AppBranch? branch,
    @Default([])
    List<Branch> allBranches, // Combined list of all loaded branches
    @Default(1) int currentPage,
    @Default(true) bool hasMoreData,
    String? errorMessage,
  }) = _HomeState;
}

extension HomeStates on HomeState {
  bool get isLoading => status == HomeStatus.loading;
  bool get isLoaded => status == HomeStatus.loaded;
  bool get hasError => status == HomeStatus.error;
  bool get hasNoInternet => status == HomeStatus.noInternet;
  bool get hasBranch => status == HomeStatus.branchLoaded;
  bool get hasBranches => status == HomeStatus.branchesLoaded;
  bool get isLoadingMore => status == HomeStatus.branchesLoadingMore;
  bool get isRefreshing => status == HomeStatus.branchesRefreshing;
  bool get hasHomeData => status == HomeStatus.loaded;
}
