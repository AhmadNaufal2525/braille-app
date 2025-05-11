import 'package:braille_app/ui/screen/home/widget/dashed_textform_field.dart';
import 'package:braille_app/ui/shared/basic_button.dart';
import 'package:braille_app/ui/shared/label.dart';
import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:braille_app/utils/config/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MathToBraille extends StatefulWidget {
  const MathToBraille({super.key});

  @override
  State<MathToBraille> createState() => _MathToBrailleState();
}

class _MathToBrailleState extends State<MathToBraille> {
  final TextEditingController mathTextController = TextEditingController();
  final TextEditingController brailleTextController = TextEditingController();

  final Map<String, String> mathBrailleMap = {
    '0': '⠴',
    '1': '⠂',
    '2': '⠆',
    '3': '⠒',
    '4': '⠲',
    '5': '⠢',
    '6': '⠖',
    '7': '⠶',
    '8': '⠦',
    '9': '⠔',
    '+': '⠖',
    '-': '⠤',
    '*': '⠡',
    '/': '⠌',
    '=': '⠶',
    '(': '⠷',
    ')': '⠾',
    ' ': ' ',
  };

  String convertToBraille(String input) {
    return input
        .split('')
        .map((char) => mathBrailleMap[char] ?? '?') // unknown chars → ?
        .join('');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(text: 'Plain Text'),
        DashedTextFormField(
          hintText: 'Type here...',
          controller: mathTextController,
        ),
        const SizedBox(height: 16),
        BasicButton(
          text: 'Convert',
          onPress: () {
            final input = mathTextController.text;
            final output = convertToBraille(input);
            brailleTextController.text = output;
          },
          height: 48,
          width: 350,
          textStyle: AppTextStyle.xlargeWhitekBold,
        ),
        const SizedBox(height: 16),
        Label(text: 'Braille Text'),
        DashedTextFormField(controller: brailleTextController),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                BasicButton(
                  text: 'Scan Document',
                  onPress: () {
                    Navigator.pushNamed(context, '/document');
                  },
                ),
              ],
            ),
            Row(
              children: [
                BasicButton(
                  text: 'Copy',
                  backgroundColor: AppColors.whiteColor,
                  width: 56,
                  height: 24,
                  border: BorderSide(color: AppColors.primaryColor, width: 1),
                  textStyle: AppTextStyle.smallGreenBold,
                  onPress: () {
                    Clipboard.setData(
                      ClipboardData(text: brailleTextController.text),
                    );
                  },
                ),
                SizedBox(width: 10),
                BasicButton(
                  text: 'Reset',
                  backgroundColor: AppColors.whiteColor,
                  width: 56,
                  height: 24,
                  border: BorderSide(color: AppColors.primaryColor, width: 1),
                  textStyle: AppTextStyle.smallGreenBold,
                  onPress: () {
                    brailleTextController.clear();
                    mathTextController.clear();
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
