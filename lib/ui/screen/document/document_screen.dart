import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
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
                    child:
                        plainTextController.text.isEmpty
                            ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.insert_drive_file_rounded,
                                  size: 40.sp,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Upload or drop document to translate',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Max File Size 10 Mb',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                            : SingleChildScrollView(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BasicButton(
                    text: 'Copy',
                    backgroundColor: AppColors.whiteColor,
                    width: 56.w,
                    height:
                        MediaQuery.of(context).size.height < 700 ? 30.h : 24.h,
                    border: BorderSide(
                      color: AppColors.primaryColor,
                      width: 1.w,
                    ),
                    textStyle: AppTextStyle.smallGreenBold,
                    onPress: () {
                      Clipboard.setData(ClipboardData(text: brailleText));
                    },
                  ),
                  BasicButton(
                    text: 'Save as doc',
                    backgroundColor: AppColors.whiteColor,
                    width: 56.w,
                    height:
                        MediaQuery.of(context).size.height < 700 ? 30.h : 24.h,
                    border: BorderSide(
                      color: AppColors.primaryColor,
                      width: 1.w,
                    ),
                    textStyle: AppTextStyle.smallGreenBold,
                    onPress: () {
                      copyToClipboard(brailleText);
                    },
                  ),
                  BasicButton(
                    text: 'Reset',
                    backgroundColor: AppColors.whiteColor,
                    width: 56.w,
                    height:
                        MediaQuery.of(context).size.height < 700 ? 30.h : 24.h,
                    border: BorderSide(
                      color: AppColors.primaryColor,
                      width: 1.w,
                    ),
                    textStyle: AppTextStyle.smallGreenBold,
                    onPress: () {
                      brailleText = '';
                      plainTextController.clear();
                    },
                  ),
                ],
              ),
              30.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> exportAsDocx(String brailleText) async {
  final escapedText = _xmlEscape(brailleText);

  /* ───────── document.xml (with fallback fonts) ───────── */
  final documentXml = '''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>
    <w:p>
      <w:r>
        <w:rPr>
          <w:rFonts w:ascii="SimBraille,Segoe UI Symbol,DejaVu Sans Mono"
                    w:hAnsi="SimBraille,Segoe UI Symbol,DejaVu Sans Mono"
                    w:cs="SimBraille,Segoe UI Symbol,DejaVu Sans Mono"/>
        </w:rPr>
        <w:t xml:space="preserve">$escapedText</w:t>
      </w:r>
    </w:p>
  </w:body>
</w:document>
''';

  /* ───────── other fixed parts ───────── */
  const contentTypesXml = '''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml"
            ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
</Types>
''';

  const relsXml = '''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1"
                Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument"
                Target="word/document.xml"/>
</Relationships>
''';

  /* ───────── build archive with UTF-8 bytes ───────── */
  final archive =
      Archive()
        ..addFile(_toFile('word/document.xml', documentXml))
        ..addFile(_toFile('[Content_Types].xml', contentTypesXml))
        ..addFile(_toFile('_rels/.rels', relsXml));

  final bytes = ZipEncoder().encode(archive)!;

  /* ───────── save & share ───────── */
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/braille_output.docx');
  await file.writeAsBytes(bytes, flush: true);

  await Share.shareXFiles([XFile(file.path)], text: 'Braille output document');
}

/* helper: encode to UTF-8 and create ArchiveFile with correct length */
ArchiveFile _toFile(String name, String xml) {
  final utf8Bytes = utf8.encode(xml);
  return ArchiveFile(name, utf8Bytes.length, Uint8List.fromList(utf8Bytes));
}

/* basic XML escaper */
String _xmlEscape(String s) => s
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&apos;');
