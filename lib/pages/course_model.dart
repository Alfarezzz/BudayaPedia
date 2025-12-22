// =======================================================
// ISI FILE: lib/course_model.dart
// =======================================================
import 'package:flutter/material.dart'; // Import ini hanya untuk Color

// Definisikan warna di sini agar bisa digunakan di data
const Color primaryColor = Color(0xFF2C3E50);

// MODEL DATA KURSUS
class Course {
  final String title;
  final String category;
  final String description;
  final List<String> contents;
  final String videoCount;
  final String duration;
  final String imageUrl;

  Course({
    required this.title,
    required this.category,
    required this.description,
    required this.contents,
    required this.videoCount,
    required this.duration,
    required this.imageUrl,
  });
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
  String? title;
  String? subtitle;
  String? author;
  String? category;
  String? duration;
  String? description;
  dynamic thumbnail;
  List<String> learningOutcomes;
  List<CourseSection> sections;
  CourseStatus? status;
  String? uploadDate;
  String? rejectionReason;
  bool isDraft;

  CourseData({
    this.title,
    this.subtitle,
    this.author,
    this.category,
    this.duration,
    this.description,
    this.thumbnail,
    this.learningOutcomes = const [],
    this.sections = const [],
    this.status,
    this.uploadDate,
    this.rejectionReason,
    this.isDraft = false,
  });
}

class CourseSection {
  String title;
  List<Lesson> lessons;
  
  CourseSection({required this.title, required this.lessons});
}

class Lesson {
  String title;
  String type;
  String? contentPath;
  List<QuizQuestion>? quizQuestions;
  
  Lesson({
    required this.title,
    required this.type,
    this.contentPath,
    this.quizQuestions,
  });
}

class QuizQuestion {
  String question;
  List<String> options;
  int correctAnswer;
  
  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}

class CourseDatabase {
  static List<CourseData> uploadedCourses = [];
  static List<CourseData> draftCourses = [];
}