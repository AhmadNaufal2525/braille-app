import 'dart:async';
import 'package:braille_app/ui/screen/home/widget/bottom_navigation.dart';
import 'package:braille_app/ui/screen/onboard/onboard_screen.dart';
import 'package:braille_app/utils/config/assets/app_vector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    openSplashScreen();
    initIntroduction();
  }

  openSplashScreen() async {
    var durasiSplash = const Duration(seconds: 2);
    return Timer(durasiSplash, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) {
            return introduction == 0
                ? const OnboardScreen(title: 'Introduction')
                : BottomNavigation();
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 150,
          width: 150,
          child: SvgPicture.asset(AppVectors.logo),
        ),
      ),
    );
  }
}
