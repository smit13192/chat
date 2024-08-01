import 'package:chat/src/config/constant/app_color.dart';
import 'package:chat/src/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

extension BuildContextExtension on BuildContext {
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: CustomText(
          message,
          fontSize: 12.sp,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.h)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColor.redColor,
        padding: EdgeInsets.all(2.5.h),
      ),
    );
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: CustomText(
          message,
          fontSize: 12.sp,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.h)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColor.greenColor,
        padding: EdgeInsets.all(2.5.h),
      ),
    );
  }
}
