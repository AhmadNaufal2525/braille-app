import 'package:braille_app/ui/screen/home/math_to_braille.dart';
import 'package:braille_app/ui/screen/home/text_plain_to_braille.dart';
import 'package:braille_app/ui/shared/label.dart';
import 'package:braille_app/utils/config/assets/app_vector.dart';
import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:braille_app/utils/config/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  final String scannedTextFromScanner;
  const HomeScreen({super.key, required this.scannedTextFromScanner});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isPlainToBraille = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SvgPicture.asset(
                  AppVectors.wellcomeVector,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height:
                      MediaQuery.of(context).size.height < 700 ? 120.h : 130.h,
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi Teman',
                          style:
                              MediaQuery.of(context).size.height < 700
                                  ? AppTextStyle.mediumWhite
                                  : AppTextStyle.largeWhite,
                        ),
                        Text(
                          'Selamat Datang',
                          style: AppTextStyle.xxlargeWhite.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            width: 320.w,
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color:
                                  isPlainToBraille
                                      ? AppColors.primaryColor
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(30).r,
                            ),
                            child: Center(
                              child: Text(
                                'Text to Braille',
                                style: TextStyle(
                                  fontSize: 12.0.sp,
                                  color:
                                      isPlainToBraille
                                          ? Colors.white
                                          : AppColors.primaryColor,
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
                            width: 320.w,
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
                                  fontSize: 12.0.sp,
                                  color:
                                      !isPlainToBraille
                                          ? Colors.white
                                          : AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  20.verticalSpace,
                  // Pass scanned text to TextPlainToBraille
                  isPlainToBraille
                      ? TextPlainToBraille(
                        initialScannedText: widget.scannedTextFromScanner,
                      )
                      : const MathToBraille(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
