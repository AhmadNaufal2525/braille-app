import 'package:braille_app/ui/screen/document/widget/dashed_file_form.dart';
import 'package:braille_app/ui/screen/home/widget/dashed_textform_field.dart';
import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:braille_app/utils/config/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  final TextEditingController brailleTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Choose Document', style: AppTextStyle.largeGreen),
              const SizedBox(height: 8),
              DashedFilePickerField(),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () {}, child: const Text('Scan')),
              const SizedBox(height: 16),
              Text('Braille Text', style: AppTextStyle.largeGreen),
              const SizedBox(height: 8),
              DashedTextFormField(
                hintText: '',
                controller: brailleTextController,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: brailleTextController.text),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.whiteColor,
                          minimumSize: const Size(56, 24),
                          side: BorderSide(
                            color: AppColors.primaryColor,
                            width: 1,
                          ),
                        ),
                        child: const Text(
                          'Copy',
                          style: AppTextStyle.smallGreenBold,
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          brailleTextController.clear();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.whiteColor,
                          minimumSize: const Size(56, 24),
                          side: BorderSide(
                            color: AppColors.primaryColor,
                            width: 1,
                          ),
                        ),
                        child: const Text(
                          'Reset',
                          style: AppTextStyle.smallGreenBold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
