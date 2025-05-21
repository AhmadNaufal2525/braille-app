import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class DashedTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool readOnly;

  const DashedTextFormField({
    super.key,
    this.controller,
    this.hintText,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Use only 25% of the screen height and estimate 1 line ≈ 24px
    final estimatedLineHeight = 36.0;
    final usableHeight = screenHeight * 0.25;
    final maxLines = (usableHeight / estimatedLineHeight).floor().clamp(1, 20);

    return DottedBorder(
      color: AppColors.textBoxColor,
      strokeWidth: 1,
      dashPattern: [6, 3],
      borderType: BorderType.RRect,
      radius: const Radius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: TextFormField(
          readOnly: readOnly,
          style: const TextStyle(fontSize: 16.0),
          maxLines: maxLines,
          controller: controller,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 14.0),
          ),
        ),
      ),
    );
  }
}
