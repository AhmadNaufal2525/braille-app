import 'package:braille_app/utils/config/assets/app_vector.dart';
import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ThirdPageOnboard extends StatelessWidget {
  final VoidCallback onNext;
  final int currentPage;
  const ThirdPageOnboard({
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
                    child: SizedBox(
                      height: 400,
                      width: 340,
                      child: SvgPicture.asset(AppVectors.onboardImg3),
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
                  'Mari Kita Mulai !',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                Text(
                  'Tidak ada nya halangan untuk siapapun dalam menuntut ilmu, ayo mari kita mulai berkontribusi untuk dunia, dimana edukasi dapat diakses oleh siapa saja, termasuk kalian teman.',
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
