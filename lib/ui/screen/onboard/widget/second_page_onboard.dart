import 'package:braille_app/utils/config/assets/app_vector.dart';
import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:braille_app/utils/config/theme/app_text_style.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SecondPageOnboard extends StatelessWidget {
  final int currentPage;

  const SecondPageOnboard({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 0.08.sh,
              width: double.infinity,
              color: AppColors.primaryColor,
            ),
            Transform.translate(
              offset:
                  MediaQuery.of(context).size.height < 800
                      ? const Offset(0, -30)
                      : const Offset(0, -10),
              child: SvgPicture.asset(
                AppVectors.onboardShape,
                fit: BoxFit.cover,
                width: double.infinity,
                height:
                    MediaQuery.of(context).size.height < 800 ? 0.64.sh : 0.6.sh,
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(12.0.w),
                child: Column(
                  spacing: 58.h,
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        AppVectors.onboardImg2,
                        width: double.infinity,
                        height: 0.28.sh,
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
              ),
            ),
          ],
        ),
        Padding(
          padding:
              MediaQuery.of(context).size.height < 800
                  ? EdgeInsets.symmetric(horizontal: 16)
                  : EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Membantu Tugas!', style: AppTextStyle.xlargeBlackBold),
              10.verticalSpace,
              Text(
                'Dengan bantuan scan yang dapat mengubah format kedalam bentuk Braille pada dokumen ,diharapkan dapat membantu para guru memberikan tugas maupun teman teman dalam mengerjakan tugas ',
                style: AppTextStyle.mediumBlack,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
