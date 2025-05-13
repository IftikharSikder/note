import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:notes/services/note_service.dart';

class NoteModel {
  String id;
  String title;
  String description;
  int timestamp;

  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
  });

  factory NoteModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return NoteModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      timestamp: data['timestamp'] ?? 0,
    );
  }
}

class NotesController extends GetxController {
  final NotesService _notesService = NotesService();
  final RxList<NoteModel> notes = <NoteModel>[].obs;
  final RxBool isLoading = false.obs;

  final RxString userEmail = ''.obs;

  void setUserEmail(String email) {
    userEmail.value = email;

    fetchNotes();
  }

  void fetchNotes() {
    if (userEmail.value.isEmpty) return;

    isLoading.value = true;

    _notesService
        .getNotes(userEmail.value)
        .listen(
          (snapshot) {
            notes.clear();

            for (var doc in snapshot.docs) {
              notes.add(NoteModel.fromFirestore(doc));
            }

            isLoading.value = false;
          },
          onError: (e) {
            print("Error fetching notes: $e");
            isLoading.value = false;
          },
        );
  }

  Future<void> addNote(String title, String description) async {
    if (userEmail.value.isEmpty) return;

    try {
      await _notesService.addNote(userEmail.value, title, description);
    } catch (e) {
      Get.snackbar('Error', 'Failed to add note: $e');
    }
  }

  Future<void> deleteNote(String noteId) async {
    if (userEmail.value.isEmpty) return;

    try {
      await _notesService.deleteNote(userEmail.value, noteId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete note: $e');
    }
  }

  Future<void> updateNote(
    String noteId,
    String title,
    String description,
  ) async {
    if (userEmail.value.isEmpty) return;

    try {
      await _notesService.updateNote(
        userEmail.value,
        noteId,
        title,
        description,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to update note: $e');
    }
  }
}
