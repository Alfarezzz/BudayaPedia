// lib/pages/learning_page.dart

import 'package:flutter/material.dart';
// Import Model Course dari file tunggal (Asumsi path sudah benar)
import 'course_model.dart';
// Import Model ModuleContent dari file tunggal
import 'module_content_model.dart'; // <--- PASTIKAN PATH INI BENAR

// Import data modul
import '../data/minangkabau.dart';
import '../data/tari_keraton.dart';
import '../data/dayak.dart';
import '../data/papeda.dart';

const Color primaryColor = Color(0xFF2C3E50);
const Color darkTextColor = Color(0xFF1E2A3B);
const Color lightTextColor = Color(0xFF5A6B80);
const Color accentColor = Color(0xFFFFA000);

class LearningPage extends StatefulWidget {
  final Course course;

  const LearningPage({super.key, required this.course});

  @override
  _LearningPageState createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  int _activeModuleIndex = 0;

  // >>> LOGIKA PEMILIHAN MODUL DINAMIS (DITAMBAH PAPEDA) <<<
  List<ModuleContent> get courseModules {
    if (widget.course.title.contains('Minangkabau')) {
      return minangkabauModules;
    } else if (widget.course.title.contains('Tari Klasik Keraton Jawa')) {
      return tariKeratonModules;
    } else if (widget.course.title.contains('Suku Dayak')) {
      return dayakModules;
    } else if (widget.course.title.contains('Papeda')) {
      return papedaModules; // Menggunakan data Papeda
    }
    return [];
  }

  // >>> STRUKTUR SIDEBAR DINAMIS (DITAMBAH PAPEDA) <<<
  List<Map<String, dynamic>> get sidebarSections {
    // 1. Cek Judul Kursus Papeda (9 Item Total, Index 0-8)
    if (widget.course.title.contains('Papeda')) {
      return const [
        {'title': 'COURSE OVERVIEW', 'start_index': 0, 'end_index': 0},
        {
          'title': 'MODUL 1: PAPEDA: BAHAN DAN TEKNIK',
          'start_index': 1,
          'end_index': 2,
        },
        {
          'title': 'MODUL 2: KUAH KUNING IKAN',
          'start_index': 3,
          'end_index': 4,
        },
        {'title': 'QUIZ MODUL 1 & 2', 'start_index': 5, 'end_index': 5},
        {
          'title': 'MODUL 3: PENYAJIAN DAN ADAB',
          'start_index': 6,
          'end_index': 7,
        },
        {'title': 'FINAL ASSESSMENT', 'start_index': 8, 'end_index': 8},
      ];
    }
    // 2. Cek Judul Kursus Dayak (11 Item Total, Index 0-10)
    else if (widget.course.title.contains('Suku Dayak')) {
      return const [
        {'title': 'COURSE OVERVIEW', 'start_index': 0, 'end_index': 0},
        {
          'title': 'MODUL 1: FILOSOFI MANIK-MANIK',
          'start_index': 1,
          'end_index': 2,
        },
        {
          'title': 'MODUL 2: BUSANA TRADISIONAL',
          'start_index': 3,
          'end_index': 4,
        },
        {'title': 'QUIZ MODUL 1 & 2', 'start_index': 5, 'end_index': 5},
        {
          'title': 'MODUL 3: UKIRAN & SIMBOLISME',
          'start_index': 6,
          'end_index': 7,
        },
        {'title': 'MODUL 4: STUDI KASUS', 'start_index': 8, 'end_index': 9},
        {'title': 'FINAL ASSESSMENT', 'start_index': 10, 'end_index': 10},
      ];
    }
    // 3. Cek Judul Kursus Tari Keraton Jawa (12 Item Total, Index 0-11)
    else if (widget.course.title.contains('Tari Klasik Keraton Jawa')) {
      return const [
        {'title': 'COURSE OVERVIEW', 'start_index': 0, 'end_index': 0},
        {
          'title': 'MODUL 1: FILOSOFI & PERAN',
          'start_index': 1,
          'end_index': 2,
        },
        {'title': 'MODUL 2: TEKNIK DASAR', 'start_index': 3, 'end_index': 4},
        {'title': 'QUIZ MODUL 1 & 2', 'start_index': 5, 'end_index': 5},
        {
          'title': 'MODUL 3: BUSANA & ATRIBUT',
          'start_index': 6,
          'end_index': 8,
        },
        {'title': 'MODUL 4: STUDI KASUS', 'start_index': 9, 'end_index': 10},
        {'title': 'FINAL ASSESSMENT', 'start_index': 11, 'end_index': 11},
      ];
    }

    // 4. Default: Struktur Minangkabau (12 Item Total, Index 0-11)
    return const [
      {'title': 'COURSE OVERVIEW', 'start_index': 0, 'end_index': 0},
      {
        'title': 'MODUL 1: STRUKTUR SOSIAL',
        'start_index': 1,
        'end_index': 3,
      }, // Disesuaikan sedikit
      {'title': 'MODUL 2: PERAN ADAT', 'start_index': 4, 'end_index': 5},
      {'title': 'QUIZ MODUL 1 & 2', 'start_index': 6, 'end_index': 6},
      {'title': 'MODUL 3: RUMAH GADANG', 'start_index': 7, 'end_index': 9},
      {'title': 'MODUL 4: UPACARA ADAT', 'start_index': 10, 'end_index': 11},
      {
        'title': 'SUMMARY AND FINAL ASSESSMENT',
        'start_index': 12,
        'end_index': 12,
      }, // Disesuaikan
    ];
  }
  // >>> END LOGIKA SIDEBAR <<<

