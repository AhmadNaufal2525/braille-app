import 'package:braille_app/ui/screen/document/document_screen.dart';
import 'package:braille_app/ui/screen/home/home_screen.dart';
import 'package:braille_app/utils/config/assets/app_vector.dart';
import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
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
    const DocumentScreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;
    return Scaffold(
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
            padding: EdgeInsets.only(bottom: screenHeight * 0.04),
            child: Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // Navigation Bar Background
                  Container(
                    height: screenHeight * 0.08,
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
                            height: 30,
                            width: 30,
                            child: SvgPicture.asset(AppVectors.iconHome),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.15,
                        ), // spacing around camera
                        GestureDetector(
                          onTap: () => onItemTapped(1),
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: SvgPicture.asset(AppVectors.iconBraille),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -14,
                    child: Container(
                      width: screenWidth * 0.18,
                      height: screenHeight * 0.08,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 4,
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
                          size: 36,
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
