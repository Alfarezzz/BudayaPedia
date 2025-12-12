// learning_history_page.dart (KOREKSI FINAL TANPA SIMBOL NAVIGASI)

import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF2C3E50);
const Color darkTextColor = Color(0xFF1E2A3B);
const Color lightTextColor = Color(0xFF5A6B80);
const Color accentColor = Color(0xFFFFCC33); 

class LearningHistoryPage extends StatelessWidget {
  const LearningHistoryPage({super.key});

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: primaryColor, size: 28),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkTextColor)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 14, color: lightTextColor)),
          ],
        ),
      ),
    );
  }

  // Widget ini disederhanakan (Simbol panah dihapus)
  Widget _buildRecentActivity(String title, String time) {
    return ListTile(
      leading: const Icon(Icons.check_circle_outline, color: primaryColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(time, style: const TextStyle(color: lightTextColor)),
      // trailing dihapus untuk menghilangkan ikon panah
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pembelajaran', style: TextStyle(fontWeight: FontWeight.bold, color: darkTextColor)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Statistik
            const Text('Statistik Anda', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkTextColor)),
            const SizedBox(height: 10),
            
            // Grid Statistik
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildStatCard('Jam Belajar', '53h 45m', Icons.timer),
                _buildStatCard('Kursus Selesai', '5', Icons.school),
                _buildStatCard('Lencana Diperoleh', '7', Icons.workspace_premium), 
                _buildStatCard('Kuis Lulus', '28', Icons.quiz),
              ],
            ),

            const SizedBox(height: 25),
            
            // Riwayat Aktivitas Terbaru
            const Text('Aktivitas Terbaru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkTextColor)),
            const SizedBox(height: 10),
            
            _buildRecentActivity('Menyelesaikan Kuis Tari Bedhaya', '30 menit lalu'),
            _buildRecentActivity('Mulai Course Manik-Manik Dayak', '2 jam lalu'),
            _buildRecentActivity('Mendapat Lencana "Pelestari Adat"', 'Kemarin'),
            _buildRecentActivity('Menonton video: Arsitektur Rumah Gadang', '2 hari lalu'),
          ],
        ),
      ),
    );
  }
}