import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:notes/view_model/initial_screen_viewmodel.dart';
import 'package:notes/views/add_note_screen.dart';
import 'package:notes/views/home_screen.dart';
import 'package:notes/views/registration_screen.dart';

import 'views/login_screen.dart';
import 'views/splash_screen.dart';

class AppRoutes {
  final InitialScreenViewModel initialScreenController =
      Get.find<InitialScreenViewModel>();

  late final GoRouter routes = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) {
          if (initialScreenController.initialScreen.value == "splash") {
            return MaterialPage(child: SplashScreen());
          } else if (initialScreenController.initialScreen.value == "login") {
            return MaterialPage(child: LoginScreen());
          }
          return MaterialPage(child: HomeScreen());
        },
      ),
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => MaterialPage(child: SplashScreen()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => MaterialPage(child: LoginScreen()),
      ),
      GoRoute(
        path: '/registration',
        pageBuilder:
            (context, state) => MaterialPage(child: RegistrationScreen()),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => MaterialPage(child: HomeScreen()),
      ),
      GoRoute(
        path: '/addNote',
        pageBuilder: (context, state) => MaterialPage(child: AddNoteScreen()),
      ),
    ],
    redirect: (context, state) {
      return null;
    },
    errorPageBuilder: (context, state) {
      return MaterialPage(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Page Not Found',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text('${state.error}'),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () => context.go('/'),
                  child: Text('Home'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
