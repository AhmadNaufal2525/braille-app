import 'package:braille_app/ui/screen/home/converter.dart';
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

  bool _showMathKeyboard = false;
  String _selectedGroup = 'Algebra';

  final Map<String, List<String>> _symbolGroups = {
    'Algebra': ['+', '-', '×', '÷', '^', '^2', '='],
    'Geometry': ['√', '∠', '°', 'π'],
    'Calculus': ['∑', '∫', '∞', '≈', '≠', '≤', '≥'],
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashedTextFormField(
          hintText: 'Type here...',
          controller: mathTextController,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BasicButton(
              height: 35,
              width: 20,
              text: 'Upload File',
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColor,
              ),
              onPress: () {
                Navigator.pushNamed(context, '/document');
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _showMathKeyboard = !_showMathKeyboard;
                  });
                },
                child: Text(
                  _showMathKeyboard
                      ? 'Hide Math Keyboard'
                      : 'Show Math Keyboard',
                  style: AppTextStyle.mediumGreen,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),

        if (_showMathKeyboard) ...[
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  _symbolGroups.keys.map((group) {
                    final isSelected = _selectedGroup == group;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: BasicButton(
                        text: group,
                        height: 28,
                        width: 90,
                        textStyle:
                            isSelected
                                ? TextStyle(color: AppColors.whiteColor)
                                : AppTextStyle.smallGreenBold,
                        backgroundColor:
                            isSelected
                                ? AppColors.primaryColor
                                : AppColors.whiteColor,
                        border: BorderSide(
                          color: AppColors.primaryColor,
                          width: 1,
                        ),
                        onPress: () {
                          setState(() {
                            _selectedGroup = group;
                          });
                        },
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  _symbolGroups[_selectedGroup]!
                      .map((symbol) => _symbolButton(symbol))
                      .toList(),
            ),
          ),
          const SizedBox(height: 16),
        ],
        BasicButton(
          text: 'Translate',
          onPress: () {
            final input = mathTextController.text;
            final output = latinToBraille(input);
            brailleTextController.text = output;
          },
          height: 48,
          width: double.infinity,
          textStyle: AppTextStyle.xlargeWhiteBold,
        ),
        const SizedBox(height: 16),
        Label(text: 'Braille Text'),
        DashedTextFormField(controller: brailleTextController, readOnly: true),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BasicButton(
              text: 'Copy',
              backgroundColor: AppColors.whiteColor,
              width: 56,
              height: 28,
              border: BorderSide(color: AppColors.primaryColor, width: 1),
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
              width: 56,
              height: 28,
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
    );
  }

  Widget _symbolButton(String symbol) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: BasicButton(
        text: symbol,
        height: 32,
        width: 40,
        textStyle: AppTextStyle.smallGreenBold,
        backgroundColor: AppColors.whiteColor,
        border: BorderSide(color: AppColors.primaryColor, width: 1),
        onPress: () {
          final text = mathTextController.text;
          final selection = mathTextController.selection;
          final newText = text.replaceRange(
            selection.start,
            selection.end,
            symbol,
          );
          mathTextController.text = newText;
          mathTextController.selection = TextSelection.collapsed(
            offset: selection.start + symbol.length,
          );
        },
      ),
    );
  }
}
