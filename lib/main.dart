import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Wajib untuk StreamBuilder
import 'firebase_options.dart';
import 'package:budayapedia/pages/home.dart'; // Import Halaman Dashboard
import 'package:budayapedia/pages/login.dart'; // Import Halaman Login
import 'package:budayapedia/pages/welcome.dart'; // WelcomePage tidak lagi digunakan di sini

void main() async {
  // 1. Wajib ada: Memastikan binding sudah diinisialisasi sebelum memanggil native code.
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 2. Inisialisasi Firebase menggunakan opsi yang dihasilkan oleh FlutterFire CLI
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Menggunakan debugPrint untuk logging yang lebih aman
    debugPrint("Error initializing Firebase: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BudayaPedia App',
      theme: ThemeData(fontFamily: 'DMSans'),

      // VVV LOGIKA UTAMA NAVIGASI APLIKASI VVV
      home: StreamBuilder<User?>(
        // Mendengarkan perubahan status otentikasi (login/logout)
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Tampilkan spinner saat koneksi masih menunggu
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Jika ada data user (berarti user SUDAH LOGIN):
          // Langsung arahkan ke HomePage (Dashboard)
          if (snapshot.hasData && snapshot.data != null) {
            return const WelcomePage();
          }

          // Jika tidak ada data user (belum login/sudah logout):
          // Arahkan ke LoginPage
          // Kita asumsikan WelcomePage adalah halaman login pertama
          return const LoginPage();
        },
      ),
      // ^^^ LOGIKA UTAMA NAVIGASI APLIKASI ^^^
    );
  }
}