  Widget _buildSidebarItem(int index, ModuleContent content) {
    bool isActive = index == _activeModuleIndex;
    IconData leadingIcon = content.isQuiz ? Icons.quiz : Icons.menu_book;

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: isActive ? primaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        leading: Icon(
          leadingIcon,
          color: isActive ? primaryColor : Colors.grey.shade700,
        ),
        title: Text(
          content.title,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive ? primaryColor : darkTextColor,
            fontSize: 14,
          ),
        ),
        trailing: const Icon(Icons.radio_button_off, color: Colors.grey),
        onTap: () {
          setState(() {
            _activeModuleIndex = index;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildDrawerContent() {
    if (courseModules.isEmpty) {
      return const Drawer(
        width: 300,
        child: Center(child: Text("Modul tidak ditemukan untuk kursus ini.")),
      );
    }

    double progress = (_activeModuleIndex + 1) / courseModules.length;
    return Drawer(
      width: 300,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 40.0,
          left: 16.0,
          right: 16.0,
          bottom: 50.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Bar
            const Text(
              'PROGRESS',
              style: TextStyle(fontSize: 12, color: lightTextColor),
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              color: accentColor,
            ),
            const SizedBox(height: 4),
            Text(
              '${(progress * 100).toStringAsFixed(0)}% COMPLETE',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: primaryColor,
              ),
            ),
            const Divider(height: 30, thickness: 1),

            // Daftar Modul dengan Header Pengelompokan
            ...sidebarSections.map((section) {
              List<Widget> items = [];

              items.add(
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 5.0),
                  child: Text(
                    '▼ ${section['title']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: darkTextColor,
                    ),
                  ),
                ),
              );

              for (
                int i = section['start_index'];
                i <= section['end_index'];
                i++
              ) {
                if (i < courseModules.length) {
                  items.add(_buildSidebarItem(i, courseModules[i]));
                }
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    if (courseModules.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada konten modul yang tersedia.',
          style: TextStyle(color: darkTextColor),
        ),
      );
    }
    if (_activeModuleIndex >= courseModules.length) {
      return const Center(
        child: Text(
          'Indeks modul di luar batas.',
          style: TextStyle(color: darkTextColor),
        ),
      );
    }

    final activeItem = courseModules[_activeModuleIndex];
    int totalModules = courseModules.length;
    int lessonNumber = _activeModuleIndex + 1;
    String lessonCount = 'Lesson $lessonNumber of $totalModules';

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Konten
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  activeItem.contentTitle,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: darkTextColor,
                  ),
                ),
              ),
              if (!activeItem.isQuiz)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    lessonCount,
                    style: const TextStyle(fontSize: 14, color: lightTextColor),
                  ),
                ),
            ],
          ),
          const Divider(height: 30),

          // Area Video Player/Konten Visual (Placeholder)
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: activeItem.isQuiz
                  ? const Icon(Icons.assignment, color: Colors.white, size: 60)
                  : const Icon(
                      Icons.ondemand_video,
                      color: Colors.white,
                      size: 60,
                    ),
            ),
          ),
          const SizedBox(height: 20),

          // Teks Materi
          SingleChildScrollView(
            child: Text(
              activeItem.contentText,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: darkTextColor,
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Tombol Navigasi Lanjut
          if (_activeModuleIndex < totalModules - 1)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _activeModuleIndex++;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Lanjut ke Modul Berikutnya',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (_activeModuleIndex == totalModules - 1)
            ElevatedButton(
              onPressed: () {
                // Kembali ke halaman Home
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Selesaikan Kursus',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.course.title,
          style: const TextStyle(
            color: darkTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'EXIT COURSE',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      drawer: _buildDrawerContent(),

      body: SingleChildScrollView(child: _buildMainContent()),
    );
  }
}