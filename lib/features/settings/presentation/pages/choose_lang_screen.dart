import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/routing/app_routes.dart';
import 'package:nawah/core/theme/app_colors.dart';
import 'package:nawah/core/theme/app_text_styles.dart';
import 'package:nawah/core/widgets/app_card.dart';
import 'package:nawah/core/widgets/selectable_row_item.dart';
import 'package:nawah/features/home/presentation/widgets/home_widgets/home_promary_button.dart';
import 'package:nawah/injection_container.dart';
import '../../../../core/widgets/background_widget00.dart';
import '../widgets/theme_lang_switcher.dart';

class ChooseLanguageScreen extends StatefulWidget {
  const ChooseLanguageScreen({Key? key}) : super(key: key);

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  final ValueNotifier<String> _selectedLang = ValueNotifier<String>('en');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.border,
      body: BackgroundWidget00(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(100.h),
              buildTopImage(),
              Gap(40.h),
              buildTitle(theme),
              Gap(30.h),
              AppCard(
                width: 329.w,
                color: theme.colorScheme.container,
                child: Column(
                  children: [
                    LangItemWidget(
                      langCode: 'en',
                      label: "english".tr(),
                      img: AppAssets.en,
                      selectedLang: _selectedLang,
                    ),
                    Gap(10.h),
                    LangItemWidget(
                      langCode: 'ar',
                      label: "arabic".tr(),
                      img: AppAssets.ar,
                      selectedLang: _selectedLang,
                    ),
                  ],
                ),
              ),
              Gap(120.h),
              Center(
                child: AppPrimaryButton(
                  title: "confirm".tr(),
                  onTap: () async {
                    Navigator.pushNamed(context, AppRoutes.theme);
                    context.setLocale(Locale(_selectedLang.value));
                    //  await resetDio();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text buildTitle(ThemeData theme) {
    return Text(
      "choose_language_title".tr(),
      style: AppTextStyles.tajawal22W700.copyWith(
        color: theme.colorScheme.text100,
      ),
      textAlign: TextAlign.right,
    );
  }

  Center buildTopImage() {
    return Center(
      child: Image.asset(AppAssets.langImg, width: 191.w, height: 226.h),
    );
  }
}

class LangItemWidget extends StatelessWidget {
  final String langCode;
  final String label;
  final String img;
  final ValueNotifier<String> selectedLang;

  const LangItemWidget({
    Key? key,
    required this.langCode,
    required this.label,
    required this.img,
    required this.selectedLang,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: selectedLang,
      builder: (_, value, __) {
        final bool isSelected = value == langCode;
        return SelectableRowItem(
          label: label,
          isSvg: true,
          isSelected: isSelected,
          imageUrl: img,
          onTap: () => selectedLang.value = langCode,
        );
      },
    );
  }
}
