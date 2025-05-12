import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:notes/constants/app_colors.dart';
import 'package:notes/constants/app_strings.dart';
import 'package:notes/constants/widgets/custom_button.dart';

class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({super.key});

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
                        context.push("/home");
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
                  noteTitleField(noteTitle: AppStrings.noteTitle),
                  SizedBox(height: 20.sp),
                  noteDescriptionField(
                    noteDescription: AppStrings.noteDescription,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: CustomButton(buttonText: "Save Note", onPressed: () {}),
      ),
    );
  }
}

Widget noteTitleField({String? noteTitle}) {
  return TextFormField(
    decoration: InputDecoration(
      labelText: noteTitle,
      border: OutlineInputBorder(),
    ),
  );
}

Widget noteDescriptionField({String? noteDescription}) {
  return TextFormField(
    minLines: 10,
    maxLines: null,
    decoration: InputDecoration(
      labelText: noteDescription,
      border: OutlineInputBorder(),
      alignLabelWithHint: true,
    ),
  );
}
