import 'package:chat/src/config/constant/app_color.dart';
import 'package:chat/src/core/widgets/custom_button.dart';
import 'package:chat/src/core/widgets/custom_text.dart';
import 'package:chat/src/core/widgets/gap.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

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
            const CustomText(
              'Are you sure?',
              fontSize: 18,
              color: AppColor.whiteColor,
              fontWeight: FontWeight.bold,
            ),
            GapH(2.h),
            const CustomText(
              'Are you sure you want to log out? You\'ll be disconnected from all chats.',
              color: AppColor.whiteColor,
              fontSize: 16,
            ),
            const GapH(20),
            CustomButton(
              height: 45,
              text: 'Logout',
              onPressed: () {
                context.pop(true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
