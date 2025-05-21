import 'package:braille_app/utils/config/assets/app_vector.dart';
import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FirstPageOnboard extends StatelessWidget {
  final VoidCallback onNext;
  final int currentPage;

  const FirstPageOnboard({
    super.key,
    required this.onNext,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double screenHeight = size.height;
    final double screenWidth = size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 30,
                color: AppColors.primaryColor,
              ),
              Transform.translate(
                offset: const Offset(0, -40),
                child: SizedBox(
                  width: double.infinity,
                  child: SvgPicture.asset(
                    AppVectors.onboardShape,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      height: screenHeight * 0.46,
                      width: screenWidth * 0.75,
                      child: SvgPicture.asset(AppVectors.onboardImg1),
                    ),
                  ),
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
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang Teman !',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.045,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Ini adalah aplikasi untuk kamu teman teman yang membutuhkan bantuan mengidentifikasi gambar maupun tulisan kedalam Braille dengan bantuan artifical intelligence kami.',
                  style: TextStyle(fontSize: screenWidth * 0.04),
                ),
                SizedBox(height: screenHeight * 0.03),
                Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: InkWell(
                    onTap: onNext,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: screenWidth * 0.14,
                      height: screenWidth * 0.14,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primaryColor, Color(0xFF1C3437)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: AppColors.whiteColor,
                        size: 32,
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
