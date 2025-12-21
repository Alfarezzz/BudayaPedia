import 'package:flutter/material.dart';
import 'course_model.dart';
import 'form_course.dart';
import 'status_course.dart';

const Color primaryColor = Color(0xFF2C3E50);
const Color darkTextColor = Color(0xFF1E2A3B);
const Color lightTextColor = Color(0xFF5A6B80);

class AddCoursePage extends StatelessWidget {
  const AddCoursePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Cek apakah ada course yang sudah diupload
    if (CourseDatabase.uploadedCourses.isNotEmpty) {
      return const CourseStatusPage();
    }
    
    return const DefaultEmptyPage();
  }
}

class DefaultEmptyPage extends StatelessWidget {
  const DefaultEmptyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.library_books_outlined,
                    size: 70,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 32),

                const Text(
                  'Bagikan Pengetahuan Anda',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: darkTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                Text(
                  'Buat course dan bantu ribuan orang\nbelajar hal baru dari Anda',
                  style: TextStyle(
                    fontSize: 15,
                    color: lightTextColor,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Tombol Plus Besar
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddCourseFormPage(),
                      ),
                    );
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Tap untuk mulai',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
