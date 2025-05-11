import 'package:braille_app/ui/screen/home/math_to_braille.dart';
import 'package:braille_app/ui/screen/home/text_plain_to_braille.dart';
import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isPlainToBraille = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isPlainToBraille = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          isPlainToBraille
                              ? Colors.white
                              : AppColors.primaryColor,
                      minimumSize: Size(150, 50),
                      backgroundColor:
                          isPlainToBraille
                              ? AppColors.primaryColor
                              : Colors.white,
                    ),
                    child: const Text(
                      'Plain to Braille',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isPlainToBraille = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          !isPlainToBraille
                              ? Colors.white
                              : AppColors.primaryColor,
                      minimumSize: Size(150, 50),
                      backgroundColor:
                          !isPlainToBraille
                              ? AppColors.primaryColor
                              : Colors.white,
                    ),
                    child: const Text(
                      'Math to Braille',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Display the corresponding widget
              isPlainToBraille
                  ? const TextPlainToBraille()
                  : const MathToBraille(),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor, width: 4.0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/text-scanner');
          },

          backgroundColor: AppColors.whiteColor,
          elevation: 0,
          child: Icon(
            Icons.camera_alt_rounded,
            color: AppColors.primaryColor,
            size: 28,
          ),
        ),
      ),
    );
  }
}
