import 'package:flutter/material.dart';
import 'course_model.dart';
import 'form_course.dart';
import 'draft_course.dart';

const Color darkTextColor = Color(0xFF333333);
const Color lightTextColor = Color(0xFF999999);
const Color primaryColor = Color(0xFF2196F3);

class CourseStatusPage extends StatefulWidget {
  const CourseStatusPage({Key? key}) : super(key: key);

  @override
  State<CourseStatusPage> createState() => _CourseStatusPageState();
}

class _CourseStatusPageState extends State<CourseStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Course Saya'),
        backgroundColor: Colors.white,
        foregroundColor: darkTextColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.drafts_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DraftCoursePage()),
              ).then((_) => setState(() {}));
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddCourseFormPage()),
              ).then((_) => setState(() {}));
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: CourseDatabase.uploadedCourses.length,
        itemBuilder: (context, index) {
          final course = CourseDatabase.uploadedCourses[index];
          
          Color statusColor;
          IconData statusIcon;
          String statusText;

          switch (course.status!) {
            case CourseStatus.pending:
              statusColor = Colors.orange;
              statusIcon = Icons.pending_outlined;
              statusText = 'Pending Review';
              break;
            case CourseStatus.approved:
              statusColor = Colors.green;
              statusIcon = Icons.check_circle_outline;
              statusText = 'Diterima';
              break;
            case CourseStatus.rejected:
              statusColor = Colors.red;
              statusIcon = Icons.cancel_outlined;
              statusText = 'Ditolak';
              break;
          }

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.title ?? '',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkTextColor),
                            ),
                            const SizedBox(height: 4),
                            Text(course.category ?? '', style: TextStyle(fontSize: 13, color: lightTextColor)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: statusColor.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(statusIcon, size: 16, color: statusColor),
                            const SizedBox(width: 4),
                            Text(statusText, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: statusColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 14, color: lightTextColor),
                      const SizedBox(width: 6),
                      Text('Diupload: ${course.uploadDate}', style: TextStyle(fontSize: 12, color: lightTextColor)),
                    ],
                  ),
                  if (course.status == CourseStatus.pending) ...[
                    const SizedBox(height: 8),
                    Text('Menunggu review admin (1-3 hari)', style: TextStyle(fontSize: 12, color: lightTextColor, fontStyle: FontStyle.italic)),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
