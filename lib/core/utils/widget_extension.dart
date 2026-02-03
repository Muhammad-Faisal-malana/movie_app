import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

extension ShimmerLoader on Widget {
  /// Wrap any widget with shimmer placeholder effect
  static Widget shimmer({double? width, double? height, BorderRadius? borderRadius}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: borderRadius ?? BorderRadius.circular(0),
        ),
      ),
    );
  }
}
