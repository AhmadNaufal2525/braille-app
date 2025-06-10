import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:braille_app/utils/config/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardDocument extends StatelessWidget {
  final String documentName;
  final VoidCallback onPressed;
  const CardDocument({
    super.key,
    required this.documentName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80.h,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardColor,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(width: 16.w),
                Text(documentName, style: AppTextStyle.mediumGreen),
              ],
            ),
            TextButton(
              onPressed: onPressed,
              child: Text('See', style: AppTextStyle.mediumGreen),
            ),
          ],
        ),
      ),
    );
  }
}
