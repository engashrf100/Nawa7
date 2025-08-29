import 'package:nawah/features/home/data/model/branch_model/branch_model.dart';

enum SearchStatus { initial, loading, loaded, error }

class SearchState {
  final SearchStatus status;
  final String searchQuery;
  final List<Branch> allBranches;
  final List<Branch> searchResults;
  final List<Region> availableRegions;
  final List<Category> availableCategories;
  final SearchFilters filters;
  final String errorMessage;
  final int currentPage;
  final bool hasMoreData;

  const SearchState({
    this.status = SearchStatus.initial,
    this.searchQuery = '',
    this.allBranches = const [],
    this.searchResults = const [],
    this.availableRegions = const [],
    this.availableCategories = const [],
    this.filters = const SearchFilters(),
    this.errorMessage = '',
    this.currentPage = 1,
    this.hasMoreData = true,
  });

  SearchState copyWith({
    SearchStatus? status,
    String? searchQuery,
    List<Branch>? allBranches,
    List<Branch>? searchResults,
    List<Region>? availableRegions,
    List<Category>? availableCategories,
    SearchFilters? filters,
    String? errorMessage,
    int? currentPage,
    bool? hasMoreData,
  }) {
    return SearchState(
      status: status ?? this.status,
      searchQuery: searchQuery ?? this.searchQuery,
      allBranches: allBranches ?? this.allBranches,
      searchResults: searchResults ?? this.searchResults,
      availableRegions: availableRegions ?? this.availableRegions,
      availableCategories: availableCategories ?? this.availableCategories,
      filters: filters ?? this.filters,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMoreData: hasMoreData ?? this.hasMoreData,
    );
  }
}

class SearchFilters {
  final int? regionId;
  final int? categoryId;
  final List<String> workingDays;
  final String sortBy;
  final String sortOrder;

  const SearchFilters({
    this.regionId,
    this.categoryId,
    this.workingDays = const [],
    this.sortBy = 'name',
    this.sortOrder = 'asc',
  });



  SearchFilters copyWith({
    int? regionId,
    int? categoryId,
    List<String>? workingDays,
    String? sortBy,
    String? sortOrder,
  }) {
    return SearchFilters(
      regionId: regionId ?? this.regionId,
      categoryId: categoryId ?? this.categoryId,
      workingDays: workingDays ?? this.workingDays,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
