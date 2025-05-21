import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:file_picker/file_picker.dart';
import 'package:braille_app/ui/shared/basic_button.dart';
import 'package:braille_app/ui/shared/label.dart';
import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:braille_app/utils/config/theme/app_text_style.dart';
import 'package:braille_app/ui/screen/home/converter.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  final TextEditingController plainTextController = TextEditingController();
  String brailleText = '';

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt'],
    );

    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      final extension = filePath.split('.').last.toLowerCase();

      if (extension == 'pdf') {
        final bytes = File(filePath).readAsBytesSync();
        final PdfDocument document = PdfDocument(inputBytes: bytes);
        final extractor = PdfTextExtractor(document);
        final StringBuffer buffer = StringBuffer();

        for (int i = 0; i < document.pages.count; i++) {
          final pageText = extractor.extractText(
            startPageIndex: i,
            endPageIndex: i,
          );
          buffer.writeln(pageText);
          buffer.writeln('\n');
        }

        document.dispose();

        setState(() {
          plainTextController.text = _cleanText(buffer.toString());
          brailleText = '';
        });
      } else if (extension == 'txt') {
        final String content = await File(filePath).readAsString();
        setState(() {
          plainTextController.text = content.trim();
          brailleText = '';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unsupported file format")),
        );
      }
    }
  }

  String _cleanText(String text) {
    return text
        .replaceAll(RegExp(r'[ \t]+'), ' ')
        .replaceAll(RegExp(r'\n{2,}'), '\n\n')
        .trim();
  }

  void convertToBraille() {
    setState(() {
      brailleText = latinToBraille(plainTextController.text);
    });
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Copied to clipboard")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Label(text: 'Choose Document'),
              const SizedBox(height: 12),
              BasicButton(
                textStyle: TextStyle(
                  fontSize: 14.0,
                  color: AppColors.whiteColor,
                ),
                text: 'Select PDF or TXT',
                onPress: pickFile,
                width: double.infinity,
                height: 48,
              ),
              const SizedBox(height: 18),
              Expanded(
                child: DottedBorder(
                  color: AppColors.blackColor,
                  strokeWidth: 1,
                  dashPattern: [6, 3],
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      child: TextField(
                        controller: plainTextController,
                        style: AppTextStyle.mediumBlack,
                        maxLines: null,
                        decoration: const InputDecoration.collapsed(
                          hintText: 'No text extracted.',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: BasicButton(
                  text: 'Copy',
                  backgroundColor: AppColors.whiteColor,
                  width: 56,
                  height: 28,
                  border: BorderSide(color: AppColors.primaryColor, width: 1),
                  textStyle: AppTextStyle.smallGreenBold,
                  onPress: () {
                    copyToClipboard(plainTextController.text);
                  },
                ),
              ),
              BasicButton(
                text: 'Convert to Braille',
                textStyle: TextStyle(
                  fontSize: 14.0,
                  color: AppColors.whiteColor,
                ),
                onPress: convertToBraille,
                width: double.infinity,
                height: 48,
              ),
              const SizedBox(height: 12),
              const Label(text: 'Braille Text'),
              Expanded(
                child: DottedBorder(
                  color: AppColors.blackColor,
                  strokeWidth: 1,
                  dashPattern: [6, 3],
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      child: Text(
                        brailleText.isEmpty
                            ? 'No braille text yet.'
                            : brailleText,
                        style: AppTextStyle.mediumBlack,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: BasicButton(
                  text: 'Copy',
                  backgroundColor: AppColors.whiteColor,
                  width: 56,
                  height: 28,
                  border: BorderSide(color: AppColors.primaryColor, width: 1),
                  textStyle: AppTextStyle.smallGreenBold,
                  onPress: () {
                    copyToClipboard(brailleText);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
