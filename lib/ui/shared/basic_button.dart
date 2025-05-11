import 'package:braille_app/utils/config/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class BasicButton extends StatelessWidget {
  final String text;
  final VoidCallback onPress;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderSide? border;
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
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width ?? 160, height ?? 32),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        side: border,
      ),
      child: Text(text, style: textStyle ?? AppTextStyle.smallWhite),
    );
  }
}
