// =======================================================
// ISI FILE: lib/course_model.dart
// =======================================================
import 'package:flutter/material.dart'; // Import ini hanya untuk Color
import 'dart:io';
import 'mycourse.dart';

// Definisikan warna di sini agar bisa digunakan di data
const Color primaryColor = Color(0xFF2C3E50);

// MODEL DATA KURSUS
class Course {
  final String? id;
  final String title;
  final String category;
  final String description;
  final List<String> contents;
  final String videoCount;
  final String duration;
  final String imageUrl;
  final String? author;
  final String? level;
  final String? language;
  final List<String>? learningOutcomes;
  final List<String>? prerequisites;
  final List<CourseSection>? sections;
  final List<Resource>? resources;
  final CourseStatus? status;

  Course({
    this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.contents,
    required this.videoCount,
    required this.duration,
    required this.imageUrl,
    this.author,
    this.level = 'Beginner',
    this.language = 'Indonesian',
    this.learningOutcomes,
    this.prerequisites,
    this.sections,
    this.resources,
    this.status,
  });

  // Factory constructor to convert CourseData to Course
  factory Course.fromCourseData(CourseData courseData, String id) {
    return Course(
      id: id,
      title: courseData.title ?? '',
      category: courseData.category ?? '',
      description: courseData.description ?? '',
      contents: [],
      videoCount: '0 Videos',
      duration: courseData.duration ?? '0h 0m',
      imageUrl: courseData.thumbnail ?? '',
      author: courseData.author,
      level: courseData.level,
      language: courseData.language,
      learningOutcomes: courseData.learningOutcomes,
      prerequisites: courseData.prerequisites,
      sections: courseData.sections,
      resources: courseData.resources,
      status: courseData.status,
    );
  }
}

// DATA KURSUS (Dipindahkan dari mycourse.dart)
final List<Course> allCourses = [
  Course(
    title: "Filosofi Adat dan Rumah Gadang Minangkabau",
    category: "Adat",
    description:
        "Pelajari sistem matrilineal, nilai-nilai luhur adat, dan arsitektur ikonik Rumah Gadang Sumatra Barat.",
    videoCount: '18 videos',
    duration: "2h 20m",
    imageUrl: 'assets/sumatra.jpg',
    contents: [
      "Memahami struktur sosial matrilineal Suku Minangkabau.",
      "Menjelaskan peran penting Bundo Kanduang dan Niniak Mamak dalam adat.",
      "Menganalisis filosofi ukiran dan konstruksi Rumah Gadang.",
      "Studi kasus upacara adat pernikahan Minangkabau.",
    ],
  ),
  Course(
    title: "Gerak Anggun Tari Klasik Keraton Jawa",
    category: "Seni",
    description:
        "Pengenalan mendalam pada Tari Serimpi dan Bedhaya, termasuk filosofi di balik gerakan lembut dan busana penari Keraton.",
    videoCount: '12 videos',
    duration: "1h 15m",
    imageUrl: 'assets/tarikawa.jpg',
    contents: [
      "Teknik dasar gerakan lambat dan halus Tari Serimpi.",
      "Memahami filosofi ketenangan dan kesabaran dalam Tari Bedhaya.",
      "Peran Gamelan dan Sinden sebagai iringan utama.",
      "Menganalisis makna simbolis busana penari Keraton.",
    ],
  ),
  // ... Tambahkan semua data kursus lainnya di sini
  Course(
    title: "Manik-Manik dan Busana Adat Suku Dayak",
    category: "Kerajinan",
    description:
        "Eksplorasi Pakaian Adat Dayak Kalimantan, fokus pada teknik pembuatan manik-manik, ukiran, dan busana King Baba/King Bibinge.",
    videoCount: '8 videos',
    duration: "2h 15m",
    imageUrl: 'assets/dayak.jpg',
    contents: [
      "Pengenalan berbagai jenis manik-manik dan bahan dasar.",
      "Langkah-langkah pembuatan aksesoris manik-manik Dayak.",
      "Simbolisme warna dan motif fauna/flora pada ukiran Dayak.",
      "Sejarah dan fungsi busana King Baba dan King Bibinge.",
    ],
  ),
  Course(
    title: "Memasak Papeda dan Kuah Kuning Ikan Tongkol",
    category: "Makanan",
    description:
        "Teknik dan resep spesifik untuk hidangan ikonik Papua. Belajar membuat Papeda dari sagu dan mengolahnya bersama Kuah Kuning Ikan Tongkol.",
    videoCount: '8 videos',
    duration: "2h 15m",
    imageUrl: 'assets/papeda.jpg',
    contents: [
      "Cara mengolah sagu menjadi Papeda yang kenyal sempurna.",
      "Resep bumbu lengkap untuk Kuah Kuning Ikan Tongkol.",
      "Filosofi Papeda sebagai makanan pokok dan ritual adat.",
      "Teknik penyajian dan etika makan hidangan Papua.",
    ],
  ),
];

