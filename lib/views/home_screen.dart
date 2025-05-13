import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:notes/constants/app_strings.dart';
import 'package:notes/controller/note_model.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotesController _notesController = Get.find<NotesController>();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    if (!_isInitialized) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString("userEmail");

      if (email != null && email.isNotEmpty) {
        _notesController.setUserEmail(email);
        _isInitialized = true;
      }
    }
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);
    await prefs.remove("userEmail");

    final NotesController notesController = Get.find<NotesController>();
    notesController.setUserEmail("");

    context.go("/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F5FA),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Color(0xFF5046e5)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Notes (${_notesController.notes.length})",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirm Logout'),
                              content: Text('Are you sure you want to logout?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _logout(context);
                                  },
                                  child: Text('Logout'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.logout),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(() {
                  if (_notesController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (_notesController.notes.isEmpty) {
                    return Center(
                      child: Text(
                        AppStrings.emptyNotes,
                        style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.only(top: 16.0),
                      itemCount: _notesController.notes.length,
                      itemBuilder: (context, index) {
                        final currentNote = _notesController.notes[index];
                        return Dismissible(
                          key: Key(currentNote.id),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 20.0),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            _notesController.deleteNote(currentNote.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Note deleted'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                          child: GestureDetector(
                            onTap: () {},
                            child: buildNoteCard(
                              title: currentNote.title,
                              description: currentNote.description,
                              context: context,
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF5046e5),
        elevation: 4,
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Colors.white, size: 32),
        onPressed: () {
          context.push('/addNote');
        },
      ),
    );
  }
}

Widget buildNoteCard({
  String? title,
  String? description,
  required BuildContext context,
}) {
  return Card(
    elevation: 0,
    margin: EdgeInsets.only(bottom: 16.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Container(
      padding: EdgeInsets.all(20.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title?.toString() ?? "",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10.0),
          Text(
            description?.toString() ?? "",
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.black54,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}
