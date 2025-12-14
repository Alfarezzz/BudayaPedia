import 'package:flutter/material.dart';

// Definisikan warna yang digunakan (Konsisten)
const Color primaryColor = Color(0xFF2C3E50); 
const Color darkTextColor = Color(0xFF1E2A3B);
const Color lightTextColor = Color(0xFF5A6B80);

class InfoHubPage extends StatelessWidget {
  const InfoHubPage({super.key});

  // Data Konten Statis
  static const Map<String, String> _contentData = {
    'Bantuan & FAQ': 
        "FAQ:\n"
        "1. Bagaimana cara mengubah sandi? Anda dapat mengubah sandi melalui menu Akun > Keamanan Akun.\n"
        "2. Bagaimana cara melihat kemajuan belajar? Kunjungi Riwayat Pembelajaran dari halaman profil.\n"
        "3. Dukungan: Hubungi kami di support@budayapedia.id.",
        
    'Kebijakan Privasi': 
        "Kebijakan Privasi BudayaPedia (Versi 2.1)\n\n"
        "Kami menghargai privasi Anda. Data pengguna (nama, email, riwayat belajar) dikumpulkan untuk tujuan personalisasi pengalaman belajar Anda. Kami tidak akan menjual atau menyewakan informasi pribadi Anda kepada pihak ketiga. Semua data sensitif dienkripsi dan dijamin keamanannya.",
        
    'Tentang Kami': 
        "BudayaPedia didirikan dengan visi melestarikan dan menyebarkan warisan budaya Indonesia kepada generasi muda melalui platform digital yang interaktif dan menyenangkan. Kami berkomitmen untuk menyediakan konten yang akurat dan mudah diakses. Terima kasih telah menjadi Pelestari Budaya!",
  };

  // Widget untuk menampilkan setiap bagian konten (FAQ, Privasi, Tentang)
  Widget _buildContentSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul Section
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          // Isi Konten
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: darkTextColor,
              height: 1.5,
            ),
          ),
          
          if (title == 'Tentang Kami') 
             Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  'BudayaPedia Versi 1.5.2',
                  style: TextStyle(fontSize: 12, color: lightTextColor.withOpacity(0.6)),
                ),
             ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Pusat Informasi BudayaPedia', style: TextStyle(fontWeight: FontWeight.bold, color: darkTextColor)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Akses semua informasi yang Anda butuhkan tentang BudayaPedia di sini.',
              style: TextStyle(fontSize: 14, color: lightTextColor),
            ),
            const SizedBox(height: 30),

            // --- 1. BANTUAN & FAQ (KONTEN LANGSUNG) ---
            _buildContentSection(
              'Bantuan & FAQ',
              _contentData['Bantuan & FAQ']!,
            ),

            // --- 2. KEBIJAKAN PRIVASI (KONTEN LANGSUNG) ---
            _buildContentSection(
              'Kebijakan Privasi',
              _contentData['Kebijakan Privasi']!,
            ),

            // --- 3. TENTANG KAMI (KONTEN LANGSUNG) ---
            _buildContentSection(
              'Tentang Kami',
              _contentData['Tentang Kami']!,
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}