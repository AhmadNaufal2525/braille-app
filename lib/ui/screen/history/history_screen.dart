import 'package:braille_app/ui/screen/history/widget/list_history_document.dart';
import 'package:braille_app/ui/shared/label.dart';
import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:braille_app/utils/config/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  final void Function(Map<String, dynamic>)? onResult;
  const HistoryScreen({super.key, this.onResult});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.primaryColor, toolbarHeight: 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'History',
              style: AppTextStyle.xxxlargeGreen.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Label(text: 'Your Recent Document'),
            ListHistoryDocument(),
          ],
        ),
      ),
    );
  }
}
