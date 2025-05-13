import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:notes/controller/note_model.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> emailExists(String email) async {
    final querySnapshot = await _firestore
        .collection("user")
        .where('email', isEqualTo: email)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  
  Future<String> login(String email, String password) async {
    final querySnapshot = await _firestore
        .collection("user")
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return "failed";
    } else {
      final NotesController notesController = Get.find<NotesController>();
      notesController.setUserEmail(email);

      return "success";
    }
  }

  
  Future<String> register(String name, String email, String password) async {
    try {
      
      bool exists = await emailExists(email);
      if (exists) {
        return "email_exists";
      }

      
      await _firestore.collection("user").doc(email).set({
        'name': name,
        'email': email,
        'password': password,
      });

      
      await _firestore
          .collection("user")
          .doc(email)
          .collection("notes")
          .doc("0")
          .set({
        'title': 'Welcome to Notes App',
        'description': 'No notes yet! Add your first note',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      return "success";
    } catch (e) {
      print("Registration error: $e");
      return "failed";
    }
  }
}