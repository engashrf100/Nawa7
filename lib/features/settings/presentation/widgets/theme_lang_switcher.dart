import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:nawah/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nawah/features/settings/presentation/cubit/settings_state.dart';

Widget buildThemeLangFab({required BuildContext context}) {
  return FloatingActionButton.extended(
    backgroundColor: Theme.of(context).colorScheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    onPressed: () {},
    label: const ThemeLangSwitcher(),
  );
}

class ThemeLangSwitcher extends StatelessWidget {
  const ThemeLangSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appCubit = context.read<SettingsCubit>();

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final isDark = state.themeMode == AppThemeMode.dark;
        final isArabic = context.locale.languageCode == 'ar';

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SmallCircleButton(
              icon: isDark ? Icons.dark_mode : Icons.light_mode,

              onPressed: () => appCubit.toggleTheme(),
            ),
            const SizedBox(width: 6),
            _SmallCircleButton(
              icon: Icons.language,
              label: isArabic ? 'AR' : 'EN',
              onPressed: () {
                final newLocale = isArabic
                    ? const Locale('en')
                    : const Locale('ar');
                context.setLocale(newLocale);
              },
            ),
            const SizedBox(width: 6),

            _SmallCircleButton(
              icon: Icons.logout,
              onPressed: () {
                context.read<SettingsCubit>().resetAppPreferences();
              },
            ),
          ],
        );
      },
    );
  }
}

class _SmallCircleButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onPressed;

  const _SmallCircleButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: Theme.of(
          context,
        ).colorScheme.onPrimary.withOpacity(0.1),
        child: label == null
            ? Icon(
                icon,
                size: 18,
                color: Theme.of(context).colorScheme.onPrimary,
              )
            : Text(
                label!,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
