import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:notes/constants/app_colors.dart';
import 'package:notes/constants/app_strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double safeAreaHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: safeAreaHeight),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5046e5), Color(0xFF5046e5)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 14,
                ),
                child: Text(
                  AppStrings.myNote,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                child: Column(
                  children: [
                    note(
                      title: "Efty Shikder",
                      description: "This is my name",
                      context: context,
                    ),
                    note(
                      title:
                          "A build operation failed shared_preferences_android:gen erateDe bugUnitTes tConfig shared_preferences_android:generateDebug UnitTestConfig This is my name",
                      description:
                          "A build operation failed shared_preferences_android:gen erateDe bugUnitTes tConfig shared_preferences_android:generateDebug UnitTestConfig This is my name",
                      context: context,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.deepBlue,
        shape: CircleBorder(),
        child: Text(
          "+",
          style: TextStyle(color: AppColors.white, fontSize: 30.sp),
        ),
        onPressed: () {
          context.push('/addNote');
        },
      ),
    );
  }
}

Widget note({
  String? title,
  String? description,
  required BuildContext context,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Container(
      height: MediaQuery.of(context).size.height / 6,
      decoration: BoxDecoration(color: Colors.white),
      width: double.infinity,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 8,
                top: 12,
                bottom: 8,
              ),
              child: Text(
                title.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          Container(
            height: 40,
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 10.0),
                child: Text(
                  description.toString(),
                  style: TextStyle(overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
