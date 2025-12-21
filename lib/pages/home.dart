import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Import Halaman Utama Lain:
import 'mycourse.dart';
import 'courseview.dart';
import 'setting_panel.dart';
import 'notifikasi.dart';
// Import Halaman Akun (Menggunakan konvensi nama file standar):
import 'profile.dart'; // Ganti dari 'profile.dart'
// >>> IMPORT MODEL DATA TUNGGAL <<<
import 'course_model.dart';
// >>> END IMPORT MODEL DATA TUNGGAL <<<
import 'add_course.dart';

// Definisikan warna yang digunakan dalam desain Anda
const Color primaryColor = Color(0xFF2C3E50);
const Color darkTextColor = Color(0xFF1E2A3B);
const Color lightTextColor = Color(0xFF5A6B80);
const Color navyBlue = Color(0xFF181D31);

// =======================================================
// C. MODEL DATA KURSUS (DIHAPUS DARI SINI, DIPINDAHKAN KE course_model.dart)
// =======================================================
// HAPUS: class Course {...}
// HAPUS: const List<Course> allCourses = [...]

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

  void _showSideSettingsPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const SettingsPanel();
      },
    );
  }

  void _navigateToNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationPage()),
    );
  }

  // Daftar widget/halaman yang akan ditampilkan
 late final List<Widget> _pages = [
  // [0] Home
  HomeContentWidget(
    onNotificationsPressed: _navigateToNotifications,
    onSettingsPressed: _showSideSettingsPanel,
  ),
  MyCoursePage(), // [1] Halaman Kursus (dari mycourse.dart)
  const AddCoursePage(), // [2] Halaman Add Course ← UBAH DI SINI
  const ProfilePage(), // [3] Halaman Account
];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: lightTextColor,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
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
  final VoidCallback onNotificationsPressed;
  final VoidCallback onSettingsPressed;

  const HomeContentWidget({
    super.key,
    required this.onNotificationsPressed,
    required this.onSettingsPressed,
  });

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

  Widget _buildPopularCourseCard(BuildContext context, Course courseData) {
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
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: Colors.grey,
                child: const Center(child: Text("Image Not Found")),
              ),
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
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(color: lightTextColor),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size.zero,
                      ),
                      child: const Text(
                        'Chef William Wongso',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      courseData.duration,
                      style: const TextStyle(color: lightTextColor),
                    ),
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
    // Mencari kursus Rendang secara spesifik
    final Course popularCourse = allCourses.firstWhere(
      (course) => course.title.contains("Rendang"),
      orElse: () => allCourses[0],
    );

    // Ambil display name pengguna yang login (jika ada)
    final user = FirebaseAuth.instance.currentUser;

    // LOGIKA PENGAMBILAN NAMA PENGGUNA
    final String username;
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      username = user.displayName!;
    } else if (user?.email != null) {
      String emailPrefix = user!.email!.split('@').first;
      username = emailPrefix.isNotEmpty
          ? emailPrefix[0].toUpperCase() +
                emailPrefix.substring(1).toLowerCase()
          : 'Pengguna';
    } else {
      username = "Pengguna";
    }

    // Filter kategori unik (menghilangkan Rendang yang sudah ada di Popular Now)
    final List<Course> uniqueCategoryCourses = allCourses
        .where((course) => course.title != popularCourse.title)
        .toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // --- 1. Header Profil ---
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          // Placeholder Foto Profil
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
                            Text(
                              'Halo, $username!',
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              'Student',
                              style: TextStyle(color: lightTextColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Learning Hours - 30 minutes 45 seconds ago',
                      style: TextStyle(color: lightTextColor, fontSize: 12),
                    ),
                  ],
                ),
                // Ikon Notifikasi dan Pengaturan
                Row(
                  children: [
                    // Notifikasi
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none,
                        color: lightTextColor,
                      ),
                      onPressed: onNotificationsPressed,
                    ),
                    const SizedBox(width: 5),
                    // Pengaturan
                    IconButton(
                      icon: const Icon(
                        Icons.settings_outlined,
                        color: lightTextColor,
                      ),
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
                Text(
                  'Popular Sekarang',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.flash_on, size: 16),
                  label: const Text('For You', style: TextStyle(fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFCC33),
                    foregroundColor: darkTextColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    minimumSize: Size.zero,
                  ),
                ),
              ],
            ),
          ),

          // --- 3. Popular Course Card (Rendang) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GestureDetector(
              onTap: () {
                // Navigasi ke CourseDetailsView dengan membawa data Rendang (popularCourse)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CourseDetailsView(course: popularCourse),
                  ),
                );
              },
              child: _buildPopularCourseCard(
                context,
                popularCourse,
              ), // Menggunakan data Rendang
            ),
          ),

          // --- 4. Course Categories Header ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Kategori Course',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View all',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
              itemCount: uniqueCategoryCourses
                  .length, // Menggunakan daftar yang sudah difilter
              itemBuilder: (context, index) {
                final course = uniqueCategoryCourses[index];

                return GestureDetector(
                  onTap: () {
                    // Navigasi kategori juga harus ke detail kursus terkait
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetailsView(course: course),
                      ),
                    );
                  },
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
                      Text(
                        'LearniO Premium',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'More courses. More learning.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Sign up for LearniO Premium and instantly access more of your favorite learning material and gain premium perks and benefits.',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: darkTextColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Learn More',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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