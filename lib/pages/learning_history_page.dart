// learning_history_page.dart (KODE FINAL YANG SUDAH DIKOREKSI)

import 'package:flutter/material.dart';

class LearningHistoryPage extends StatelessWidget {
  const LearningHistoryPage({super.key});

  // Data contoh riwayat pembelajaran
  final List<Map<String, String>> historyData = const [
    {'title': 'Mengenal Tari Saman', 'date': '10 Des 2025', 'status': 'Selesai'},
    {'title': 'Sejarah Keris di Jawa', 'date': '05 Des 2025', 'status': 'Selesai'},
    {'title': 'Kuliner Nusantara: Rendang', 'date': '28 Nov 2025', 'status': 'Selesai'},
    {'title': 'Arsitektur Rumah Adat Minangkabau', 'date': '15 Nov 2025', 'status': 'Selesai'},
  ];

  @override
  Widget build(BuildContext context) {
    // Definisikan warna yang sama agar konsisten dengan halaman Profil
    const Color darkTextColor = Color(0xFF212121);
    const Color lightTextColor = Color(0xFF757575);
    const Color primaryColor = Color(0xFF1F3A4B);
    const Color accentColor = Color(0xFF00BFA5);
    const Color backgroundColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Riwayat Pembelajaran', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: backgroundColor,
        elevation: 0,
        foregroundColor: primaryColor, // Menggunakan warna primer untuk ikon back
      ),
      body: historyData.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Text(
                  'Anda belum menyelesaikan pembelajaran apa pun. Mari mulai belajar budaya baru!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: lightTextColor, fontSize: 16),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              itemCount: historyData.length,
              itemBuilder: (context, index) {
                final item = historyData[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    minVerticalPadding: 10,
                    
                    // Ikon sebagai penanda Selesai (Menggunakan warna Aksen)
                    leading: const Icon(Icons.check_circle_outline, color: accentColor, size: 28),
                    
                    title: Text(
                      item['title']!,
                      style: const TextStyle(fontWeight: FontWeight.w600, color: darkTextColor, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Selesai pada: ${item['date']!}', // Ditambahkan Null Safety
                        style: const TextStyle(color: lightTextColor, fontSize: 13),
                      ),
                    ),
                    
                    // Menambahkan garis pemisah yang tipis
                    trailing: Icon(Icons.arrow_forward_ios, color: lightTextColor.withOpacity(0.5), size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Membuka detail ${item['title']}")));
                    },
                  ),
                );
              },
            ),
    );
  }
}