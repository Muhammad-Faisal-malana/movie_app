import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_app/core/utils/widget_extension.dart';
import 'package:flutter/material.dart';


extension CachedImageWithShimmer on CachedNetworkImage {
  static CachedNetworkImage buildWithShimmer({
    required String imageUrl,
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
    BorderRadius? borderRadius,
  }) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      placeholder: (context, url) => ShimmerLoader.shimmer(
        width: width,
        height: height,
        borderRadius: borderRadius,
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: borderRadius ?? BorderRadius.zero,
        ),
        child: const Icon(Icons.error, color: Colors.red),
      ),
    );
  }
}
