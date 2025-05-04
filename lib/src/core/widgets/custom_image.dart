import 'package:chat/src/config/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  const CustomImage(this.imageUrl, {super.key, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Shimmer.fromColors(
          baseColor: AppColor.blackColor,
          highlightColor: AppColor.whiteColor.withAlpha(26),
          child: const SizedBox.shrink(),
        );
      },
    );
  }
}
