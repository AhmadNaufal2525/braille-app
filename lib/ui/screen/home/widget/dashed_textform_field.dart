import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final fieldHeight = screenHeight < 700 ? 0.12.sh : 0.2.sh;
    return DottedBorder(
      color: AppColors.textBoxColor,
      strokeWidth: 1.w,
      dashPattern: [6, 3],
      borderType: BorderType.RRect,
      radius: Radius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.w),
        child: SizedBox(
          height: fieldHeight,
          child: TextFormField(
            readOnly: readOnly,
            style: TextStyle(fontSize: 14.0.sp),
            controller: controller,
            maxLines: 10,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(fontSize: 14.0.sp),
            ),
          ),
        ),
      ),
    );
  }
}
