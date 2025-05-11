import 'package:braille_app/utils/config/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String text;
  const Label({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text, style: AppTextStyle.largeGreen),
        SizedBox(height: 8),
      ],
    );
  }
}
