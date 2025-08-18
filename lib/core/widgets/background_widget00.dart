import 'package:flutter/material.dart';
import 'package:nawah/core/const/app_assets.dart';

class BackgroundWidget00 extends StatelessWidget {
  final Widget child;

  const BackgroundWidget00({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.bg01),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
