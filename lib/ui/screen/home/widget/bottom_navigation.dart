import 'package:braille_app/ui/screen/history/history_screen.dart';
import 'package:braille_app/ui/screen/home/converter.dart';
import 'package:braille_app/ui/screen/home/home_screen.dart';
import 'package:braille_app/utils/config/assets/app_vector.dart';
import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  String scannedTextFromScanner = '';
  String brailleText = '';
  int selectedIndex = 0;
  List<Widget> get screens => [
    HomeScreen(scannedTextFromScanner: scannedTextFromScanner, initalBrailleText: brailleText),
    HistoryScreen(),
  ];

  void onItemTapped(int index) async {
    if (index == 1) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HistoryScreen()),
      );
      
      if (result != null && result is Map<String, dynamic>) {
        setState(() {
          scannedTextFromScanner = result['text'];
          brailleText = result['braille'];
          selectedIndex = 0; // Switch back to home screen
        });
      }
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(child: screens.elementAt(selectedIndex)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 30.r),
            child: Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // Navigation Bar Background
                  Container(
                    height: 52.h,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNavItem(0, 'Home', AppVectors.iconHome),
                        Positioned(
                          top: -14,
                          child: Container(
                            width: 72.w,
                            height: 67.h,
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              border: Border.all(
                                color: AppColors.primaryColor,
                                width: 4.w,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              onPressed: () async {
                                final result = await Navigator.pushNamed(
                                  context,
                                  '/text-scanner',
                                );
                                if (result != null && result is Map<String, dynamic>) {
                                  setState(() {
                                    scannedTextFromScanner = result['text'];
                                    brailleText = result['braille'];
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.camera_alt_rounded,
                                color: AppColors.primaryColor,
                                size: 36.sp,
                              ),
                            ),
                          ),
                        ),
                        _buildNavItem(1, 'History', AppVectors.iconBraille),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label, String icon) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => onItemTapped(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 24.w,
              height: 24.h,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : Colors.white.withOpacity(0.5),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
