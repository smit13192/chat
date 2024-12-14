import 'dart:async';

import 'package:chat/src/config/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Refresh extends StatelessWidget {
  final FutureOr<void> Function()? onRefresh;
  const Refresh({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          splashColor: AppColor.blackColor.withAlpha(26),
          highlightColor: AppColor.blackColor.withAlpha(13),
          onTap: () => onRefresh?.call(),
          child: Padding(
            padding: EdgeInsets.all(1.h),
            child: const Icon(
              Icons.refresh_sharp,
              color: AppColor.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
