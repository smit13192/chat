import 'package:chat/src/config/constant/app_color.dart';
import 'package:chat/src/core/widgets/custom_button.dart';
import 'package:chat/src/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDialog extends StatelessWidget {
  final String title;
  final String message;
  const PermissionDialog({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: AppColor.blackColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomText(
              title,
              fontSize: 18,
              color: AppColor.whiteColor,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 20),
            CustomText(
              message,
              color: AppColor.whiteColor,
              fontSize: 16,
            ),
            const SizedBox(height: 20),
            Center(
              child: CustomButton(
                text: 'Open App Settings',
                onPressed: () {
                  openAppSettings();
                  context.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
