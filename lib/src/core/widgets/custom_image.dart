import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/src/config/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  const CustomImage(
    this.imageUrl, {
    super.key,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      placeholder: (context, url) {
        return Shimmer.fromColors(
          baseColor: AppColor.blackColor,
          highlightColor: AppColor.whiteColor.withOpacity(0.10),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}
