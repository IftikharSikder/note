import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:notes/constants/app_images.dart';
import 'package:notes/constants/app_strings.dart';
import 'package:notes/constants/spacing.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF3D1), Color(0xFFFFFFFF)],
          ),
        ),
        child: Column(
          children: [
            Spacer(flex: 4),
            Center(
              child: Lottie.asset(
                AppImages.splashNoteAnimation,
                height: 135.h,
                width: 135.w,
              ),
            ),
            Text(
              AppStrings.appName,
              style: TextStyle(
                color: Color(0xFFbe6817),
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.verticalSmall,
            Text(
              AppStrings.appSlogan,
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.6),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(flex: 3),
            Padding(
              padding: EdgeInsets.only(bottom: 50.h),
              child: Center(
                child: Lottie.asset(
                  AppImages.splashLoaderAnimation,
                  height: 100.h,
                  width: 100.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
