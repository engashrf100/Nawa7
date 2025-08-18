import 'package:flutter/material.dart';
import 'package:nawah/core/const/app_assets.dart';
import 'package:nawah/core/const/app_keys.dart';

class LogoWidget extends StatelessWidget {
  final double width;
  final double height;
  final BoxFit? fit;

  const LogoWidget({
    super.key,
    required this.width,
    required this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: AppKeys.logoTag,
      createRectTween: (begin, end) => RectTween(begin: begin, end: end),
      flightShuttleBuilder:
          (
            flightContext,
            animation,
            flightDirection,
            fromHeroContext,
            toHeroContext,
          ) {
            return RotationTransition(
              turns: animation,
              child: toHeroContext.widget,
            );
          },
      placeholderBuilder: (context, heroSize, child) {
        return Opacity(opacity: 0.5, child: child);
      },
      transitionOnUserGestures: true,
      child: Image.asset(
        AppAssets.logo,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}
