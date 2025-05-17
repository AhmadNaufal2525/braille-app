import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class DashedTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool readOnly;

  const DashedTextFormField({
    super.key,
    required this.controller,
    this.hintText,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: AppColors.textBoxColor,
      strokeWidth: 1,
      dashPattern: [6, 3],
      borderType: BorderType.RRect,
      radius: Radius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextFormField(
          readOnly: readOnly,
          style: const TextStyle(fontSize: 16.0),
          maxLines: 5,
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 14.0),
          ),
        ),
      ),
    );
  }
}
