// home.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Import file teman Anda:
import 'mycourse.dart'; 
import 'courseview.dart';
// Import file Anda yang sebelumnya (Menggunakan nama file yang Anda konfirmasi):
import 'setting_panel.dart'; 
import 'notifikasi.dart';
import 'welcome.dart'; 
// >>> TAMBAHKAN IMPORT PROFILE BARU <<<
import 'profile.dart'; 

// Definisikan warna yang digunakan dalam desain Anda
const Color primaryColor = Color(0xFF2C3E50);
const Color darkTextColor = Color(0xFF1E2A3B);
const Color lightTextColor = Color(0xFF5A6B80);
const Color navyBlue = Color(0xFF181D31);

// =======================================================
// A. WIDGET UTAMA (PENGELOLA BOTTOM NAVIGATION BAR & UTILITY)
// =======================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Indeks 0 = Home, Indeks 1 = Courses, Indeks 2 = New, Indeks 3 = Account
  int _currentIndex = 0;

  // Fungsi untuk menampilkan Panel Settings (Memanggil SettingsPanel dari setting_panel.dart)
  void _showSideSettingsPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        // Asumsi SettingsPanel ada di setting_panel.dart
        // HATI-HATI: Pastikan 'SettingsPanel' tersedia di file setting_panel.dart
        return const SettingsPanel();
      },
    );
  }

  // Fungsi untuk navigasi ke Halaman Notifikasi (Memanggil NotificationPage dari notifikasi.dart)
  void _navigateToNotifications() {
    Navigator.push(
      context,
      // Asumsi NotificationPage ada di notifikasi.dart
      MaterialPageRoute(builder: (context) => const NotificationPage()), 
    );
  }

  // Daftar widget/halaman yang akan ditampilkan (Menggunakan callback)
  // Perhatikan perubahan di indeks 3!
  late final List<Widget> _pages = [
    // [0] HomeContentWidget sekarang menerima fungsi callback
    HomeContentWidget(
      onNotificationsPressed: _navigateToNotifications,
      onSettingsPressed: _showSideSettingsPanel,
    ), 
    const MyCoursePage(),// [1] Halaman Kursus (dari mycourse.dart)
    const Center(child: Text('Halaman New (Add Box)', style: TextStyle(fontSize: 24, color: darkTextColor))),
    const ProfilePage(), // [3] >>> INI HALAMAN PROFILE BARU ANDA <<<
  ];

  void onTabTapped(int index) {
    // BUG FIX: Jika user mengklik tombol 'Account' saat di tab lain,
    // kita set currentIndex ke 3. Jika user mengklik 'Account' saat sudah di tab 3,
    // tidak perlu melakukan apa-apa, atau bisa juga refresh halaman.
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tampilkan halaman yang sesuai dengan indeks saat ini
      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor, // Warna aktif
        unselectedItemColor: lightTextColor, // Warna tidak aktif
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _currentIndex, // Index aktif saat ini
        onTap: onTabTapped, // Panggil fungsi saat item diklik
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Courses'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'New'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}

// =======================================================
// B. WIDGET KONTEN BERANDA (Konten Scrollable Index 0)
// =======================================================

class HomeContentWidget extends StatelessWidget {
  // Tambahkan callback sebagai properti
  final VoidCallback onNotificationsPressed;
  final VoidCallback onSettingsPressed;

  const HomeContentWidget({
    super.key,
    required this.onNotificationsPressed,
    required this.onSettingsPressed,
  });

  // Widget untuk membuat Card Kategori Course (Sumatera, Jawa, dll.)
  Widget _buildCategoryCard(String title, String imagePath) {
    return Container(
      height: 120,
      width: 150,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
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
  Widget _buildPopularCourseCard(BuildContext context, Course courseData) {
    // Menggunakan data yang di-pass, bukan statis lagi
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Gambar Kursus
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(
              courseData.imageUrl, 
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(height: 200, color: Colors.grey, child: const Center(child: Text("Image Not Found"))),
            ),
          ),
          // Konten Teks
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  courseData.title,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: darkTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  courseData.description,
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
                      child: const Text('Chef William Wongso', style: TextStyle(fontSize: 14)), // Dipertahankan statis
                    ),
                    const SizedBox(width: 10),
                    Text(courseData.duration, style: const TextStyle(color: lightTextColor)),
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
    
    // PERBAIKAN BUG: Mencari kursus Rendang secara spesifik
    // Ganti pencarian Rendang dengan salah satu data kursus yang ada di mycourse.dart,
    // Misal: "Filosofi Adat" atau "Tari Klasik"
    final Course popularCourse = allCourses.firstWhere(
        (course) => course.title.contains("Filosofi"),
        orElse: () => allCourses[0], // Fallback ke kursus pertama jika tidak ditemukan
    );
    
    // Ambil display name pengguna yang login (jika ada)
    final user = FirebaseAuth.instance.currentUser;
    
    // LOGIKA PENGAMBILAN NAMA PENGGUNA (FALLBACK KE EMAIL, SANGAT SEDERHANA)
    final String username;
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      username = user.displayName!;
    } else if (user?.email != null) {
      String emailPrefix = user!.email!.split('@').first;
      
      // Sederhana: Ambil semua sebelum '@' dan kapitalisasi huruf pertama
      username = emailPrefix.isNotEmpty 
          ? emailPrefix[0].toUpperCase() + emailPrefix.substring(1).toLowerCase() 
          : 'Pengguna';
    } else {
      username = "Pengguna"; 
    }


    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // --- 1. Header Profil ---
          Container(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
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
                            color: navyBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.person, color: navyBlue),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tampilkan nama pengguna yang sudah diperbaiki
                            Text('Halo, $username!', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                            const Text('Student', style: TextStyle(color: lightTextColor)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text('Learning Hours - 30 minutes 45 seconds ago', style: TextStyle(color: lightTextColor, fontSize: 12)),
                  ],
                ),
                // Ikon Notifikasi dan Pengaturan (MENGGUNAKAN CALLBACK)
                Row(
                  children: [
                    // Notifikasi
                    IconButton(
                      icon: const Icon(Icons.notifications_none, color: lightTextColor),
                      onPressed: onNotificationsPressed,
                    ),
                    const SizedBox(width: 5),
                    // Pengaturan
                    IconButton(
                      icon: const Icon(Icons.settings_outlined, color: lightTextColor),
                      onPressed: onSettingsPressed,
                    ),
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

          // --- 3. Popular Course Card (Menggunakan data dari allCourses) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GestureDetector(
            onTap: () {
              // Navigasi ke CourseDetailsView dengan membawa data popularCourse
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CourseDetailsView(course: popularCourse)),
              );
              },
            child: _buildPopularCourseCard(context, popularCourse), // Menggunakan data yang sudah disesuaikan
            ),
          ),

          // --- 4. Course Categories Header ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Kategori Course', style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    // Pindah ke tab Courses (Index 1) saat View All diklik
                    final _HomePageState? state = context.findAncestorStateOfType<_HomePageState>();
                    state?.onTabTapped(1); 
                  },
                  child: const Text('View all', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // --- 5. Course Categories (Horizontal Scroll) ---
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              // Menggunakan list kursus penuh
              itemCount: allCourses.length, 
              itemBuilder: (context, index) {
                final course = allCourses[index];
                
                // Pengecekan: Lewati kursus yang sama dengan 'Popular Sekarang'
                if (course.title.contains("Filosofi") && popularCourse == course) return const SizedBox.shrink(); 
                
                return GestureDetector(
                    onTap: () {
                      // Navigasi kategori juga harus ke detail kursus terkait
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CourseDetailsView(course: course)),
                      );
                    },
                    // Menggunakan kategori dan gambar kursus
                    child: _buildCategoryCard(course.category, course.imageUrl), 
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // --- 6. Premium Section ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: navyBlue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 24),
                      const SizedBox(width: 8),
                      Text('BudayaPedia Premium', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Lebih banyak course. Lebih banyak pengetahuan.', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 15),
                  const Text('Daftar ke BudayaPedia Premium dan dapatkan akses instan ke lebih banyak materi pembelajaran budaya favorit Anda serta manfaat premium lainnya.',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: darkTextColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    ),
                    child: const Text('Pelajari Lebih Lanjut', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}