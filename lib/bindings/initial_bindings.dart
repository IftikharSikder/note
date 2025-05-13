import 'package:get/get.dart';
import 'package:notes/controller/note_model.dart';
import 'package:notes/view_model/initial_screen_viewmodel.dart';

class InitialBindings extends Bindings{
  @override
  void dependencies() {
    Get.put(InitialScreenViewModel());
    Get.put(NotesController());
  }
}