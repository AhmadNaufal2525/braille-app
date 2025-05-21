import 'package:braille_app/utils/config/assets/app_vector.dart';
import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:braille_app/utils/config/theme/app_text_style.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FirstPageOnboard extends StatelessWidget {
  final int currentPage;

  const FirstPageOnboard({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Transform.translate(
                offset: const Offset(0, -80),
                child: SizedBox(
                  width: double.infinity,
                  child: SvgPicture.asset(
                    AppVectors.onboardShape,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Column(
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        AppVectors.onboardImg1,
                        width: screenWidth * 0.75,
                      ),
                    ),
                    SizedBox(height: 30),
                    DotsIndicator(
                      dotsCount: 3,
                      position: currentPage.toDouble(),
                      decorator: const DotsDecorator(
                        size: Size(12.0, 12.0),
                        activeSize: Size(12.0, 12.0),
                        color: AppColors.whiteColor,
                        activeColor: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Transform.translate(
            offset: const Offset(0, -50),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang Teman !',
                    style: AppTextStyle.xlargeBlackBold,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Ini adalah aplikasi untuk kamu teman teman yang membutuhkan bantuan mengidentifikasi gambar maupun tulisan kedalam Braille dengan bantuan artifical intelligence kami.',
                    style: AppTextStyle.mediumBlack,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
