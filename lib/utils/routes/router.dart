import 'package:braille_app/ui/screen/document/document_screen.dart';
import 'package:braille_app/ui/screen/home/home_screen.dart';
import 'package:braille_app/ui/screen/onboard/onboard_screen.dart';
import 'package:braille_app/ui/screen/scanner/text_scanner.dart';
import 'package:braille_app/ui/screen/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static Route<dynamic>? onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(SplashScreen());
      case '/onboard':
        final title = settings.arguments as String;
        return _materialRoute(OnboardScreen(title: title));
      case '/home':
        final scannedTextFromScanner = settings.arguments as String;
        return _materialRoute(
          HomeScreen(scannedTextFromScanner: scannedTextFromScanner, initalBrailleText: ''),
        );
      case '/document':
        return _materialRoute(const DocumentScreen());
      case '/text-scanner':
        return _materialRoute(const TextScanner());
      default:
        final scannedTextFromScanner = settings.arguments as String;
        return _materialRoute(
          HomeScreen(scannedTextFromScanner: scannedTextFromScanner, initalBrailleText: ''),
        );
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
