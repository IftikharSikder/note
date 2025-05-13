import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:notes/bindings/initial_bindings.dart';
import 'package:notes/constants/app_strings.dart';
import 'package:notes/controller/note_model.dart';
import 'package:notes/routes.dart';
import 'package:notes/view_model/initial_screen_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  InitialBindings().dependencies();

  final initialScreenController = Get.find<InitialScreenViewModel>();
  await initialScreenController.getInitialScreen();

  if (!Get.isRegistered<NotesController>()) {
    Get.put(NotesController());
  }

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userEmail = prefs.getString("userEmail");
  final NotesController notesController = Get.find<NotesController>();

  if (userEmail != null && userEmail.isNotEmpty) {
    notesController.setUserEmail(userEmail);

    await prefs.remove("pendingUserEmail");
  }

  final appRoutes = AppRoutes();

  runApp(MyApp(appRoutes: appRoutes));
}

class MyApp extends StatelessWidget {
  final AppRoutes appRoutes;
  const MyApp({super.key, required this.appRoutes});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: AppStrings.appName,
          routeInformationParser: appRoutes.routes.routeInformationParser,
          routeInformationProvider: appRoutes.routes.routeInformationProvider,
          routerDelegate: appRoutes.routes.routerDelegate,
        );
      },
    );
  }
}