// ============================================
// MODEL DATA UNTUK UPLOAD KURSUS
// ============================================

// ============================================
// FILE: lib/models/course_model.dart
// ============================================

enum CourseStatus { pending, approved, rejected }

class CourseData {
  String? id;
  String? title;
  String? subtitle;
  String? author;
  String? category;
  String? duration;
  String? description;
  dynamic thumbnail;
  String? level;
  String? language;
  List<String> learningOutcomes;
  List<String> prerequisites;
  List<CourseSection> sections;
  List<Resource> resources;
  CourseStatus? status;
  String? uploadDate;
  String? rejectionReason;
  bool isDraft;

  CourseData({
    this.id,
    this.title,
    this.subtitle,
    this.author,
    this.category,
    this.duration,
    this.description,
    this.thumbnail,
    this.level = 'Beginner',
    this.language = 'Indonesian',
    this.learningOutcomes = const [],
    this.prerequisites = const [],
    this.sections = const [],
    this.resources = const [],
    this.status,
    this.uploadDate,
    this.rejectionReason,
    this.isDraft = false,
  });
}

class CourseSection {
  String title;
  List<Lesson> lessons;
  List<Quiz>? quizzes;
  List<Assignment>? assignments;
  
  CourseSection({
    required this.title,
    required this.lessons,
    this.quizzes,
    this.assignments,
  });
}

class Lesson {
  String title;
  String type;
  String? duration;
  String? contentPath;
  List<QuizQuestion>? quizQuestions;
  
  Lesson({
    required this.title,
    required this.type,
    this.duration,
    this.contentPath,
    this.quizQuestions,
  });
}

class Quiz {
  String title;
  String? description;
  List<QuizQuestion> questions;
  int? passingScore;
  
  Quiz({
    required this.title,
    this.description,
    required this.questions,
    this.passingScore = 70,
  });
}

class QuizQuestion {
  String question;
  List<String> options;
  int correctAnswer;
  String? explanation;
  
  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.explanation,
  });
}

class Assignment {
  String title;
  String? description;
  String? dueDate;
  String? fileType;
  
  Assignment({
    required this.title,
    this.description,
    this.dueDate,
    this.fileType,
  });
}

class Resource {
  String name;
  String? fileUrl;
  String? fileType;
  String? fileSize;
  
  Resource({
    required this.name,
    this.fileUrl,
    this.fileType,
    this.fileSize,
  });
}

class Notification {
  String id;
  String userId;
  String title;
  String message;
  String type; // 'approved', 'rejected', 'comment'
  String? courseId;
  DateTime createdAt;
  bool isRead;

  Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.courseId,
    required this.createdAt,
    this.isRead = false,
  });
}

class NotificationService {
  static List<Notification> userNotifications = [];

  static void addNotification({
    required String userId,
    required String title,
    required String message,
    required String type,
    String? courseId,
  }) {
    final notification = Notification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      title: title,
      message: message,
      type: type,
      courseId: courseId,
      createdAt: DateTime.now(),
      isRead: false,
    );
    userNotifications.add(notification);
  }

  static List<Notification> getUserNotifications(String userId) {
    return userNotifications.where((n) => n.userId == userId).toList();
  }

  static void markAsRead(String notificationId) {
    final notification = userNotifications.firstWhere(
      (n) => n.id == notificationId,
      orElse: () => userNotifications[0],
    );
    notification.isRead = true;
  }

  static int getUnreadCount(String userId) {
    return userNotifications
        .where((n) => n.userId == userId && !n.isRead)
        .length;
  }
}

