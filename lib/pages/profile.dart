import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart'; 
// Import file navigasi
import 'login.dart'; 
import 'security_page.dart';
import 'learning_history_page.dart'; 
import 'badge_collection_page.dart'; 
import 'favorites_page.dart'; 
import 'settings_page.dart'; 
import 'info_hub_page.dart'; // Import InfoHubPage yang baru

// Definisikan warna yang digunakan dalam desain Anda (Konsistensi)
const Color primaryColor = Color(0xFF2C3E50); 
const Color darkTextColor = Color(0xFF1E2A3B);
const Color lightTextColor = Color(0xFF5A6B80);
const Color accentColor = Color(0xFFFFCC33); // Kuning (Level Progress)
const Color successColor = Color(0xFF27AE60); 

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  late String currentUsername;
  final ImagePicker _picker = ImagePicker(); 

  // --- DATA SIMULASI METRIK & LEVEL ---
  final int userStreak = 30;
  final int currentLevel = 10;
  final double progressPercentage = 0.75; 
  final List<Map<String, dynamic>> recentBadges = [
    {'name': 'Jelajah Jawa', 'icon': Icons.location_city, 'color': Colors.orange},
    {'name': 'Maestro Tari', 'icon': Icons.accessibility_new, 'color': Colors.blue},
    {'name': '50 Kuis', 'icon': Icons.quiz, 'color': successColor},
    {'name': 'Pelestari', 'icon': Icons.volunteer_activism, 'color': Colors.purple},
  ];
  // ------------------------------------

  @override
  void initState() {
    super.initState();
    currentUsername = getUsername(user);
  }

  // --- UTILITY FUNGSI ---
  String getUsername(User? user) {
      if (user?.displayName != null && user!.displayName!.isNotEmpty) {
          return user.displayName!;
      } else if (user?.email != null) {
          String emailPrefix = user!.email!.split('@').first;
          return emailPrefix.isNotEmpty 
              ? emailPrefix[0].toUpperCase() + emailPrefix.substring(1).toLowerCase() 
              : 'Pengguna';
      } else {
          return "Pengguna Budayapedia"; 
      }
  }

  Future<void> _handleSignOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal Logout: $e")));
      }
    }
  }

  void _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) _uploadImage(image);
    if (mounted) Navigator.pop(context); 
  }
  void _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) _uploadImage(image);
    if (mounted) Navigator.pop(context); 
  }
  void _uploadImage(XFile image) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mengunggah foto: ${image.name}...",)));
  }
  
  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.all(16.0), child: Text('Foto Profil', style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold, color: darkTextColor))),
            ListTile(leading: const Icon(Icons.camera_alt, color: darkTextColor), title: const Text('Kamera', style: TextStyle(color: darkTextColor)), onTap: _pickImageFromCamera),
            ListTile(leading: const Icon(Icons.photo_library, color: darkTextColor), title: const Text('Galeri', style: TextStyle(color: darkTextColor)), onTap: _pickImageFromGallery),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  void _editUsername() {
    final TextEditingController nameController = TextEditingController(text: currentUsername);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ubah Nama Pengguna"),
          content: TextField(controller: nameController, decoration: const InputDecoration(hintText: "Masukkan nama baru")),
          actions: <Widget>[
            TextButton(child: const Text("Batal", style: TextStyle(color: lightTextColor)), onPressed: () => Navigator.pop(context)),
            ElevatedButton(
              onPressed: () {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  _updateUsername(newName);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateUsername(String newName) async {
    try {
      if (user != null) {
        await user!.updateDisplayName(newName);
        setState(() { currentUsername = newName; });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nama berhasil diperbarui!")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal memperbarui nama: $e")));
    }
  }
  // --- END UTILITY FUNGSI ---
  
  
  // WIDGET KARTU LEVEL/PROGRESS
  Widget _buildLevelProgressCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const LearningHistoryPage()));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor.withOpacity(0.9), primaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tingkat Kemahiran Anda', style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Level $currentLevel: Pewaris Budaya', 
                     style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const Icon(Icons.shield_moon_outlined, color: Colors.white, size: 28),
              ],
            ),
            const SizedBox(height: 10),

            // Progress Bar Visual
            LinearProgressIndicator(
              value: progressPercentage,
              backgroundColor: Colors.white38,
              valueColor: AlwaysStoppedAnimation<Color>(accentColor), 
            ),
            const SizedBox(height: 5),
            Text('${(progressPercentage * 100).toInt()}% menuju Level ${currentLevel + 1}', 
                 style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // WIDGET KARTU STREAK BARU (LEBAR PENUH - FOKUS UTAMA METRIK)
  Widget _buildStreakFullWidthCard() {
    return Container(
      width: double.infinity, 
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 25.0),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.red.withOpacity(0.3), width: 1.5)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_fire_department, color: Colors.red, size: 35),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                userStreak.toString(), 
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: darkTextColor)
              ),
              const Text(
                'Hari Berturut-turut (Streak)', 
                style: TextStyle(fontSize: 12, color: lightTextColor)
              ),
            ],
          ),
        ],
      ),
    );
  }


  // WIDGET KARTU MENU INTERAKTIF
  Widget _buildInteractiveCard(BuildContext context, IconData icon, String title, VoidCallback onTap, {bool isLogout = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: lightTextColor.withOpacity(0.1), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isLogout ? Colors.red.withOpacity(0.1) : primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: isLogout ? Colors.red : primaryColor, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title, 
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.w600,
                  color: isLogout ? Colors.red : darkTextColor
                )
              ),
            ),
            isLogout ? const SizedBox.shrink() : const Icon(Icons.chevron_right, color: lightTextColor),
          ],
        ),
      ),
    );
  }
  
  // WIDGET PREVIEW LENCANA
  Widget _buildBadgesPreview() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Lencana Terbaru', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: lightTextColor)),
          const SizedBox(height: 10),
          
          // TAMPILAN GRID LENCANA
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4, 
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, 
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.0, 
            ),
            itemBuilder: (context, index) {
              final badge = recentBadges[index];
              return Tooltip(
                message: badge['name'] as String,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: badge['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10), 
                    border: Border.all(color: badge['color'], width: 1.5),
                  ),
                  child: Center(
                    child: Icon(
                      badge['icon'] as IconData,
                      color: badge['color'] as Color,
                      size: 28,
                    ),
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 15),
          GestureDetector(
             onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BadgeCollectionPage()),
             ),
             child: const Center(
                child: Text('Lihat Semua Koleksi Lencana', style: TextStyle(color: primaryColor, fontSize: 13, fontWeight: FontWeight.w500)),
             ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final String email = user?.email ?? 'Tidak Tersedia';
    final String photoUrl = user?.photoURL ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun Saya', style: TextStyle(fontWeight: FontWeight.bold, color: darkTextColor)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0), 
        child: Column(
          children: <Widget>[
            // --- 1. Header Profil ---
            Container(
              padding: const EdgeInsets.only(top: 30, bottom: 20),
              width: double.infinity,
              child: Column(
                children: [
                  CircleAvatar(radius: 40, backgroundColor: primaryColor.withOpacity(0.1), backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) as ImageProvider : null, child: photoUrl.isEmpty ? const Icon(Icons.person, size: 40, color: primaryColor) : null),
                  GestureDetector(onTap: _showPhotoOptions, child: const Padding(padding: EdgeInsets.only(top: 8.0), child: Text('Edit', style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.w600)))),
                  const SizedBox(height: 15),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(currentUsername, style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold, color: darkTextColor)),
                    GestureDetector(onTap: _editUsername, child: const Padding(padding: EdgeInsets.only(left: 4.0), child: Icon(Icons.edit, size: 20, color: lightTextColor))),
                  ]),
                  const SizedBox(height: 5),
                  Text(email, style: const TextStyle(fontSize: 14, color: lightTextColor)),
                ],
              ),
            ),
            
            // --- KARTU LEVEL/PROGRESS (UTAMA) ---
            _buildLevelProgressCard(context),

            // --- 2. METRIK PRESTASI (STREAK - LEBAR PENUH) ---
            _buildStreakFullWidthCard(),
            
            // --- PREVIEW LENCANA ---
            _buildBadgesPreview(),


            // --- 3. KELOMPOK MENU: RIWAYAT & KONTEN ---
            const Align(alignment: Alignment.centerLeft, child: Text('Aktivitas Belajar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: lightTextColor))),
            const SizedBox(height: 10),
            
            // RIWAYAT PEMBELAJARAN
            _buildInteractiveCard(context, Icons.history, 'Riwayat Pembelajaran', 
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LearningHistoryPage())),
            ),
            // MATERI FAVORIT
            _buildInteractiveCard(context, Icons.bookmark_border, 'Materi Favorit Saya', 
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoriteContentPage())),
            ),

            // --- 4. KELOMPOK MENU: PENGATURAN & KEAMANAN ---
            const SizedBox(height: 20),
            const Align(alignment: Alignment.centerLeft, child: Text('Pengaturan Akun', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: lightTextColor))),
            const SizedBox(height: 10),

            // KEAMANAN AKUN
            _buildInteractiveCard(context, Icons.lock_outline, 'Keamanan Akun', 
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SecurityPage())),
            ),
            
            // PENGATURAN APLIKASI
            _buildInteractiveCard(context, Icons.settings_outlined, 'Pengaturan Aplikasi', 
               () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()))
            ),
            
            // --- 5. PUSAT INFORMASI & DUKUNGAN (Tombol Tunggal) ---
            const SizedBox(height: 20),
            const Align(alignment: Alignment.centerLeft, child: Text('Dukungan & Info', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: lightTextColor))),
            const SizedBox(height: 10),

            // PUSAT INFORMASI BUDAYAPEDIA (Menggantikan Bantuan, Privasi, dan Tentang)
            _buildInteractiveCard(context, Icons.info_outline, 'Pusat Informasi BudayaPedia', 
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const InfoHubPage())),
            ),


            // --- 6. KELOMPOK MENU: LOGOUT ---
            const SizedBox(height: 30),
            _buildInteractiveCard(context, Icons.logout, 'Logout', _handleSignOut, isLogout: true),
             const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}