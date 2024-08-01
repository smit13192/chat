import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final double? fontSize;
  final double? height;
  final double? wordSpacing;
  final FontWeight? fontWeight;
  const CustomText(
    this.text, {
    super.key,
    this.color,
    this.maxLines,
    this.textAlign,
    this.overflow,
    this.fontSize,
    this.height,
    this.wordSpacing,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toString(),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: TextStyle(
        wordSpacing: wordSpacing,
        color: color,
        fontSize: fontSize ?? 10.5.sp,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}
