import 'package:flutter/material.dart';

// Definisikan warna (Konsisten)
const Color primaryColor = Color(0xFF2C3E50); 
const Color darkTextColor = Color(0xFF1E2A3B);
const Color lightTextColor = Color(0xFF5A6B80);
const Color progressColor = Color(0xFF3498DB); // Biru untuk Progress
const Color successColor = Color(0xFF27AE60);

class FavoriteContentPage extends StatelessWidget {
  const FavoriteContentPage({super.key});

  // --- DATA SIMULASI MATERI FAVORIT ---
  final List<Map<String, dynamic>> favoriteContents = const [
    {
      'title': 'Teknik Dasar Membatik Tulis',
      'category': 'Seni & Kerajinan',
      'progress': 0.75, // 75% selesai
      'imageUrl': 'assets/images/batik.jpg', // Placeholder
    },
    {
      'title': 'Sejarah Singkat Wayang Kulit',
      'category': 'Sejarah',
      'progress': 1.0, // Selesai
      'imageUrl': 'assets/images/wayang.jpg', // Placeholder
    },
    {
      'title': 'Filosofi Gerak Tari Saman',
      'category': 'Seni Pertunjukan',
      'progress': 0.20, // 20% selesai
      'imageUrl': 'assets/images/saman.jpg', // Placeholder
    },
    {
      'title': 'Arsitektur Rumah Adat Minangkabau',
      'category': 'Arsitektur',
      'progress': 0.0, // Belum dimulai
      'imageUrl': 'assets/images/rumah_adat.jpg', // Placeholder
    },
  ];

  // Widget Kartu Materi Favorit
  Widget _buildFavoriteCard(BuildContext context, Map<String, dynamic> content) {
    final bool isCompleted = content['progress'] == 1.0;

    return GestureDetector(
      onTap: () {
        // Navigasi ke detail materi/kursus
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Membuka materi: ${content['title']}')),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Gambar/Visual
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Container(
                height: 120,
                width: double.infinity,
                color: primaryColor.withOpacity(0.1), // Placeholder warna
                child: const Center(child: Icon(Icons.collections_bookmark, size: 40, color: primaryColor)),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Kategori
                  Text(
                    content['category'] as String,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: progressColor),
                  ),
                  const SizedBox(height: 5),
                  
                  // 3. Judul
                  Text(
                    content['title'] as String,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkTextColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),

                  // 4. Progress Bar & Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isCompleted ? 'Selesai' : '${(content['progress'] * 100).toInt()}% Selesai',
                        style: TextStyle(fontSize: 13, color: isCompleted ? successColor : lightTextColor),
                      ),
                      Icon(
                        isCompleted ? Icons.check_circle : Icons.bookmark_added_outlined,
                        color: isCompleted ? successColor : lightTextColor,
                        size: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  LinearProgressIndicator(
                    value: content['progress'] as double,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(isCompleted ? successColor : progressColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Materi Favorit Saya', style: TextStyle(fontWeight: FontWeight.bold, color: darkTextColor)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: favoriteContents.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 80, color: lightTextColor.withOpacity(0.5)),
                  const SizedBox(height: 15),
                  const Text('Belum ada materi favorit!', style: TextStyle(fontSize: 18, color: lightTextColor)),
                  const SizedBox(height: 5),
                  const Text('Tambahkan materi yang ingin Anda simpan dari kursus.', style: TextStyle(fontSize: 14, color: lightTextColor)),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: favoriteContents.map((content) {
                  return _buildFavoriteCard(context, content);
                }).toList(),
              ),
            ),
    );
  }
}