import 'package:braille_app/ui/screen/home/widget/bottom_navigation.dart';
import 'package:braille_app/ui/screen/onboard/widget/first_page_onboard.dart';
import 'package:braille_app/ui/screen/onboard/widget/second_page_onboard.dart';
import 'package:braille_app/ui/screen/onboard/widget/third_page_onboard.dart';
import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

int introduction = 0;

class OnboardScreen extends StatefulWidget {
  final String title;
  const OnboardScreen({super.key, required this.title});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

Future initIntroduction() async {
  final prefs = await SharedPreferences.getInstance();

  int? intro = prefs.getInt('introduction');
  if (intro != null && intro == 1) {
    return introduction = 1;
  }
  prefs.setInt('introduction', 1);
}

Future<void> completeOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('introduction', 1);
}

class _OnboardScreenState extends State<OnboardScreen> {
  final PageController controller = PageController(initialPage: 0);
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        onPageChanged: (int page) {
          setState(() {
            currentPage = page;
          });
        },
        children: [
          //First Onboarding Page
          FirstPageOnboard(currentPage: currentPage),
          //Second Onboarding
          SecondPageOnboard(currentPage: currentPage),
          //Third Onboarding
          ThirdPageOnboard(currentPage: currentPage),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 0.r,
        onPressed: () {
          if (currentPage == 2) {
            completeOnboarding();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavigation()),
            );
          } else {
            controller.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          }
        },
        child: Container(
          width: 56.w,
          height: 56.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryColor, Color(0xFF1C3437)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.play_arrow_rounded,
            color: AppColors.whiteColor,
            size: 32.sp,
          ),
        ),
      ),
    );
  }
}
