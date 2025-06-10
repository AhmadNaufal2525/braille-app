import 'package:braille_app/ui/screen/history/history_screen.dart';
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
  int selectedIndex = 0;
  List<Widget> get screens => [
    HomeScreen(scannedTextFromScanner: scannedTextFromScanner),
    HistoryScreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
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
                        GestureDetector(
                          onTap: () => onItemTapped(0),
                          child: SizedBox(
                            height: 30.h,
                            width: 30.w,
                            child: SvgPicture.asset(
                              AppVectors.iconHome,
                              colorFilter: ColorFilter.mode(
                                selectedIndex == 0
                                    ? AppColors.whiteColor
                                    : AppColors.greyColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        20.horizontalSpace,
                        GestureDetector(
                          onTap: () => onItemTapped(1),
                          child: SizedBox(
                            height: 30.h,
                            width: 30.w,
                            child: SvgPicture.asset(
                              AppVectors.iconBraille,
                              colorFilter: ColorFilter.mode(
                                selectedIndex == 1
                                    ? AppColors.whiteColor
                                    : AppColors.greyColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                          if (result != null && result is String) {
                            setState(() {
                              scannedTextFromScanner = result;
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
