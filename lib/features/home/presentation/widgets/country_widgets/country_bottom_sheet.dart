import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/app_card.dart';
import 'package:nawah/core/widgets/base_bottom_sheet.dart';
import 'package:nawah/core/widgets/loading_spinner.dart';
import 'package:nawah/core/widgets/selectable_row_item.dart';

import 'package:nawah/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_state.dart';
import 'package:nawah/features/settings/presentation/pages/error_screen.dart';
import 'package:nawah/features/settings/data/model/country_model.dart';

class CountryBottomSheet extends StatefulWidget {
  const CountryBottomSheet({super.key});

  @override
  State<CountryBottomSheet> createState() => _CountryBottomSheetState();
}

class _CountryBottomSheetState extends State<CountryBottomSheet> {
  late TextEditingController _searchController;
  Timer? _debounceTimer;
  List<Country> _filteredCountries = [];
  List<String> _searchHistory = [];
  bool _isSearchActive = false;
  String _currentSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadSearchHistory();
    
    // Add listener to detect when bottom sheet is being closed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // This ensures we're properly set up after the first frame
        _searchController.addListener(_onSearchControllerChanged);
      }
    });
  }

  @override
  void dispose() {
    // Cancel any pending debounce timer
    _debounceTimer?.cancel();
    
    // Remove listener and dispose controller
    _searchController.removeListener(_onSearchControllerChanged);
    _searchController.dispose();
    
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the widget is being removed from the tree
    if (!mounted) {
      _searchController.dispose();
      _debounceTimer?.cancel();
    }
  }

  @override
  void deactivate() {
    // This is called when the widget is removed from the widget tree
    // Ensure proper cleanup when bottom sheet is closed
    _debounceTimer?.cancel();
    super.deactivate();
  }

  void _onSearchControllerChanged() {
    // This method is called whenever the text controller changes
    // We can use this for additional cleanup if needed
  }

  void _loadSearchHistory() {
    // Load last 2 search items from local storage
    // For now, we'll use a simple approach, but you can integrate with SharedPreferences
    _searchHistory = [];
  }

  void _saveSearchHistory(String query) {
    if (query.trim().isEmpty) return;
    
    setState(() {
      // Remove if already exists
      _searchHistory.remove(query.trim());
      // Add to beginning
      _searchHistory.insert(0, query.trim());
      // Keep only last 2 items
      if (_searchHistory.length > 2) {
        _searchHistory = _searchHistory.take(2).toList();
      }
    });
  }

  void _onSearchChanged(String query) {
    _currentSearchQuery = query;
    
    // Cancel previous timer
    _debounceTimer?.cancel();
    
    if (query.trim().isEmpty) {
      setState(() {
        _isSearchActive = false;
        _filteredCountries = [];
      });
      return;
    }

    // Set search as active
    setState(() {
      _isSearchActive = true;
    });

    // Debounce search for 200ms
    _debounceTimer = Timer(const Duration(milliseconds: 200), () {
      _performSearch(query);
    });
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;

    final countries = context.read<SettingsCubit>().state.countries?.countries ?? [];
    
    final filtered = countries.where((country) {
      final searchLower = query.toLowerCase();
      final nameLower = (country.name ?? '').toLowerCase();
      final codeLower = (country.countryCode ?? '').toLowerCase();
      
      return nameLower.contains(searchLower) || codeLower.contains(searchLower);
    }).toList();

    setState(() {
      _filteredCountries = filtered;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearchActive = false;
      _filteredCountries = [];
      _currentSearchQuery = '';
    });
  }

  void _onHistoryItemTap(String query) {
    _searchController.text = query;
    _onSearchChanged(query);
  }

  List<Country> _getCountriesToDisplay() {
    if (_isSearchActive) {
      return _filteredCountries;
    }
    return context.read<SettingsCubit>().state.countries?.countries ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      maxHeight: 600.h,
      children: [
        _buildSearchSection(),
        _buildCountriesList(context),
      ],
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: EdgeInsets.all(8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Text Field
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            

            decoration: InputDecoration(
              
              hintText: 'country_search_hint'.tr(),
              hintStyle: AppTextStyles.tajawal12W400.copyWith(
                color: Theme.of(context).colorScheme.text40,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.text40,
                size: 20.sp,
              ),
              suffixIcon: _currentSearchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Theme.of(context).colorScheme.text40,
                        size: 20.sp,
                      ),
                      onPressed: _clearSearch,
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.blue00),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.border,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
            style: AppTextStyles.tajawal14W500,
          ),
          
          // Search History
          if (_searchHistory.isNotEmpty && !_isSearchActive) ...[
            SizedBox(height: 12.h),
            Text(
              'recent_searches'.tr(),
              style: AppTextStyles.tajawal12W500.copyWith(
                color: Theme.of(context).colorScheme.text40,
              ),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              children: _searchHistory.map((query) {
                return GestureDetector(
                  onTap: () => _onHistoryItemTap(query),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.blue00.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.blue00.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      query,
                      style: AppTextStyles.tajawal12W500.copyWith(
                        color: Theme.of(context).colorScheme.blue00,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCountriesList(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        switch (state.countriesState) {
          case CountriesState.loaded:
            final countries = _getCountriesToDisplay();
            
            if (countries.isEmpty) {
              if (_isSearchActive) {
                return _buildNoSearchResults();
              }
              return _buildEmptyMessage('no_countries_available'.tr());
            }
            
            return AppCard(
              child: SingleChildScrollView(
                child: Column(
                  children: countries.map((country) {
                    final isSelected = state.selectedCountry?.id == country.id;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: SelectableRowItem(
                        imageUrl: country.flag ?? '',
                        label: country.name ?? '',
                        isSelected: isSelected,
                        onTap: () {
                          if (_isSearchActive) {
                            _saveSearchHistory(_currentSearchQuery);
                          }
                          context.read<SettingsCubit>().selectCountry(country);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            );

          case CountriesState.error:
          case CountriesState.noInternet:
            final isNoInternet =
                state.countriesState == CountriesState.noInternet;
            return ErrorScreen(
              errorMessage: state.errorMessage ?? 'error_loading_data'.tr(),
              isNoInternet: isNoInternet,
              onRetry: () {
                context.read<SettingsCubit>().loadCountries();
              },
            );

          case CountriesState.initial:
            return const Center(child: LoadingSpinner(size: 30));
          case CountriesState.empty:
            return _buildEmptyMessage('no_countries_available'.tr());
        }
      },
    );
  }

  Widget _buildNoSearchResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 48.sp,
            color: Theme.of(context).colorScheme.text40,
          ),
          SizedBox(height: 16.h),
          Text(
            'no_countries_found'.tr(args: [_currentSearchQuery]),
            style: AppTextStyles.tajawal14W500.copyWith(
              color: Theme.of(context).colorScheme.text40,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'try_different_keywords'.tr(),
            style: AppTextStyles.tajawal12W400.copyWith(
              color: Theme.of(context).colorScheme.text40,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMessage(String message) {
    return Center(
      child: Text(
        message,
        style: AppTextStyles.tajawal14W500,
        textAlign: TextAlign.center,
      ),
    );
  }
}
