import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_decorations.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/app_card.dart';
import 'package:nawah/core/widgets/base_bottom_sheet.dart';
import 'package:nawah/core/widgets/selectable_row_item.dart';

class SpecialtySelectionButton extends StatelessWidget {
  final String? selectedSpecialty;
  final Function(String?) onSpecialtySelected;

  const SpecialtySelectionButton({
    Key? key,
    this.selectedSpecialty,
    required this.onSpecialtySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final String? result = await showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return SpecialtySelectionBottomSheet(
              initialSelectedSpecialty: selectedSpecialty,
            );
          },
        );
        if (result != null) {
          onSpecialtySelected(result);
        }
      },
      child: Container(
        width: 301.w,
        height: 53.h,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.homeBg,
          boxShadow: AppDecorations.dropdownShadow(context),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // CaretDown Icon
            Icon(
              Icons.keyboard_arrow_down,
              size: 16.w,
              color: Theme.of(context).colorScheme.text80,
            ),
            SizedBox(width: 6.w), // Gap between icon and text
            Expanded(
              child: Text(
                selectedSpecialty ?? 'select_specialty'.tr(),
                textAlign: TextAlign.right,
                style: AppTextStyles.tajawal14W500.copyWith(
                  color: Theme.of(context).colorScheme.text100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpecialtySelectionBottomSheet extends StatefulWidget {
  final String? initialSelectedSpecialty;

  const SpecialtySelectionBottomSheet({Key? key, this.initialSelectedSpecialty})
    : super(key: key);

  @override
  State<SpecialtySelectionBottomSheet> createState() =>
      _SpecialtySelectionBottomSheetState();
}

class _SpecialtySelectionBottomSheetState
    extends State<SpecialtySelectionBottomSheet> {
  String? _selectedSpecialty;

  final List<Map<String, String>> _specialties = [
    {'key': 'specialty_dermatology'},
    {'key': 'specialty_neuro'},
    {'key': 'specialty_obgyn'},
    {'key': 'specialty_ent'},
    {'key': 'specialty_internal_medicine'},
    {'key': 'specialty_cardiology'},
    {'key': 'specialty_pediatrics'},
    {'key': 'specialty_psychiatry'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedSpecialty = widget.initialSelectedSpecialty;
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      children: [
        AppCard(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: _specialties.length,
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              final specialty = _specialties[index];
              final isSelected = _selectedSpecialty == specialty['key'];

              return SelectableRowItem(
                imageUrl: AppAssets.brainIcon,
                label: specialty['key']!.tr(),
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    _selectedSpecialty = specialty['key'];
                  });
                  Navigator.pop(context, specialty['key']);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
