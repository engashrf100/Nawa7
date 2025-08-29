import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({super.key});
  
  @override
  Widget build(BuildContext context) =>
      Center(child: Text('doctors_screen_title'.tr()));
}
