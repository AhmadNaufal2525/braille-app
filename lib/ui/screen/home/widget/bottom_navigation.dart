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
  final List<Widget> screens = [HomeScreen(), DocumentScreen()];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          // Floating Bottom Navigation Bar
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0), // space from bottom
            child: Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Container(
                height: 70,
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                ), // horizontal margin for floating feel
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
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
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: SvgPicture.asset(AppVectors.iconHome),
                      ),
                      onTap: () => onItemTapped(0),
                    ),
                    const SizedBox(width: 60),
                    GestureDetector(
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: SvgPicture.asset(AppVectors.iconBraille),
                      ),
                      onTap: () => onItemTapped(1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor, width: 6.0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.pushNamed(context, '/text-scanner');
            if (result != null && result is String) {
              setState(() {
                scannedTextFromScanner = result;
              });
            }
          },
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
          child: Icon(
            Icons.camera_alt_rounded,
            color: AppColors.primaryColor,
            size: 34,
          ),
        ),
      ),
    );
  }
}
