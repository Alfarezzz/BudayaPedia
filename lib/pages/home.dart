import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Untuk mendapatkan nama pengguna (opsional)

// Definisikan warna yang digunakan dalam desain Anda
const Color primaryColor = Color(0xFF2C3E50); // Biru gelap (untuk tombol premium)
const Color darkTextColor = Color(0xFF1E2A3B);
const Color lightTextColor = Color(0xFF5A6B80);
const Color navyBlue = Color(0xFF181D31); // Warna background premium section

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Widget untuk membuat Card Kategori Course (Sumatera, Jawa, dll.)
  Widget _buildCategoryCard(String title, String imagePath) {
    return Container(
      height: 120,
      width: 150, // Sesuaikan lebar jika ini di dalam ListView horizontal
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3), // Efek gelap
            BlendMode.darken,
          ),
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan Course yang sedang Populer
  Widget _buildPopularCourseCard(BuildContext context) {
    // Data Course Rendang
    const String courseTitle = "Rendang dan Filosofi Kekuatan Rasa Minangkabau";
    const String instructor = "Chef William Wongso";
    const String duration = "1h 50m";
    const String courseDesc = "Selami sejarah, bumbu rahasia (santan kelapa dan rempah), dan makna filosofis Rendang sebagai simbol kekuatan dan ketahanan suku Minangkabau.";
    const String imagePath = 'assets/images/rendang_masterclass.png'; // Path gambar rendang baru Anda

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Gambar Rendang
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(
              'assets/rendang.png',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Konten Teks
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  courseTitle,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: darkTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  courseDesc,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: lightTextColor,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // Instruktur dan Durasi
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        minimumSize: Size.zero,
                      ),
                      child: Text(instructor, style: const TextStyle(fontSize: 14)),
                    ),
                    const SizedBox(width: 10),
                    Text(duration, style: const TextStyle(color: lightTextColor)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil display name pengguna yang login (jika ada)
    final user = FirebaseAuth.instance.currentUser;
    final username = user?.displayName ?? "Username";

    return Scaffold(
      // Tidak menggunakan AppBar karena desain menggunakan Custom Header di Body
      body: SingleChildScrollView( // Widget Wajib agar bisa discroll
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- 1. Header Profil (Menggantikan AppBar) ---
            Container(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
              decoration: const BoxDecoration(
                // Tambahkan dekorasi header jika perlu (misalnya warna latar)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container( // Placeholder Foto Profil
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: navyBlue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(username, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                              const Text('Student', style: TextStyle(color: lightTextColor)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Text('Learning Hours - 30 minutes 45 seconds ago', style: TextStyle(color: lightTextColor, fontSize: 12)),
                    ],
                  ),
                  // Ikon Pengaturan
                  Row(
                    children: const [
                      Icon(Icons.notifications_none, color: lightTextColor),
                      SizedBox(width: 10),
                      Icon(Icons.settings_outlined, color: lightTextColor),
                    ],
                  ),
                ],
              ),
            ),

            // --- 2. Popular Now Header ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Popular Sekarang', style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold)),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.flash_on, size: 16),
                    label: const Text('For You', style: TextStyle(fontSize: 14)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFCC33),
                      foregroundColor: darkTextColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      minimumSize: Size.zero,
                    ),
                  ),
                ],
              ),
            ),

            // --- 3. Popular Course Card (Rendang) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildPopularCourseCard(context),
            ),

            // --- 4. Course Categories Header ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Kategori Course', style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View all', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            // --- 5. Course Categories (Horizontal Scroll) ---
            SizedBox(
              height: 120, // Tinggi untuk semua kategori card
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                children: [
                  _buildCategoryCard('Sumatera', 'assets/sumatra.jpg'), // Ganti path
                  _buildCategoryCard('Jawa', 'assets/jawa.jpg'), // Ganti path
                  _buildCategoryCard('Kalimantan', 'assets/kalimantan.jpg'), // Ganti path
                  _buildCategoryCard('Sulawesi', 'assets/sulawesi.jpg'),
                  _buildCategoryCard('Papua', 'assets/papua.jpg'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- 6. Premium Section ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: navyBlue, // Warna biru tua
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 24),
                        const SizedBox(width: 8),
                        Text('LearniO Premium', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('More courses. More learning.', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 15),
                    const Text('Sign up for LearniO Premium and instantly access more of your favorite learning material and gain premium perks and benefits.',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: darkTextColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      ),
                      child: const Text('Learn More', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20), // Memberi ruang di bagian bawah
          ],
        ),
      ),

      // --- 7. Bottom Navigation Bar ---
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor, // Warna aktif
        unselectedItemColor: lightTextColor, // Warna tidak aktif
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'New'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}