import 'package:braille_app/utils/config/theme/app_theme.dart';
import 'package:braille_app/utils/routes/router.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TemaNetra',
      theme: AppTheme.theme,
      onGenerateRoute: AppRoute.onGenerateRoutes,
    );
  }
}
