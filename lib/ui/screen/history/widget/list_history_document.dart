import 'package:braille_app/ui/screen/history/widget/card_document.dart';
import 'package:braille_app/utils/config/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class ListHistoryDocument extends StatelessWidget {
  ListHistoryDocument({super.key});

  final List<Map<String, dynamic>>? docList = [
    {'documentName': 'Latihan dokumen 1.docx'},
    {'documentName': 'Latihan dokumen 2.docx'},
    {'documentName': 'Latihan dokumen 3.docx'},
  ];

  @override
  Widget build(BuildContext context) {
    if (docList == null || docList!.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            'Tidak ada riwayat dokumen',
            style: AppTextStyle.mediumGreen,
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.separated(
        itemBuilder: (context, index) {
          final doc = docList![index];
          return CardDocument(
            documentName: doc['documentName'],
            onPressed: () {
              Navigator.pushNamed(context, '/document');
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 18);
        },
        itemCount: docList!.length,
      ),
    );
  }
}
