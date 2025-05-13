import 'package:cloud_firestore/cloud_firestore.dart';

class NotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getNotes(String userEmail) {
    return _firestore
        .collection("user")
        .doc(userEmail)
        .collection("notes")
        .snapshots();
  }

  Future<void> addNote(
    String userEmail,
    String title,
    String description,
  ) async {
    try {
      final QuerySnapshot notesSnapshot =
          await _firestore
              .collection("user")
              .doc(userEmail)
              .collection("notes")
              .get();

      int nextIndex = notesSnapshot.docs.length;

      await _firestore
          .collection("user")
          .doc(userEmail)
          .collection("notes")
          .doc(nextIndex.toString())
          .set({
            'title': title,
            'description': description,
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          });
    } catch (e) {
      print("Error adding note: $e");
      throw e;
    }
  }

  Future<void> deleteNote(String userEmail, String noteId) async {
    try {
      await _firestore
          .collection("user")
          .doc(userEmail)
          .collection("notes")
          .doc(noteId)
          .delete();
    } catch (e) {
      print("Error deleting note: $e");
      throw e;
    }
  }

  Future<void> updateNote(
    String userEmail,
    String noteId,
    String title,
    String description,
  ) async {
    try {
      await _firestore
          .collection("user")
          .doc(userEmail)
          .collection("notes")
          .doc(noteId)
          .update({
            'title': title,
            'description': description,
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          });
    } catch (e) {
      print("Error updating note: $e");
      throw e;
    }
  }
}
