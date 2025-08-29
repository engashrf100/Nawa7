import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/app_card.dart';
import 'package:nawah/core/widgets/gradient_icon_button.dart';
import 'package:nawah/core/widgets/custom_text_field.dart';
import 'package:nawah/core/widgets/base_bottom_sheet.dart';
import 'package:nawah/core/widgets/selectable_row_item.dart';
import 'package:nawah/features/home/data/model/branch_model/branch_model.dart';
import 'package:nawah/features/home/presentation/cubits/search/search_cubit.dart';
import 'package:nawah/features/home/presentation/cubits/search/search_state.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/home_center_item.dart';

class SearchScreen extends StatefulWidget {
  final List<Branch> initialBranches;

  const SearchScreen({
    super.key,
    required this.initialBranches,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchCubit _searchCubit;
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _searchCubit = SearchCubit();
    _searchCubit.initializeSearch(widget.initialBranches);
  }

  @override
  void dispose() {
    _searchCubit.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.homeBg,
      appBar: _buildAppBar(theme, context),
      body: BlocProvider.value(
        value: _searchCubit,
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            return Column(
              children: [
                _buildCompactSearchSection(theme, state),
                _buildResultsSection(theme, state),
              ],
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme, BuildContext context) {
    return AppBar(
      toolbarHeight: 70.h,
      automaticallyImplyLeading: false,
      backgroundColor: theme.colorScheme.homeBg,
      elevation: 0,
      title: Container(
        width: 361.w,
        height: 70.h,
        padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 8.h, top: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GradientIconButton(
              assetPath: AppAssets.backArrow,
              useSvg: true,
              isLeft: false,
              onTap: () => Navigator.pop(context),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'search_branches'.tr(),
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.tajawal16W500.copyWith(
                    color: theme.colorScheme.text100,
                  ),
                ),
              ),
            ),
            SizedBox(width: 46.w), // Placeholder to maintain balance
          ],
        ),
      ),
    );
  }

  Widget _buildCompactSearchSection(ThemeData theme, SearchState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Column(
        children: [
          // Search text field in AppCard
          AppCard(
           // padding: EdgeInsets.all(16.w),
            child: CustomTextField(
              
              controller: _searchController,
              hintText: 'search_placeholder'.tr(),
              onChanged: (query) {
                _searchCubit.updateSearchQuery(query);
              },
            ),
          ),
          
          // Filters in AppCard
          Gap(8.h),
          AppCard(
            child: Column(
              children: [
                // Three filter containers in one row
                Row(
                  children: [
                    // Days filter container
                    Expanded(
                      child: _buildFilterContainer(
                        theme: theme,
                        icon: Icons.schedule_outlined,
                        title: state.filters.workingDays.isNotEmpty 
                            ? '${state.filters.workingDays.length} ${'days'.tr()}'
                            : 'working_days'.tr(),
                        isActive: state.filters.workingDays.isNotEmpty,
                        onTap: _showWorkingDaysFilter,
                      ),
                    ),
                    Gap(8.w),
                    // Location filter container
                    Expanded(
                      child: _buildFilterContainer(
                        theme: theme,
                        icon: Icons.location_on_outlined,
                        title: _getLocationTitle(state),
                        isActive: state.filters.regionId != null,
                        onTap: () => _showRegionBottomSheet(context, state),
                      ),
                    ),
                    Gap(8.w),
                    // Categories filter container
                    Expanded(
                      child: _buildFilterContainer(
                        theme: theme,
                        icon: Icons.medical_services_outlined,
                        title: _getCategoryTitle(state),
                        isActive: state.filters.categoryId != null,
                        onTap: () => _showCategoriesBottomSheet(context, state),
                      ),
                    ),
                  ],
                ),
                
                // Working days filter chips (expandable)
                if (_showFilters) ...[
                  Gap(12.h),
                  _buildWorkingDaysFilter(theme, state),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterContainer({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: isActive 
              ? AppColors.darkBlue02 
              : theme.colorScheme.border,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isActive 
                ? AppColors.darkBlue02 
                : theme.colorScheme.border,
            width: 1.w,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: isActive 
                  ? Colors.white 
                  : AppColors.darkBlue02,
            ),
            Gap(4.h),
            Flexible(
              child: Text(
                title,
                style: AppTextStyles.tajawal12W500.copyWith(
                  color: isActive 
                      ? Colors.white 
                      : theme.colorScheme.text100,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkingDaysFilter(ThemeData theme, SearchState state) {
    final workingDays = [
      {'key': 'sunday', 'label': 'sunday'.tr()},
      {'key': 'monday', 'label': 'monday'.tr()},
      {'key': 'tuesday', 'label': 'tuesday'.tr()},
      {'key': 'wednesday', 'label': 'wednesday'.tr()},
      {'key': 'thursday', 'label': 'thursday'.tr()},
      {'key': 'friday', 'label': 'friday'.tr()},
      {'key': 'saturday', 'label': 'saturday'.tr()},
    ];

    return AppCard(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    size: 18.sp,
                    color: theme.colorScheme.text60,
                  ),
                  Gap(8.w),
                  Text(
                    'working_days'.tr(),
                    style: AppTextStyles.tajawal14W500.copyWith(
                      color: theme.colorScheme.text100,
                    ),
                  ),
                ],
              ),
              // Close button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showFilters = false;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.border,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 16.sp,
                    color: theme.colorScheme.text60,
                  ),
                ),
              ),
            ],
          ),
          Gap(8.h),
          // Working days chips
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: workingDays.map((day) {
              final isSelected = state.filters.workingDays.contains(day['key']);
              
              return FilterChip(
                label: Text(
                  day['label']!,
                  style: AppTextStyles.tajawal12W500.copyWith(
                    color: isSelected ? Colors.white : theme.colorScheme.text100,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  final newWorkingDays = List<String>.from(state.filters.workingDays);
                  if (selected) {
                    newWorkingDays.add(day['key']!);
                  } else {
                    newWorkingDays.remove(day['key']);
                  }
                  _searchCubit.updateWorkingDaysFilter(newWorkingDays);
                },
                backgroundColor: theme.colorScheme.container,
                selectedColor: AppColors.darkBlue02,
                checkmarkColor: Colors.white,
                side: BorderSide(
                  color: isSelected ? AppColors.darkBlue02 : theme.colorScheme.border,
                  width: 1.w,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showRegionBottomSheet(BuildContext context, SearchState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RegionBottomSheet(
        regions: state.availableRegions,
        selectedRegionId: state.filters.regionId,
        onRegionSelected: (regionId) {
          _searchCubit.updateRegionFilter(regionId);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showCategoriesBottomSheet(BuildContext context, SearchState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CategoriesBottomSheet(
        categories: state.availableCategories,
        selectedCategoryId: state.filters.categoryId,
        onCategorySelected: (categoryId) {
          _searchCubit.updateCategoryFilter(categoryId);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showWorkingDaysFilter() {
    setState(() {
      _showFilters = !_showFilters;
    });
  }

  String _getLocationTitle(SearchState state) {
    if (state.filters.regionId == null) {
      return 'all_regions'.tr();
    }
    
    final selectedRegion = state.availableRegions
        .where((region) => region.id == state.filters.regionId)
        .firstOrNull;
    
    // Truncate very long region names to prevent UI overflow
    final regionName = selectedRegion?.name ?? 'region'.tr();
    if (regionName.length > 20) {
      return '${regionName.substring(0, 17)}...';
    }
    
    return regionName;
  }

  String _getCategoryTitle(SearchState state) {
    if (state.filters.categoryId == null) {
      return 'all_categories'.tr();
    }
    
    final selectedCategory = state.availableCategories
        .where((category) => category.id == state.filters.categoryId)
        .firstOrNull;
    
    // Truncate very long category names to prevent UI overflow
    final categoryName = selectedCategory?.name ?? 'categories'.tr();
    if (categoryName.length > 20) {
      return '${categoryName.substring(0, 17)}...';
    }
    
    return categoryName;
  }

  Widget _buildResultsSection(ThemeData theme, SearchState state) {
    if (state.status == SearchStatus.loading) {
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.darkBlue02,
          ),
        ),
      );
    }

    if (state.searchResults.isEmpty) {
      return Expanded(
        child: _buildEmptyState(theme, state),
      );
    }

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: _buildResultsList(theme, state),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, SearchState state) {
    if (state.searchQuery.isEmpty && state.filters.regionId == null && 
        state.filters.categoryId == null && state.filters.workingDays.isEmpty) {
      return Center(
        child: AppCard(
        //  padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                size: 64.sp,
                color: theme.colorScheme.text60,
              ),
              Gap(16.h),
              Text(
                'search_placeholder'.tr(),
                style: AppTextStyles.tajawal16W500.copyWith(
                  color: theme.colorScheme.text60,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: AppCard(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64.sp,
              color: theme.colorScheme.text60,
            ),
            Gap(16.h),
            Text(
              'no_results_found'.tr(),
              style: AppTextStyles.tajawal16W500.copyWith(
                color: theme.colorScheme.text100,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(8.h),
            Text(
              'try_different_search'.tr(),
              style: AppTextStyles.tajawal14W400.copyWith(
                color: theme.colorScheme.text60,
            ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList(ThemeData theme, SearchState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'search_results'.tr(),
                  style: AppTextStyles.tajawal16W500.copyWith(
                    color: theme.colorScheme.text100,
                  ),
                ),
                Gap(8.w),
                Text(
                  '(${state.searchResults.length})',
                  style: AppTextStyles.tajawal14W400.copyWith(
                    color: theme.colorScheme.text60,
                  ),
                ),
              ],
            ),
            if (state.filters.regionId != null || 
                state.filters.categoryId != null || 
                state.filters.workingDays.isNotEmpty)
              GestureDetector(
                onTap: () => _searchCubit.clearFilters(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.clear,
                      size: 14.sp,
                      color: AppColors.darkBlue02,
                    ),
                    Gap(4.w),
                    Text(
                      'clear_filters'.tr(),
                      style: AppTextStyles.tajawal12W400.copyWith(
                        color: AppColors.darkBlue02,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        Gap(16.h),
        Expanded(
          child: ListView.builder(
            itemCount: state.searchResults.length,
            itemBuilder: (context, index) {
              final branch = state.searchResults[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: MedicalCenterItem(
                  center: branch,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Region Bottom Sheet
class _RegionBottomSheet extends StatelessWidget {
  final List<Region> regions;
  final int? selectedRegionId;
  final Function(int?) onRegionSelected;

  const _RegionBottomSheet({
    required this.regions,
    required this.selectedRegionId,
    required this.onRegionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      maxHeight: 500.h,
      children: [
        _buildHeader(context),
        _buildRegionsList(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.h),
      child: Text(
        'select_region'.tr(),
        style: AppTextStyles.tajawal18W700.copyWith(
          color: Theme.of(context).colorScheme.text100,
        ),
      ),
    );
  }

  Widget _buildRegionsList(BuildContext context) {
    return AppCard(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // All regions option
            _buildIconRowItem(
              context: context,
              icon: Icons.public,
              label: 'all_regions'.tr(),
              isSelected: selectedRegionId == null,
              onTap: () => onRegionSelected(null),
            ),
            // Individual regions
            ...regions.map((region) {
              return _buildIconRowItem(
                context: context,
                icon: Icons.location_on,
                label: region.name ?? '',
                isSelected: selectedRegionId == region.id,
                onTap: () => onRegionSelected(region.id),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildIconRowItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: colorScheme.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20.w,
                  color: isSelected ? AppColors.darkBlue02 : colorScheme.text60,
                ),
                Gap(12.w),
                Text(
                  label,
                  style: AppTextStyles.tajawal14W500.copyWith(
                    color: colorScheme.text80,
                  ),
                ),
              ],
            ),
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.darkBlue02 : Colors.transparent,
                border: isSelected
                    ? null
                    : Border.all(color: AppColors.lightGray00, width: 1.5.w),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// Categories Bottom Sheet
class _CategoriesBottomSheet extends StatefulWidget {
  final List<Category> categories;
  final int? selectedCategoryId;
  final Function(int?) onCategorySelected;

  const _CategoriesBottomSheet({
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  State<_CategoriesBottomSheet> createState() => _CategoriesBottomSheetState();
}

class _CategoriesBottomSheetState extends State<_CategoriesBottomSheet> {
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.selectedCategoryId;
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      maxHeight: 500.h,
      children: [
        _buildHeader(context),
        _buildCategoriesList(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.h),
      child: Text(
        'select_categories'.tr(),
        style: AppTextStyles.tajawal18W700.copyWith(
          color: Theme.of(context).colorScheme.text100,
        ),
      ),
    );
  }

  Widget _buildCategoriesList(BuildContext context) {
    return AppCard(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // All categories option
            _buildIconRowItem(
              context: context,
              icon: Icons.category,
              label: 'all_categories'.tr(),
              isSelected: _selectedCategoryId == null,
              onTap: () {
                widget.onCategorySelected(null);
              },
            ),
            // Individual categories
            ...widget.categories.map((category) {
              final isSelected = _selectedCategoryId == category.id;
              return _buildIconRowItem(
                context: context,
                icon: Icons.medical_services,
                label: category.name ?? '',
                isSelected: isSelected,
                onTap: () {
                  if (isSelected) {
                    widget.onCategorySelected(null); // Deselect if already selected
                  } else {
                    widget.onCategorySelected(category.id); // Select new category
                  }
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildIconRowItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: colorScheme.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20.w,
                  color: isSelected ? AppColors.darkBlue02 : colorScheme.text60,
                ),
                Gap(12.w),
                Text(
                  label,
                  style: AppTextStyles.tajawal14W500.copyWith(
                    color: colorScheme.text80,
                  ),
                ),
              ],
            ),
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.darkBlue02 : Colors.transparent,
                border: isSelected
                    ? null
                    : Border.all(color: AppColors.lightGray00, width: 1.5.w),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
