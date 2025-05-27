import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:braille_app/utils/config/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BasicButton extends StatelessWidget {
  final String text;
  final VoidCallback onPress;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderSide? border;
  final BorderRadius? radius;
  final TextStyle? textStyle;

  const BasicButton({
    super.key,
    required this.text,
    required this.onPress,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.border,
    this.textStyle,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width ?? 160.w, height ?? 32.h),
        backgroundColor: backgroundColor ?? AppColors.primaryColor,
        foregroundColor: foregroundColor,
        shape: RoundedRectangleBorder(
          side: border ?? BorderSide.none,
          borderRadius: radius ?? BorderRadius.circular(10),
        ),
      ),
      child: Text(text, style: textStyle ?? AppTextStyle.smallWhite),
    );
  }
}
