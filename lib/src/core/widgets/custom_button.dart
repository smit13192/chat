import 'package:chat/src/config/constant/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Color buttonColor;
  final Color? highlightColor;
  final Color? splashColor;
  final double height;
  final double? width;
  final double elevation;
  final BorderRadius? borderRadius;
  final Border? border;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.buttonColor = AppColor.primaryColor,
    this.highlightColor,
    this.splashColor,
    this.height = 54.0,
    this.width,
    this.elevation = 3,
    this.borderRadius,
    this.border,
    this.textStyle,
    this.padding,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      color: buttonColor,
      child: InkWell(
        highlightColor: highlightColor ?? AppColor.transparent,
        splashColor: splashColor ?? AppColor.buttonSplashColor,
        onTap: isLoading ? null : onPressed,
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
          child: isLoading
              ? const Center(
                  child: CupertinoActivityIndicator(color: AppColor.whiteColor),
                )
              : Text(
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
