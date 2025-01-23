import 'package:chat/src/config/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String? value)? validator;
  final void Function()? onTap;
  final double borderRadius;
  final String? hintText;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final int? minLines;
  final int maxLines;
  final bool readOnly;
  final bool? enabled;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final BoxConstraints? suffixIconConstraints;
  final void Function(String value)? onSubmitted;

  const CustomFormField({
    super.key,
    this.controller,
    this.keyboardType,
    this.validator,
    this.onTap,
    this.borderRadius = 8,
    this.hintText,
    this.initialValue,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.minLines,
    this.maxLines = 1,
    this.readOnly = false,
    this.enabled,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.suffixIconConstraints,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines,
      onFieldSubmitted: onSubmitted,
      style: TextStyle(color: AppColor.whiteColor.withAlpha(229)),
      textCapitalization: textCapitalization,
      keyboardAppearance: Brightness.dark,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColor.whiteColor.withAlpha(128)),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        enabledBorder: getInputBorder(),
        disabledBorder: getInputBorder(),
        focusedBorder: getInputBorder(),
        errorBorder: getInputBorder(
          borderColor: AppColor.redColor.withAlpha(178),
        ),
        suffixIconConstraints: suffixIconConstraints,
        errorStyle: TextStyle(
          color: AppColor.redColor.withAlpha(178),
          fontSize: 10.sp,
        ),
        focusedErrorBorder: getInputBorder(
          borderColor: AppColor.redColor.withAlpha(178),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColor.whiteColor.withAlpha(5),
      ),
    );
  }

  InputBorder getInputBorder({Color? borderColor}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(
        color: borderColor ?? AppColor.whiteColor.withAlpha(51),
        width: 1.5,
      ),
    );
  }
}
