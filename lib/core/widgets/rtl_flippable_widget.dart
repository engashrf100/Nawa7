import 'package:flutter/material.dart';

class RtlFlippableWidget extends StatelessWidget {
  final Widget child;

  const RtlFlippableWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Transform.scale(scaleX: isRtl ? -1 : 1, child: child);
  }
}
