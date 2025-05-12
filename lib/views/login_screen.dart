import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:notes/constants/app_colors.dart';
import 'package:notes/constants/app_strings.dart';
import 'package:notes/constants/spacing.dart';
import 'package:notes/constants/widgets/custom_button.dart';
import 'package:notes/constants/widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                AppStrings.welcomMessage,
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                ),
              ),
            ),

            Text(
              AppStrings.signInMessage,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),

            Spacing.verticalSmall,

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: Card(
                elevation: 8,
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(20.sp),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
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
                        Spacing.verticalSmall,
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
                        Spacing.verticalSmall,
                        CustomButton(
                          buttonText: AppStrings.signInText,
                          onPressed: () {
                            // if (formKey.currentState!.validate()) {
                            //   context.go("/home");
                            // }
                            context.go("/home");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppStrings.newUserSignupMsg),
                TextButton(
                  onPressed: () {
                    context.push('/registration');
                  },
                  child: Text(AppStrings.signUpText),
                ),
              ],
            ),
          ],
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
