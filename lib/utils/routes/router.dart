import 'package:braille_app/ui/screen/document/document_screen.dart';
import 'package:braille_app/ui/screen/home/home_screen.dart';
import 'package:braille_app/ui/screen/scanner/text_scanner.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static Route<dynamic>? onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(const HomeScreen());
      case '/document':
        return _materialRoute(const DocumentScreen());
      case '/text-scanner':
        return _materialRoute(const TextScanner());
      default:
        return _materialRoute(const HomeScreen());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
