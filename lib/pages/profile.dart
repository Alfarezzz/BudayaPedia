import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart'; 
import 'dart:io'; 

// Import file navigasi yang diperlukan
import 'login.dart'; 
import 'security_page.dart';
import 'settings_page.dart'; 
import 'info_hub_page.dart'; 
import 'learning_history_page.dart'; 

const Color primaryColor = Color(0xFF1F3A4B); // Biru Tua (Deep Navy)
const Color darkTextColor = Color(0xFF212121); // Hitam Pekat
const Color lightTextColor = Color(0xFF757575); // Abu-abu Medium
const Color accentColor = Color(0xFF00BFA5); // Teal / Hijau Mint (Aksen Soft/Premium)
const Color backgroundColor = Colors.white; // Background putih bersih
const Color criticalColor = Color(0xFFB71C1C); // Merah Tua/Maroon (Profesional Red)


// Placeholder Pages (Tetap)
class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hapus Akun')),
      body: const Center(child: Text('Halaman konfirmasi penghapusan akun permanen.')),
    );
  }
}


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  late String currentUsername;
  final ImagePicker _picker = ImagePicker(); 
  File? _selectedImageFile; 

  @override
  void initState() {
    super.initState();
    currentUsername = getUsername(user);
  }

  // --- UTILITY FUNGSI (SAMA) ---
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
  
  void _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImageFile = File(image.path);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Foto profil diperbarui (Lokal)!")));
      }
    }
    if (mounted) Navigator.pop(context); 
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
            ListTile(leading: const Icon(Icons.camera_alt, color: darkTextColor), title: const Text('Kamera', style: TextStyle(color: darkTextColor)), onTap: () => _pickImage(ImageSource.camera)),
            ListTile(leading: const Icon(Icons.photo_library, color: darkTextColor), title: const Text('Galeri', style: TextStyle(color: darkTextColor)), onTap: () => _pickImage(ImageSource.gallery)),
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
                  setState(() { currentUsername = newName; });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nama berhasil diperbarui!")));
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
  // --- END UTILITY FUNGSI ---


  // WIDGET KHUSUS: ITEM MENU BORDERLESS
  Widget _buildBorderlessMenuItem(
      {required IconData icon, required String title, required VoidCallback onTap, required Color itemColor, bool isLogout = false}) {
    
    // Logika Warna Ikon: Jika Logout, pakai Critical; jika tidak, pakai itemColor (Primary/Accent)
    final Color iconColor = isLogout ? criticalColor : itemColor;
    final Color textColor = isLogout ? criticalColor : darkTextColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0), 
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        minLeadingWidth: 20,
        leading: Icon(icon, color: iconColor, size: 24),
        title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor)),
        trailing: Icon(Icons.chevron_right, color: lightTextColor.withOpacity(0.8)),
        onTap: onTap,
      ),
    );
  }

  // WIDGET KHUSUS: GROUP MENU BORDERLESS
  Widget _buildMenuGroup(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 10, left: 0),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(fontSize: 13, letterSpacing: 0.5, fontWeight: FontWeight.w700, color: lightTextColor),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10), 
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }


  // WIDGET HEADER TERINTEGRASI
  Widget _buildProfileHeader(String email) {
    ImageProvider? imageProvider;
    
    if (_selectedImageFile != null) {
      imageProvider = FileImage(_selectedImageFile!);
    } else if (user?.photoURL != null && user!.photoURL!.isNotEmpty) {
      imageProvider = NetworkImage(user!.photoURL!);
    }
    
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 40),
      width: double.infinity,
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Foto Profil
          Stack(
            children: [
              CircleAvatar(
                radius: 40, 
                backgroundColor: primaryColor.withOpacity(0.1), 
                backgroundImage: imageProvider, 
                child: imageProvider == null ? const Icon(Icons.person, size: 40, color: primaryColor) : null
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _showPhotoOptions, 
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: primaryColor, 
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, size: 14, color: backgroundColor),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // 2. Nama Pengguna
          Row(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              Text(
                currentUsername, 
                style: const TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.w900, 
                  color: darkTextColor
                )
              ),
              GestureDetector(
                onTap: _editUsername, 
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 4.0), 
                  child: Icon(Icons.mode_edit_outline, size: 18, color: lightTextColor.withOpacity(0.8)) 
                )
              ),
            ]
          ),
          const SizedBox(height: 5),
          
          // 3. Email
          Text(email, style: const TextStyle(fontSize: 15, color: lightTextColor)),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final String email = user?.email ?? 'Tidak Tersedia';

    return Scaffold(
      backgroundColor: backgroundColor, 
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0, 
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- 1. HEADER PROFIL TERINTEGRASI ---
            _buildProfileHeader(email), 
            
            // --- 2. GROUP: AKTIVITAS & RIWAYAT ---
            _buildMenuGroup(
              'Aktivitas',
              [
                _buildBorderlessMenuItem(
                  icon: Icons.history_toggle_off, 
                  title: 'Riwayat Pembelajaran', 
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LearningHistoryPage())),
                  itemColor: primaryColor, // WARNA Ikon SAMA: Primary
                ),
              ],
            ),
            
            // --- 3. GROUP: PENGATURAN & KEAMANAN ---
            _buildMenuGroup(
              'Pengaturan & Keamanan',
              [
                _buildBorderlessMenuItem(
                  icon: Icons.lock_outline, 
                  title: 'Keamanan Akun', 
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SecurityPage())),
                  itemColor: primaryColor, // WARNA Ikon SAMA: Primary
                ),
                _buildBorderlessMenuItem(
                  icon: Icons.settings_outlined, 
                  title: 'Pengaturan Aplikasi', 
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())),
                  itemColor: primaryColor, // WARNA Ikon SAMA: Primary
                ),
              ],
            ),
            
            // --- 4. GROUP: DUKUNGAN & INFORMASI (Helpdesk dihapus) ---
            _buildMenuGroup(
              'Dukungan & Informasi',
              [
                _buildBorderlessMenuItem(
                  icon: Icons.info_outline, 
                  title: 'Pusat Informasi BudayaPedia', 
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const InfoHubPage())),
                  itemColor: accentColor, // WARNA Ikon SAMA: Accent
                ),
              ],
            ),

            // --- 5. TINDAKAN KRITIS (Hanya Logout) ---
            _buildMenuGroup(
              'Tindakan',
              [
                _buildBorderlessMenuItem(
                  icon: Icons.logout, 
                  title: 'Logout', 
                  onTap: _handleSignOut, 
                  itemColor: criticalColor, 
                  isLogout: true, 
                ),
              ],
            ),
            
             const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}