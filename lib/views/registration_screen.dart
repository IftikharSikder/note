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

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final isLoading = false.obs;
  bool _passwordVisible = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
                      prefixIcon: Icon(Icons.person_outline),
                      controller: nameController,
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
                        prefixIcon: Icon(Icons.password),
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible ? Icons.visibility : Icons.visibility_off,
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
                    Spacing.verticalMedium,
                    Obx(() => isLoading.value
                        ? CircularProgressIndicator()
                        : CustomButton(
                      buttonText: "Create Account",
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          isLoading.value = true;

                          String status = await _authService.register(
                            nameController.text,
                            emailController.text,
                            passwordController.text,
                          );

                          isLoading.value = false;

                          if (status == "success") {
                            if (!Get.isRegistered<NotesController>()) {
                              Get.put(NotesController());
                            }
                            final NotesController notesController = Get.find<NotesController>();
                            notesController.setUserEmail(emailController.text);

                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setBool("isLoggedIn", true);
                            await prefs.setString("userEmail", emailController.text);

                            customSnackbar(
                              context: context,
                              title: AppStrings.success,
                              content: "Registration successful!",
                              color: Colors.green,
                            );
                            Future.delayed(Duration(seconds: 1), () {
                              context.go("/home");
                            });
                          } else if (status == "email_exists") {
                            customSnackbar(
                              context: context,
                              title: "Email Already Exists",
                              content: "This email is already registered. Please try another one.",
                              color: Colors.orange,
                            );
                          } else {
                            customSnackbar(
                              context: context,
                              title: AppStrings.failed,
                              content: "Registration failed. Please try again.",
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