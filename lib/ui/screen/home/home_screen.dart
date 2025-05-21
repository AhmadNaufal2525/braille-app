import 'package:braille_app/ui/screen/home/math_to_braille.dart';
import 'package:braille_app/ui/screen/home/text_plain_to_braille.dart';
import 'package:braille_app/ui/shared/label.dart';
import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isPlainToBraille = true;
  String scannedTextFromScanner = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              isPlainToBraille
                  ? Label(text: 'Plain Text')
                  : Label(text: 'Math Text'),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isPlainToBraille = true;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              isPlainToBraille
                                  ? AppColors.primaryColor
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            'Text to Braille',
                            style: TextStyle(
                              color:
                                  isPlainToBraille
                                      ? Colors.white
                                      : AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isPlainToBraille = false;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              !isPlainToBraille
                                  ? AppColors.primaryColor
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            'Math to Braille',
                            style: TextStyle(
                              color:
                                  !isPlainToBraille
                                      ? Colors.white
                                      : AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Pass scanned text to TextPlainToBraille
              isPlainToBraille
                  ? TextPlainToBraille(
                    initialScannedText: scannedTextFromScanner,
                  )
                  : const MathToBraille(),
            ],
          ),
        ),
      ),
    );
  }
}
