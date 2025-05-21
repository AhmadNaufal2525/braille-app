import 'package:braille_app/utils/config/theme/app_theme.dart';
import 'package:braille_app/utils/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
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
