import 'package:flutter/material.dart';
import 'course_model.dart';
import 'form_course.dart';

const Color darkTextColor = Color(0xFF333333);
const Color lightTextColor = Color(0xFF999999);
const Color primaryColor = Color(0xFF2196F3);

class DraftCoursePage extends StatefulWidget {
  const DraftCoursePage({Key? key}) : super(key: key);

  @override
  State<DraftCoursePage> createState() => _DraftCoursePageState();
}

class _DraftCoursePageState extends State<DraftCoursePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Draft Course'),
        backgroundColor: Colors.white,
        foregroundColor: darkTextColor,
        elevation: 0,
      ),
      body: CourseDatabase.draftCourses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.drafts_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('Belum ada draft', style: TextStyle(fontSize: 16, color: lightTextColor)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: CourseDatabase.draftCourses.length,
              itemBuilder: (context, index) {
                final draft = CourseDatabase.draftCourses[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey[200]!),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.edit_document, color: primaryColor),
                    title: Text(draft.title ?? 'Untitled', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(draft.category ?? 'No category'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: primaryColor),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddCourseFormPage(draftData: draft),
                              ),
                            ).then((_) => setState(() {}));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              CourseDatabase.draftCourses.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}