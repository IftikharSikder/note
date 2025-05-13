import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialScreenViewModel extends GetxController {
  RxBool isFirstTimeLauncing = false.obs;
  RxString initialScreen = "splash".obs;

  getInitialScreen() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isFirstLaunching = pref.getBool("isFirstTimeLauncing") ?? true;
    bool isLoggedIn = pref.getBool("isLoggedIn") ?? false;

    if (isFirstLaunching) {
      initialScreen = "splash".obs;
    } else if (isLoggedIn) {
      initialScreen = "home".obs;

      final String? userEmail = pref.getString("userEmail");

      if (userEmail != null && userEmail.isNotEmpty) {
        await pref.setString("pendingUserEmail", userEmail);
      }
    } else {
      initialScreen = "login".obs;
    }
  }

  setLauncingState() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool("isFirstTimeLauncing", false);
  }
}
