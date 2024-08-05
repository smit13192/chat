import 'package:chat/src/config/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Color buttonColor;
  final double height;
  final double? width;
  final double elevation;
  final BorderRadius? borderRadius;
  final Border? border;
  final EdgeInsets? padding;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.buttonColor = AppColor.primaryColor,
    this.height = 54.0,
    this.width,
    this.elevation = 3,
    this.borderRadius,
    this.border,
    this.textStyle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      color: buttonColor,
      child: InkWell(
        highlightColor: AppColor.transparent,
        splashColor: AppColor.buttonSplashColor,
        onTap: onPressed,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: padding,
          height: height,
          width: width,
          decoration: BoxDecoration(
            border: border,
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: textStyle ??
                TextStyle(
                  color: AppColor.whiteColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 13.sp,
                  letterSpacing: 1,
                ),
          ),
        ),
      ),
    );
  }
}
