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

class MathToBraille extends StatefulWidget {
  const MathToBraille({super.key});

  @override
  State<MathToBraille> createState() => _MathToBrailleState();
}

class _MathToBrailleState extends State<MathToBraille> {
  final TextEditingController mathTextController = TextEditingController();
  final TextEditingController brailleTextController = TextEditingController();

  bool _showMathKeyboard = false;
  String _selectedGroup = 'Algebra';

  final Map<String, List<String>> _symbolGroups = {
    'Algebra': ['+', '-', '×', '÷', '^', '^2', '='],
    'Geometry': ['√', '∠', '°', 'π'],
    'Calculus': ['∑', '∫', '∞', '≈', '≠', '≤', '≥'],
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashedTextFormField(
          hintText: 'Type here...',
          controller: mathTextController,
        ),
        10.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _showMathKeyboard = !_showMathKeyboard;
                  });
                },
                child: Text(
                  _showMathKeyboard
                      ? 'Hide Math Keyboard'
                      : 'Show Math Keyboard',
                  style:
                      MediaQuery.of(context).size.height < 700
                          ? AppTextStyle.xSmallGreen
                          : AppTextStyle.smallGreen,
                ),
              ),
            ),
          ],
        ),
        10.verticalSpace,
        if (_showMathKeyboard) ...[
          8.verticalSpace,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  _symbolGroups.keys.map((group) {
                    final isSelected = _selectedGroup == group;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: BasicButton(
                        text: group,
                        height: 28.h,
                        width: 90.w,
                        textStyle:
                            isSelected
                                ? TextStyle(color: AppColors.whiteColor)
                                : AppTextStyle.smallGreenBold,
                        backgroundColor:
                            isSelected
                                ? AppColors.primaryColor
                                : AppColors.whiteColor,
                        border: BorderSide(
                          color: AppColors.primaryColor,
                          width: 1,
                        ),
                        onPress: () {
                          setState(() {
                            _selectedGroup = group;
                          });
                        },
                      ),
                    );
                  }).toList(),
            ),
          ),
          8.verticalSpace,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  _symbolGroups[_selectedGroup]!
                      .map((symbol) => _symbolButton(symbol))
                      .toList(),
            ),
          ),
          16.verticalSpace,
        ],
        BasicButton(
          text: 'Convert to Braille',
          onPress: () {
            final input = mathTextController.text;
            final output = latinToBraille(input);
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
                mathTextController.clear();
              },
            ),
          ],
        ),
        30.verticalSpace,
      ],
    );
  }

  Widget _symbolButton(String symbol) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: BasicButton(
        text: symbol,
        height: 32.h,
        width: 40.w,
        textStyle: AppTextStyle.smallGreenBold,
        backgroundColor: AppColors.whiteColor,
        border: BorderSide(color: AppColors.primaryColor, width: 1),
        onPress: () {
          final text = mathTextController.text;
          final selection = mathTextController.selection;
          final newText = text.replaceRange(
            selection.start,
            selection.end,
            symbol,
          );
          mathTextController.text = newText;
          mathTextController.selection = TextSelection.collapsed(
            offset: selection.start + symbol.length,
          );
        },
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
