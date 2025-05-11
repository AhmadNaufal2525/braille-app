import 'dart:typed_data';
import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class DashedFilePickerField extends StatefulWidget {
  const DashedFilePickerField({super.key});

  @override
  State<DashedFilePickerField> createState() => _DashedFilePickerFieldState();
}

class _DashedFilePickerFieldState extends State<DashedFilePickerField> {
  String? selectedFileName;
  Uint8List? fileBytes;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['txt', 'doc', 'docx', 'pdf'],
    );

    if (result != null) {
      setState(() {
        selectedFileName = result.files.single.name;
        fileBytes = result.files.single.bytes;
      });

      // You can process fileBytes here (like extracting text)
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickFile,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(8),
        dashPattern: [6, 3],
        strokeWidth: 1,
        color: AppColors.textBoxColor,
        child: SizedBox(
          width: double.infinity,
          height: 160,
          child: Center(
            child:
                selectedFileName == null
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.insert_drive_file_rounded,
                          size: 40,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Upload or drop document to translate',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Max File Size 10 Mb',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                    : Text(
                      selectedFileName!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
          ),
        ),
      ),
    );
  }
}