class CourseDatabase {
  // User submissions (pending review)
  static List<CourseData> uploadedCourses = [];
  
  // Draft courses (not submitted yet)
  static List<CourseData> draftCourses = [];
  
  // Published courses (approved, visible di MyCoursePage)
  static List<Course> publishedCourses = [
    // Default courses dari MyCoursePage
    Course(
      id: '1',
      title: 'Masakan Nusantara',
      description: 'Pelajari cara memasak makanan tradisional Indonesia',
      category: 'Makanan',
      imageUrl: 'assets/rendang.jpeg',
      videoCount: '12 Videos',
      duration: '3h 20m',
      author: 'Chef Budaya',
      contents: [
        'Menguasai teknik memasak tradisional',
        'Memahami bumbu-bumbu nusantara',
      ],
      learningOutcomes: [
        'Menguasai teknik memasak tradisional',
        'Memahami bumbu-bumbu nusantara',
      ],
      sections: [],
      status: CourseStatus.approved,
    ),
    Course(
      id: '2',
      title: 'Seni Batik',
      description: 'Belajar membuat batik dari nol hingga mahir',
      category: 'Seni',
      imageUrl: 'assets/batik.jpeg',
      videoCount: '8 Videos',
      duration: '2h 45m',
      author: 'Mbak Batik',
      contents: [
        'Mengenal motif batik tradisional',
        'Praktik membatik langsung',
      ],
      learningOutcomes: [
        'Mengenal motif batik tradisional',
        'Praktik membatik langsung',
      ],
      sections: [],
      status: CourseStatus.approved,
    ),
    Course(
      id: '3',
      title: 'Tari Tradisional Jawa',
      description: 'Pelajari gerakan tari Jawa klasik',
      category: 'Seni',
      imageUrl: 'assets/tari.jpeg',
      videoCount: '10 Videos',
      duration: '4h 10m',
      author: 'Penari Nusantara',
      contents: [
        'Memahami filosofi tari Jawa',
        'Menguasai gerakan dasar',
      ],
      learningOutcomes: [
        'Memahami filosofi tari Jawa',
        'Menguasai gerakan dasar',
      ],
      sections: [],
      status: CourseStatus.approved,
    ),
  ];

  // ============================================
  // METHODS FOR ADMIN ACTIONS
  // ============================================

  static void approveCourse(CourseData courseData) {
    // Ubah status jadi approved
    courseData.status = CourseStatus.approved;
    
    // Konversi CourseData ke Course
    final newCourse = Course.fromCourseData(
      courseData,
      DateTime.now().millisecondsSinceEpoch.toString(),
    );
    
    // Tambahkan ke publishedCourses
    publishedCourses.add(newCourse);
    
    // Hapus dari uploadedCourses
    uploadedCourses.remove(courseData);
    
    // 🔔 KIRIM NOTIFIKASI KE USER
    NotificationService.addNotification(
      userId: 'current_user_id', // Ganti dengan ID user sebenarnya
      title: '✅ Course Approved!',
      message: 'Course "${courseData.title}" telah disetujui dan dipublish ke My Courses',
      type: 'approved',
      courseId: newCourse.id,
    );
  }

  static void rejectCourse(CourseData courseData, String rejectionReason) {
    courseData.status = CourseStatus.rejected;
    courseData.rejectionReason = rejectionReason;
    
    // 🔔 KIRIM NOTIFIKASI KE USER
    NotificationService.addNotification(
      userId: 'current_user_id', // Ganti dengan ID user sebenarnya
      title: '❌ Course Rejected',
      message: 'Alasan: $rejectionReason',
      type: 'rejected',
      courseId: courseData.id,
    );
  }

  static void deletePublishedCourse(String courseId) {
    publishedCourses.removeWhere((course) => course.id == courseId);
  }
}
