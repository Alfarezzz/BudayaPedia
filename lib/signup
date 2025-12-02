// pages/signup.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'welcome.dart'; // Asumsikan Anda ingin kembali ke WelcomePage

// Definisi Konstanta Warna (Sama dengan login.dart)
const Color primaryColor = Color(0xFF2C3E50); // Biru Gelap
const Color textColor = Color(0xFF1E2A3B);  // Teks Gelap
const Color grayColor = Color(0xFF5A6B80);  // Teks Abu-abu

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Fungsi untuk menangani pendaftaran (Sign Up)
  Future<void> _handleSignUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        _errorMessage = "Password tidak cocok.";
      });
      return;
    }

    // Pengecekan dasar panjang password (Firebase meminta minimal 6 karakter)
    if (passwordController.text.length < 6) {
       setState(() {
        _errorMessage = "Password minimal 6 karakter.";
      });
      return;
    }


    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. Panggil metode pendaftaran Firebase
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 2. Navigasi ke halaman utama setelah pendaftaran berhasil
      if (mounted) {
        // Menggunakan pushReplacement untuk mencegah user kembali ke halaman Sign Up
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const WelcomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // 3. Tangani error dari Firebase
      String message = "Terjadi kesalahan saat pendaftaran.";
      if (e.code == 'weak-password') {
        message = 'Password terlalu lemah.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email ini sudah terdaftar.';
      } else if (e.code == 'invalid-email') {
        message = 'Format email tidak valid.';
      }
      setState(() {
        _errorMessage = message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan umum: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Set warna latar belakang AppBar menjadi putih atau transparan untuk look modern
        backgroundColor: Colors.white, 
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryColor), // Warna ikon panah kembali
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Judul dan Subjudul (Menggunakan warna Biru Gelap)
            Text(
              "Buat Akun BudayaPedia",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor, // Warna teks gelap untuk judul
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Jelajahi warisan budaya dengan akun Anda.",
              style: TextStyle(fontSize: 16, color: grayColor), // Warna abu-abu
            ),
            const SizedBox(height: 40),

            // Bidang Email
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined, color: grayColor),
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                labelStyle: const TextStyle(color: grayColor),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryColor, width: 2.0),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Bidang Password
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password (min. 6 karakter)',
                prefixIcon: const Icon(Icons.lock_outline, color: grayColor),
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                labelStyle: const TextStyle(color: grayColor),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryColor, width: 2.0),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Bidang Konfirmasi Password
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Konfirmasi Password',
                prefixIcon: const Icon(Icons.lock_reset, color: grayColor),
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                labelStyle: const TextStyle(color: grayColor),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryColor, width: 2.0),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Tampilkan Pesan Error
            if (_errorMessage != null) 
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),

            // Tombol Daftar (Sign Up) - Menggunakan Biru Gelap 0xFF2C3E50
            ElevatedButton(
              onPressed: _isLoading ? null : _handleSignUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor, // Warna Biru Gelap
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 5,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "DAFTAR",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
            ),
            const SizedBox(height: 20),
            
            // Opsi Kembali ke Login
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Kembali ke halaman Login
              },
              child: const Text(
                "Sudah punya akun? Masuk di sini",
                style: TextStyle(color: primaryColor), // Teks Biru Gelap
              ),
            ),
          ],
        ),
      ),
    );
  }
}
