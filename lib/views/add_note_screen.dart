import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:notes/constants/app_colors.dart';
import 'package:notes/constants/app_strings.dart';
import 'package:notes/constants/widgets/custom_button.dart';
import 'package:notes/constants/widgets/custom_snackbar.dart';
import 'package:notes/controller/note_model.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final NotesController _notesController = Get.find<NotesController>();
  final isLoading = false.obs;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double safeAreaHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      body: SingleChildScrollView(
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
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.go("/home");
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          AppStrings.addNote,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 20.sp),
                  noteTitleField(
                    noteTitle: AppStrings.noteTitle,
                    controller: titleController,
                  ),
                  SizedBox(height: 20.sp),
                  noteDescriptionField(
                    noteDescription: AppStrings.noteDescription,
                    controller: descriptionController,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: Obx(() => isLoading.value
            ? Center(child: CircularProgressIndicator())
            : CustomButton(
          buttonText: "Save Note",
          onPressed: () async {
            if (titleController.text.trim().isEmpty) {
              customSnackbar(
                context: context,
                title: "Error",
                content: "Please enter a title for your note",
                color: Colors.red,
              );
              return;
            }

            isLoading.value = true;
            try {
              await _notesController.addNote(
                titleController.text.trim(),
                descriptionController.text.trim(),
              );
              isLoading.value = false;
              customSnackbar(
                context: context,
                title: "Success",
                content: "Note added successfully",
                color: Colors.green,
              );
              Future.delayed(Duration(seconds: 1), () {
                context.go("/home");
              });
            } catch (e) {
              isLoading.value = false;
              customSnackbar(
                context: context,
                title: "Error",
                content: "Failed to add note: $e",
                color: Colors.red,
              );
            }
          },
        )),
      ),
    );
  }
}

Widget noteTitleField({String? noteTitle, required TextEditingController controller}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: noteTitle,
      border: OutlineInputBorder(),
    ),
  );
}

Widget noteDescriptionField({String? noteDescription, required TextEditingController controller}) {
  return TextFormField(
    controller: controller,
    minLines: 10,
    maxLines: null,
    decoration: InputDecoration(
      labelText: noteDescription,
      border: OutlineInputBorder(),
      alignLabelWithHint: true,
    ),
  );
}