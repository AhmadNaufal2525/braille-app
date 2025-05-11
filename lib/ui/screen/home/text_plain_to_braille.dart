import 'package:braille_app/ui/screen/home/widget/dashed_textform_field.dart';
import 'package:braille_app/ui/shared/basic_button.dart';
import 'package:braille_app/ui/shared/label.dart';
import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:braille_app/utils/config/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextPlainToBraille extends StatefulWidget {
  const TextPlainToBraille({super.key});

  @override
  State<TextPlainToBraille> createState() => _TextPlainToBrailleState();
}

class _TextPlainToBrailleState extends State<TextPlainToBraille> {
  final TextEditingController plainTextController = TextEditingController();
  final TextEditingController brailleTextController = TextEditingController();

  final Map<String, String> brailleMap = {
    'a': '⠁',
    'b': '⠃',
    'c': '⠉',
    'd': '⠙',
    'e': '⠑',
    'f': '⠋',
    'g': '⠛',
    'h': '⠓',
    'i': '⠊',
    'j': '⠚',
    'k': '⠅',
    'l': '⠇',
    'm': '⠍',
    'n': '⠝',
    'o': '⠕',
    'p': '⠏',
    'q': '⠟',
    'r': '⠗',
    's': '⠎',
    't': '⠞',
    'u': '⠥',
    'v': '⠧',
    'w': '⠺',
    'x': '⠭',
    'y': '⠽',
    'z': '⠵',
    ' ': ' ',
  };

  String convertToBraille(String input) {
    return input
        .toLowerCase()
        .split('')
        .map((char) {
          return brailleMap[char] ?? '?';
        })
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
          controller: plainTextController,
        ),
        const SizedBox(height: 16),
        BasicButton(
          text: 'Translate',
          onPress: () {
            final input = plainTextController.text;
            final output = convertToBraille(input);
            brailleTextController.text = output;
          },
          height: 48,
          width: 350,
          textStyle: AppTextStyle.xlargeWhiteBold,
        ),
        const SizedBox(height: 16),
        Label(text: 'Braille Text'),
        DashedTextFormField(hintText: '', controller: brailleTextController),
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
                    plainTextController.clear();
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
