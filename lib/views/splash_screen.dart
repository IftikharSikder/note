import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:notes/constants/app_colors.dart';
import 'package:notes/constants/app_images.dart';
import 'package:notes/constants/app_strings.dart';
import 'package:notes/constants/spacing.dart';
import 'package:notes/view_model/initial_screen_viewmodel.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final initialScreenController = Get.find<InitialScreenViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_)async{
      await initialScreenController.setLauncingState();
    });

    Future.delayed(const Duration(seconds: 4), () {
      initialScreenController.setLauncingState();
      context.go('/login');
    });

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.lightYellow, AppColors.white],
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