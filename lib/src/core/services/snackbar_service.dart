import 'package:chat/src/config/constant/app_color.dart';
import 'package:chat/src/core/utils/snackbar_controller.dart';
import 'package:flutter/material.dart';

class SnackBarService {
  static void showErrorSnackBar(String message) {
    SnackbarController.dismissAll();
    SnackbarController.showSnackbar(
      message: message,
      icon: Icons.error,
      backgroundColor: AppColor.redColor,
    );
  }

  static void showSuccessSnackBar(String message) {
    SnackbarController.dismissAll();
    SnackbarController.showSnackbar(
      message: message,
      icon: Icons.check_circle_rounded,
      backgroundColor: AppColor.greenColor,
    );
  }
}
