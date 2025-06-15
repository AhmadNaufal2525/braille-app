import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:braille_app/ui/screen/home/converter.dart';
import 'package:braille_app/ui/screen/home/widget/dashed_textform_field.dart';
import 'package:braille_app/ui/shared/basic_button.dart';
import 'package:braille_app/ui/shared/label.dart';
import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:braille_app/utils/config/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class TextPlainToBraille extends StatefulWidget {
  final String initialScannedText;
  final String initialBrailleText;
  const TextPlainToBraille({
    super.key, 
    required this.initialScannedText,
    required this.initialBrailleText,
  });

  @override
  State<TextPlainToBraille> createState() => _TextPlainToBrailleState();
}

class _TextPlainToBrailleState extends State<TextPlainToBraille> {
  late TextEditingController plainTextController;
  late TextEditingController brailleTextController;

  @override
  void initState() {
    super.initState();
    plainTextController = TextEditingController(
      text: widget.initialScannedText,
    );
    brailleTextController = TextEditingController(
      text: widget.initialBrailleText,
    );
  }

  @override
  void didUpdateWidget(covariant TextPlainToBraille oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialScannedText != widget.initialScannedText) {
      plainTextController.text = widget.initialScannedText;
    }
    if (oldWidget.initialBrailleText != widget.initialBrailleText) {
      brailleTextController.text = widget.initialBrailleText;
    }
  }

  @override
  void dispose() {
    plainTextController.dispose();
    brailleTextController.dispose();
    super.dispose();
  }

  void convertBraille(String plainText) async {
    final input = plainText;
    final output = await latinToBraille(input);
    brailleTextController.text = output;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashedTextFormField(
          hintText: 'Type here...',
          controller: plainTextController,
        ),
        10.verticalSpace,
        BasicButton(
          height: 35.h,
          width: 160.w,
          text: 'Upload File',
          textStyle: AppTextStyle.smallWhite.copyWith(
            fontWeight: FontWeight.bold,
          ),
          onPress: () {
            Navigator.pushNamed(context, '/document');
          },
        ),
        10.verticalSpace,
        BasicButton(
          text: 'Convert to Braille',
          onPress: () async {
            final input = plainTextController.text;
            final output = await latinToBraille(input);
            brailleTextController.text = output;
          },
          height: 48.h,
          width: double.infinity,
          textStyle: AppTextStyle.xlargeWhiteBold,
        ),
        20.verticalSpace,
        Label(text: 'Braille Text'),
        DashedTextFormField(controller: brailleTextController, readOnly: true),
        10.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BasicButton(
              text: 'Copy',
              backgroundColor: AppColors.whiteColor,
              width: 56.w,
              height: MediaQuery.of(context).size.height < 700 ? 30.h : 24.h,
              border: BorderSide(color: AppColors.primaryColor, width: 1.w),
              textStyle: AppTextStyle.smallGreenBold,
              onPress: () {
                Clipboard.setData(
                  ClipboardData(text: brailleTextController.text),
                );
              },
            ),
            BasicButton(
              text: 'Save as doc',
              backgroundColor: AppColors.whiteColor,
              width: 56.w,
              height: MediaQuery.of(context).size.height < 700 ? 30.h : 24.h,
              border: BorderSide(color: AppColors.primaryColor, width: 1.w),
              textStyle: AppTextStyle.smallGreenBold,
              onPress: () {
                final brailleText = brailleTextController.text;
                exportAsDocx(brailleText);
              },
            ),
            BasicButton(
              text: 'Reset',
              backgroundColor: AppColors.whiteColor,
              width: 56.w,
              height: MediaQuery.of(context).size.height < 700 ? 30.h : 24.h,
              border: BorderSide(color: AppColors.primaryColor, width: 1.w),
              textStyle: AppTextStyle.smallGreenBold,
              onPress: () {
                brailleTextController.clear();
                plainTextController.clear();
              },
            ),
          ],
        ),
        30.verticalSpace,
      ],
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
