import 'package:flutter/material.dart';

class AppDecorations {
  static List<BoxShadow> dropdownShadow(BuildContext context) => [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      offset: const Offset(0, 2),
      blurRadius: 4,
    ),
  ];
}
