import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCachedImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final int? memCacheWidth;
  final int? memCacheHeight;

  const CustomCachedImage({
    super.key,
    required this.imageUrl,
    this.fit,
    this.height,
    this.width,
    this.memCacheWidth,
    this.memCacheHeight,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit ?? BoxFit.cover,
      width: width ?? double.infinity,
      height: height,
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) =>
          Center(child: Icon(Icons.error, size: 50, color: Colors.red)),
   
    );
  }
}
