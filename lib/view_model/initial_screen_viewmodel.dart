import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialScreenViewModel extends GetxController{

  RxBool isFirstTimeLauncing = false.obs;
  RxString initialScreen = "splash".obs;

  getInitialScreen() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isFirstLaunching = pref.getBool("isFirstTimeLauncing")??true;

    if(isFirstLaunching){
      initialScreen = "splash".obs;
    }
    else if(isFirstLaunching==false){
      initialScreen = "login".obs;
    }
  }


  setLauncingState()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool("isFirstTimeLauncing", false);
  }

}