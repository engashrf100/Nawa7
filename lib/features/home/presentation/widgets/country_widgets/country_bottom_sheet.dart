import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/app_card.dart';
import 'package:nawah/core/widgets/base_bottom_sheet.dart';
import 'package:nawah/core/widgets/loading_spinner.dart';
import 'package:nawah/core/widgets/selectable_row_item.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/home_promary_button.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_state.dart';
import 'package:nawah/features/settings/presentation/pages/error_screen.dart';

class CountryBottomSheet extends StatelessWidget {
  const CountryBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      maxHeight: 600.h,
      children: [_buildCountriesList(context)],
    );
  }

  Widget _buildCountriesList(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        switch (state.countriesState) {
          case CountriesState.loaded:
            final countries = state.countries?.countries ?? [];
            if (countries.isEmpty) {
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
