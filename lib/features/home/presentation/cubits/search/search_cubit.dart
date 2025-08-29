import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawah/features/home/data/model/branch_model/branch_model.dart';
import 'package:nawah/features/home/presentation/cubits/search/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchState());

  void initializeSearch(List<Branch> branches) {
    final regions = _extractUniqueRegions(branches);
    final categories = _extractUniqueCategories(branches);
    
    emit(state.copyWith(
      allBranches: branches,
      availableRegions: regions,
      availableCategories: categories,
      status: SearchStatus.loaded,
    ));
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
    _performSearch();
  }

  void updateRegionFilter(int? regionId) {
    print('🔍 Debug: updateRegionFilter - Current filters: ${state.filters.regionId}, ${state.filters.categoryId}, ${state.filters.workingDays}');
    final newFilters = state.filters.copyWith(regionId: regionId);
    print('🔍 Debug: updateRegionFilter - New filters: ${newFilters.regionId}, ${newFilters.categoryId}, ${newFilters.workingDays}');
    final newState = state.copyWith(filters: newFilters);
    emit(newState);
    _performSearch();
  }

  void updateCategoryFilter(int? categoryId) {
    print('🔍 Debug: updateCategoryFilter - Current filters: ${state.filters.regionId}, ${state.filters.categoryId}, ${state.filters.workingDays}');
    final newFilters = state.filters.copyWith(categoryId: categoryId);
    print('🔍 Debug: updateCategoryFilter - New filters: ${newFilters.regionId}, ${newFilters.categoryId}, ${newFilters.workingDays}');
    final newState = state.copyWith(filters: newFilters);
    emit(newState);
    _performSearch();
  }

  void updateWorkingDaysFilter(List<String> workingDays) {
    print('🔍 Debug: updateWorkingDaysFilter - Current filters: ${state.filters.regionId}, ${state.filters.categoryId}, ${state.filters.workingDays}');
    final newFilters = state.filters.copyWith(workingDays: workingDays);
    print('🔍 Debug: updateWorkingDaysFilter - New filters: ${newFilters.regionId}, ${newFilters.categoryId}, ${newFilters.workingDays}');
    emit(state.copyWith(filters: newFilters));
    _performSearch();
  }

  void updateSorting(String sortBy, String sortOrder) {
    final newFilters = state.filters.copyWith(
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
    emit(state.copyWith(filters: newFilters));
    _performSearch();
  }

  void clearFilters() {
    print('🔍 Debug: clearFilters - Clearing all filters');
    emit(state.copyWith(
      filters: const SearchFilters(),
      searchResults: state.allBranches,
    ));
  }

  void loadMoreResults() {
    if (!state.hasMoreData) return;
    
    // For now, we'll load all results at once
    // In the future, this can be paginated with backend
    emit(state.copyWith(hasMoreData: false));
  }

  void printCurrentFilters() {
    print('🔍 Debug: Current filter state:');
    print('  - Region ID: ${state.filters.regionId}');
    print('  - Category ID: ${state.filters.categoryId}');
    print('  - Working Days: ${state.filters.workingDays}');
    print('  - Sort By: ${state.filters.sortBy}');
    print('  - Sort Order: ${state.filters.sortOrder}');
  }

  // Test method to verify filter independence
  void testFilterIndependence() {
    print('🔍 Debug: Testing filter independence...');
    
    // Test 1: Set region filter
    print('🔍 Debug: Test 1 - Setting region filter to 1');
    updateRegionFilter(1);
    printCurrentFilters();
    
    // Test 2: Set category filter (should preserve region)
    print('🔍 Debug: Test 2 - Setting category filter to 2');
    updateCategoryFilter(2);
    printCurrentFilters();
    
    // Test 3: Set working days filter (should preserve region and category)
    print('🔍 Debug: Test 3 - Setting working days filter to [monday, tuesday]');
    updateWorkingDaysFilter(['monday', 'tuesday']);
    printCurrentFilters();
  }

  void _performSearch() {
    if (state.allBranches.isEmpty) return;

    print('🔍 Debug: _performSearch - Using filters: ${state.filters.regionId}, ${state.filters.categoryId}, ${state.filters.workingDays}');

    final results = _searchBranches(
      state.searchQuery,
      state.filters,
      state.allBranches,
    );

    print('🔍 Debug: _performSearch - Found ${results.length} results');

    emit(state.copyWith(
      searchResults: results,
      currentPage: 1,
      hasMoreData: false, // For now, show all results
    ));
  }

  List<Branch> _searchBranches(
    String query,
    SearchFilters filters,
    List<Branch> branches,
  ) {
    return branches.where((branch) {
      // Text search
      bool textMatch = query.isEmpty || _matchesText(branch, query);
      
      // Region filter
      bool regionMatch = filters.regionId == null || 
        branch.region?.id == filters.regionId;
      
      // Category filter
      bool categoryMatch = filters.categoryId == null || 
        branch.categories?.any((cat) => 
          cat.id == filters.categoryId
        ) == true;
      
      // Working days filter
      bool workingDaysMatch = filters.workingDays.isEmpty || 
        _matchesWorkingDays(branch, filters.workingDays);
      
      return textMatch && regionMatch && categoryMatch && workingDaysMatch;
    }).toList();
  }

  bool _matchesText(Branch branch, String query) {
    final lowerQuery = query.toLowerCase();
    
    // Search in branch name
    if (branch.name?.toLowerCase().contains(lowerQuery) == true) {
      return true;
    }
    
    // Search in address
    if (branch.addressDescription?.toLowerCase().contains(lowerQuery) == true) {
      return true;
    }
    
    // Search in categories
    if (branch.categories?.any((cat) => 
      cat.name?.toLowerCase().contains(lowerQuery) == true
    ) == true) {
      return true;
    }
    
    // Search in region
    if (branch.region?.name?.toLowerCase().contains(lowerQuery) == true) {
      return true;
    }
    
    return false;
  }

  bool _matchesWorkingDays(Branch branch, List<String> workingDays) {
    if (branch.workDays == null) return false;
    
    return workingDays.any((day) {
      switch (day) {
        case 'sunday':
          return branch.workDays!.sunday == true;
        case 'monday':
          return branch.workDays!.monday == true;
        case 'tuesday':
          return branch.workDays!.tuesday == true;
        case 'wednesday':
          return branch.workDays!.wednesday == true;
        case 'thursday':
          return branch.workDays!.thursday == true;
        case 'friday':
          return branch.workDays!.friday == true;
        case 'saturday':
          return branch.workDays!.saturday == true;
        default:
          return false;
      }
    });
  }

  List<Region> _extractUniqueRegions(List<Branch> branches) {
    final regionMap = <int, Region>{};
    for (final branch in branches) {
      if (branch.region != null) {
        regionMap[branch.region!.id!] = branch.region!;
      }
    }
    return regionMap.values.toList();
  }

  List<Category> _extractUniqueCategories(List<Branch> branches) {
    final categoryMap = <int, Category>{};
    for (final branch in branches) {
      if (branch.categories != null) {
        for (final category in branch.categories!) {
          if (category.id != null) {
            categoryMap[category.id!] = category;
          }
        }
      }
    }
    return categoryMap.values.toList();
  }
}
