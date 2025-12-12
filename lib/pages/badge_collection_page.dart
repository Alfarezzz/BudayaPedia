// badge_collection_page.dart (Final Fix UI - Memastikan Data Terlihat)

import 'package:flutter/material.dart';

// Definisikan warna yang digunakan (Konsisten dengan profile.dart)
const Color primaryColor = Color(0xFF2C3E50); 
const Color darkTextColor = Color(0xFF1E2A3B);
const Color lightTextColor = Color(0xFF5A6B80);
const Color successColor = Color(0xFF27AE60); 

class BadgeCollectionPage extends StatelessWidget {
  const BadgeCollectionPage({super.key});

  // --- DATA SIMULASI LENCANA ---
  // Lencana yang Sudah Diperoleh
  final List<Map<String, dynamic>> acquiredBadges = const [
    {'name': 'Maestro Tari', 'desc': 'Sempurnakan 5 Kuis Tari berturut-turut.', 'icon': Icons.accessibility_new, 'color': Colors.blue},
    {'name': 'Jelajah Jawa', 'desc': 'Selesaikan 100% Modul Budaya Jawa.', 'icon': Icons.location_city, 'color': Colors.orange},
    {'name': 'Pakar Kuis', 'desc': 'Lulus 50 Kuis apa pun.', 'icon': Icons.quiz, 'color': successColor},
    // Tambahkan 1 item lagi agar terlihat lebih baik di Grid 2x2
    {'name': 'Historian', 'desc': 'Baca 10 Artikel Sejarah Indonesia.', 'icon': Icons.book_outlined, 'color': Colors.brown},
  ];

  // Lencana yang Belum Diperoleh
  final List<Map<String, dynamic>> lockedBadges = const [
    {'name': 'Pelestari', 'desc': 'Berbagi 10 materi BudayaPedia ke media sosial.', 'icon': Icons.volunteer_activism, 'color': Colors.purple},
    {'name': 'Ahli Waris Adat', 'desc': 'Selesaikan 10 Kursus di kategori Adat/Tradisi.', 'icon': Icons.elderly, 'color': Colors.brown},
    {'name': 'Pejuang Streak', 'desc': 'Capai Rentetan Belajar 90 Hari.', 'icon': Icons.local_fire_department, 'color': Colors.red},
  ];
  // ------------------------------

  // Widget untuk menampilkan kotak Lencana
  Widget _buildBadgeItem(Map<String, dynamic> badge, bool isAcquired) {
    final color = isAcquired ? badge['color'] : lightTextColor.withOpacity(0.5);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isAcquired ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Mulai dari atas
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ikon Lencana
          Icon(
            badge['icon'] as IconData,
            color: color,
            size: 40, // Ikon lebih besar
          ),
          const SizedBox(height: 10),
          // Nama Lencana
          Text(
            badge['name'] as String,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isAcquired ? darkTextColor : lightTextColor,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          // Deskripsi
          Text(
            badge['desc'] as String,
            textAlign: TextAlign.center,
            maxLines: 3, 
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isAcquired ? lightTextColor : lightTextColor.withOpacity(0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Solusi 1: Pastikan latar belakang berwarna putih agar terlihat jelas
      backgroundColor: Colors.white, 
      appBar: AppBar(
        title: const Text('Koleksi Lencana', style: TextStyle(fontWeight: FontWeight.bold, color: darkTextColor)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- 1. LENCANA DIPEROLEH ---
            const Text(
              'Lencana Saya',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkTextColor),
            ),
            const SizedBox(height: 15),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: acquiredBadges.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.8, // Rasio disesuaikan agar konten muat
              ),
              itemBuilder: (context, index) {
                return _buildBadgeItem(acquiredBadges[index], true);
              },
            ),

            const SizedBox(height: 40),

            // --- 2. LENCANA BELUM DIPEROLEH (LOCKED) ---
            const Text(
              'Tantangan Berikutnya',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkTextColor),
            ),
            const SizedBox(height: 15),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lockedBadges.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.8, 
              ),
              itemBuilder: (context, index) {
                // Gunakan ColorFilter pada Ikon saja jika Anda ingin membiarkan teks terlihat
                final badge = lockedBadges[index];
                
                return Opacity( // Meredupkan seluruh kartu agar terlihat Locked
                  opacity: 0.6, 
                  child: _buildBadgeItem(badge, false),
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}