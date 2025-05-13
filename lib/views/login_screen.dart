import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:notes/constants/app_colors.dart';
import 'package:notes/constants/app_strings.dart';
import 'package:notes/constants/spacing.dart';
import 'package:notes/constants/widgets/custom_button.dart';
import 'package:notes/constants/widgets/custom_snackbar.dart';
import 'package:notes/constants/widgets/custom_text_field.dart';
import 'package:notes/controller/note_model.dart';
import 'package:notes/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final isLoading = false.obs;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<NotesController>()) {
      Get.put(NotesController());
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
                        TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return AppStrings.passwordValidationError;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: AppStrings.enterYourPassword,
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.password),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_passwordVisible,
                        ),
                        Spacing.verticalSmall,
                        Obx(
                          () =>
                              isLoading.value
                                  ? CircularProgressIndicator()
                                  : CustomButton(
                                    buttonText: AppStrings.signInText,
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        isLoading.value = true;
                                        String status = await _authService
                                            .login(
                                              emailController.text,
                                              passwordController.text,
                                            );
                                        isLoading.value = false;

                                        if (status == "success") {
                                          SharedPreferences prefs =
                                              await SharedPreferences.getInstance();
                                          await prefs.setBool(
                                            "isLoggedIn",
                                            true,
                                          );
                                          await prefs.setString(
                                            "userEmail",
                                            emailController.text,
                                          );

                                          customSnackbar(
                                            context: context,
                                            title: AppStrings.success,
                                            content: AppStrings.loginSuccessMsg,
                                            color: Colors.green,
                                          );
                                          Future.delayed(
                                            Duration(seconds: 1),
                                            () {
                                              context.go("/home");
                                            },
                                          );
                                        }

                                        if (status == "failed") {
                                          customSnackbar(
                                            context: context,
                                            title: AppStrings.failed,
                                            content: AppStrings.loginFailedMsg,
                                            color: Colors.red,
                                          );
                                        }
                                      }
                                    },
                                  ),
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
