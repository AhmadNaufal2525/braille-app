import 'package:braille_app/ui/screen/home/converter.dart';
import 'package:braille_app/ui/screen/home/widget/dashed_textform_field.dart';
import 'package:braille_app/ui/shared/basic_button.dart';
import 'package:braille_app/ui/shared/label.dart';
import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:braille_app/utils/config/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextPlainToBraille extends StatefulWidget {
  final String initialScannedText;
  const TextPlainToBraille({super.key, required this.initialScannedText});

  @override
  State<TextPlainToBraille> createState() => _TextPlainToBrailleState();
}

class _TextPlainToBrailleState extends State<TextPlainToBraille> {
  late TextEditingController plainTextController;
  final TextEditingController brailleTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    plainTextController = TextEditingController(
      text: widget.initialScannedText,
    );
  }

  @override
  void didUpdateWidget(covariant TextPlainToBraille oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialScannedText != widget.initialScannedText) {
      plainTextController.text = widget.initialScannedText;
    }
  }

  @override
  void dispose() {
    plainTextController.dispose();
    brailleTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashedTextFormField(
          hintText: 'Type here...',
          controller: plainTextController,
        ),
        10.verticalSpace,
        BasicButton(
          height: 35.h,
          width: 20.w,
          text: 'Upload File',
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor,
          ),
          onPress: () {
            Navigator.pushNamed(context, '/document');
          },
        ),
        10.verticalSpace,
        BasicButton(
          text: 'Translate',
          onPress: () {
            final input = plainTextController.text;
            final output = latinToBraille(input);
            brailleTextController.text = output;
          },
          height: 48.h,
          width: double.infinity,
          textStyle: AppTextStyle.xlargeWhiteBold,
        ),
        20.verticalSpace,
        Label(text: 'Braille Text'),
        DashedTextFormField(controller: brailleTextController, readOnly: true),
        10.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BasicButton(
              text: 'Copy',
              backgroundColor: AppColors.whiteColor,
              width: 56.w,
              height: 30.h,
              border: BorderSide(color: AppColors.primaryColor, width: 1.w),
              textStyle: AppTextStyle.smallGreenBold,
              onPress: () {
                Clipboard.setData(
                  ClipboardData(text: brailleTextController.text),
                );
              },
            ),
            BasicButton(
              text: 'Reset',
              backgroundColor: AppColors.whiteColor,
              width: 56.w,
              height: 30.h,
              border: BorderSide(color: AppColors.primaryColor, width: 1.w),
              textStyle: AppTextStyle.smallGreenBold,
              onPress: () {
                brailleTextController.clear();
                plainTextController.clear();
              },
            ),
          ],
        ),
      ],
    );
  }
}
