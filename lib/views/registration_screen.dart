import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:notes/constants/app_colors.dart';
import 'package:notes/constants/app_strings.dart';
import 'package:notes/constants/spacing.dart';
import 'package:notes/constants/widgets/custom_button.dart';
import 'package:notes/constants/widgets/custom_text_field.dart';

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double safeAreaHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.notes,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Icon(Icons.info_outline_rounded, color: Colors.white),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 60.h),
              SizedBox(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        AppStrings.createAccount,
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    Text(
                      AppStrings.signUpSlogan,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    customFieldName(name: AppStrings.fullName),
                    Spacing.xs,
                    CustomTextField(
                      hintText: AppStrings.enterFullName,
                      prefixIcon: Icon(Icons.email_outlined),
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppStrings.enterFullName;
                        }
                        return null;
                      },
                    ),
                    Spacing.xs,
                    customFieldName(name: AppStrings.email),
                    Spacing.xs,
                    CustomTextField(
                      hintText: AppStrings.enterYourEmail,
                      prefixIcon: Icon(Icons.email_outlined),
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.emailValidationError;
                        }

                        if (value.contains(RegExp(r'[A-Z]'))) {
                          return AppStrings.emailLowercaseError;
                        }

                        final emailRegex = RegExp(
                          r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$',
                        );
                        if (!emailRegex.hasMatch(value)) {
                          return AppStrings.validEmailMsg;
                        }
                        return null;
                      },
                    ),
                    Spacing.xs,
                    customFieldName(name: AppStrings.password),
                    Spacing.xs,
                    CustomTextField(
                      controller: passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppStrings.passwordValidationError;
                        }
                        return null;
                      },
                      hintText: AppStrings.enterYourPassword,
                      prefixIcon: Icon(Icons.password),
                      obscureText: true,
                    ),
                    Spacing.verticalMedium,
                    CustomButton(
                      buttonText: "Create Account",
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.go("/home");
                        }
                      },
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppStrings.newUserSignupMsg),
                  TextButton(
                    onPressed: () {
                      context.push('/login');
                    },
                    child: Text(AppStrings.login),
                  ),
                ],
              ),
              SizedBox(height: 60.h),
            ],
          ),
        ),
      ),
    );
  }
}

Widget customFieldName({required String name}) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      name,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.darkBlue,
      ),
    ),
  );
}
