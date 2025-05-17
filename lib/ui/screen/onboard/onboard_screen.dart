import 'package:braille_app/ui/screen/home/widget/bottom_navigation.dart';
import 'package:braille_app/ui/screen/onboard/widget/first_page_onboard.dart';
import 'package:braille_app/ui/screen/onboard/widget/second_page_onboard.dart';
import 'package:braille_app/ui/screen/onboard/widget/third_page_onboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

int introduction = 0;

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

Future initIntroduction() async {
  final prefs = await SharedPreferences.getInstance();

  int? intro = prefs.getInt('introduction');
  print('intro : $intro');
  if (intro != null && intro == 1) {
    return introduction = 1;
  }
  prefs.setInt('introduction', 1);
}

class _OnboardScreenState extends State<OnboardScreen> {
  final PageController controller = PageController(initialPage: 0);
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        onPageChanged: (int page) {
          setState(() {
            currentPage = page;
          });
        },
        children: [
          //First Onboarding Page
          FirstPageOnboard(
            currentPage: currentPage,
            onNext: () {
              controller.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            },
          ),
          //Second Onboarding
          SecondPageOnboard(
            currentPage: currentPage,
            onNext: () {
              controller.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            },
          ),
          //Third Onboarding
          ThirdPageOnboard(
            currentPage: currentPage,
            onNext: () async {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const BottomNavigation(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
