import 'package:flutter/services.dart';

void configureSystemUI() {
  /* SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: colors,
        systemNavigationBarColor: AppColors.white,
        systemNavigationBarDividerColor: AppColors.white),
  );*/
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
}
