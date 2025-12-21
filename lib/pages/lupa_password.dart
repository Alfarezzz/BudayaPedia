// pages/lupa_password.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Konstanta Warna (Pastikan konsisten dengan login.dart dan signup.dart)
const Color primaryColor = Color(0xFF2C3E50); // Biru gelap
const Color textColor = Color(0xFF1E2A3B); // Teks gelap
const Color grayColor = Color(0xFF5A6B80); // Teks abu-abu

class LupaPasswordPage extends StatefulWidget {
  const LupaPasswordPage({super.key});

  @override
  State<LupaPasswordPage> createState() => _LupaPasswordPageState();
}

class _LupaPasswordPageState extends State<LupaPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengirim email reset password
  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showSnackBar("Mohon masukkan alamat email Anda.", Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Panggil fungsi Firebase untuk mengirim reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Tampilkan pesan sukses dan navigasi kembali ke halaman Login
      _showSnackBar(
        "Link reset password telah dikirim ke $email. Mohon cek email Anda.",
        Colors.green,
      );

      // Kembali ke halaman Login
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'Tidak ada pengguna yang terdaftar dengan email ini.';
      } else if (e.code == 'invalid-email') {
        message = 'Format email tidak valid.';
      } else {
        message = 'Gagal mengirim link reset password. Coba lagi.';
      }
      _showSnackBar(message, Colors.red);
    } catch (e) {
      _showSnackBar('Terjadi kesalahan umum.', Colors.red);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lupa Password",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              "Masukkan Email",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Kami akan mengirimkan link untuk mereset password Anda.",
              style: TextStyle(fontSize: 16, color: grayColor),
            ),
            const SizedBox(height: 40),

            // Bidang Email
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined, color: grayColor),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryColor, width: 2.0),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Tombol Reset Password
            ElevatedButton(
              onPressed: _isLoading ? null : _resetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "KIRIM LINK RESET",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}