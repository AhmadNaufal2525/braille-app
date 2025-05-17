import 'package:braille_app/utils/config/assets/app_images.dart';
import 'package:braille_app/utils/config/assets/app_vector.dart';
import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SecondPageOnboard extends StatelessWidget {
  final VoidCallback onNext;
  final int currentPage;
  const SecondPageOnboard({
    super.key,
    required this.onNext,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              SvgPicture.asset(AppVectors.onboardShape, height: 555),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      AppImages.onboardImage2,
                      width: 340,
                      height: 380,
                    ),
                  ),
                  DotsIndicator(
                    dotsCount: 3,
                    position: currentPage.toDouble(),
                    decorator: const DotsDecorator(
                      color: AppColors.whiteColor,
                      activeColor: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Membantu Tugas !',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                Text(
                  'Dengan bantuan scan yang dapat mengubah format kedalam bentuk Braille pada dokumen, diharapkan dapat membantu para guru memberikan tugas maupun teman teman dalam mengerjakan tugas ',
                  style: TextStyle(fontSize: 14.0),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: InkWell(
                    onTap: onNext,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primaryColor, Color(0xFF1C3437)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: AppColors.whiteColor,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
