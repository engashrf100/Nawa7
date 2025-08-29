import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';

import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/features/auth/presentation/cubits/register_cubit/register_cuibt.dart';
import 'package:nawah/features/auth/presentation/cubits/register_cubit/register_state.dart';

class SelectGenderWidget extends StatelessWidget {
  const SelectGenderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) =>
          previous.selectedGender != current.selectedGender,
      builder: (context, state) {
        return Row(
          children: [
            _GenderOption(
              label: 'male'.tr(),
              value: '1',
              isSelected: state.selectedGender == '1',
              onTap: () => context.read<RegisterCubit>().updateGender('1'),
            ),
            Gap(16.w),
            _GenderOption(
              label: 'female'.tr(),
              value: '2',
              isSelected: state.selectedGender == '2',
              onTap: () => context.read<RegisterCubit>().updateGender('2'),
            ),
          ],
        );
      },
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (_) => onTap(),
            side: BorderSide(color: AppColors.lightBlue03, width: 1.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
            activeColor: AppColors.lightBlue03,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          Gap(8.w),
          Text(
            label,
            style: AppTextStyles.tajawal16W500.copyWith(
              color: Theme.of(context).colorScheme.text100,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
