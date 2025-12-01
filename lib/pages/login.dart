import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:budayapedia/pages/welcome.dart';

// Konstanta Warna
const Color primaryColor = Color(0xFF2C3E50); // Biru gelap untuk tombol utama
const Color textColor = Color(0xFF1E2A3B); // Teks gelap
const Color grayColor = Color(0xFF5A6B80); // Teks abu-abu

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Gunakan const untuk menghindari error constructor
  final GoogleSignIn _googleSignIn = GoogleSignIn(git remote remove origin);

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State Variables
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;
  static const String _rememberMeKey = 'rememberMeFlag';

  // Helper untuk menampilkan pesan error
  void _showSnackBar(String message) {
    // Pastikan context valid saat menggunakan ScaffoldMessenger
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  // --- PERSISTENSI DATA ---
  Future<void> _saveRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, value);
    debugPrint('Status Remember Me disimpan: $value');
  }

  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final remembered = prefs.getBool(_rememberMeKey) ?? false;

    setState(() {
      _rememberMe = remembered;
      debugPrint('Status Remember Me dimuat: $_rememberMe');
    });
  }

  // --- FUNGSI UI / STATE ---
  void _toggleVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  // --- FUNGSI OTENTIKASI (Email/Password) ---
  // Hapus fungsi simulasi lama, ini adalah fungsi otentikasi yang benar
  Future<void> _handleSignIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('Email dan Password tidak boleh kosong.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Navigasi ke WelcomePage (asumsi StreamBuilder di main.dart akan menangani ini)
      // Gunakan pushReplacement agar pengguna tidak bisa kembali ke halaman login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );

    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'Tidak ada pengguna yang ditemukan dengan email ini.';
      } else if (e.code == 'wrong-password') {
        message = 'Password salah.';
      } else {
        message = 'Login Gagal: ${e.message}';
      }
      _showSnackBar(message);

    } catch (e) {
      _showSnackBar('Terjadi kesalahan tak terduga.');
      debugPrint('Error Login: $e');
    }

    // Nonaktifkan Loading hanya jika navigasi gagal (jika berhasil, halaman sudah diganti)
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // --- FUNGSI OTENTIKASI (Google) ---
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );

    } on FirebaseAuthException catch (e) {
      _showSnackBar('Google Sign-In Gagal: ${e.message}');
    } catch (e) {
      _showSnackBar('Terjadi kesalahan saat otentikasi Google.');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ... (sisa kode build Anda)
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // --- 1. Logo dan Judul ---
              Image.asset(
                'assets/budayapedia.png',
                height: 80,
              ),
              const SizedBox(height: 10),
              const Text(
                'BudayaPedia',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: 'DMSans',
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Membantu edukasi individu untuk generasi pemimpin masa depan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: grayColor,
                    fontFamily: 'DMSans',
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // --- 2. Input Email/Username ---
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Email or Username', style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontFamily: 'DMSans')),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController, // Controller terpasang
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'youremail@example.com',
                  hintStyle: TextStyle(color: grayColor, fontFamily: 'DMSans'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 15.0),
                ),
              ),
              const SizedBox(height: 20),

              // --- 3. Input Password ---
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Password', style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontFamily: 'DMSans')),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController, // Controller terpasang
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: '12345',
                  hintStyle: const TextStyle(color: grayColor, fontFamily: 'DMSans'),
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 15.0),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: grayColor),
                    onPressed: _toggleVisibility,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // --- 4. Remember Me & Forgot Password ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _rememberMe = newValue ?? false;
                            _saveRememberMe(_rememberMe);
                          });
                        },
                        activeColor: primaryColor,
                      ),
                      const Text('Remember me', style: TextStyle(color: grayColor, fontFamily: 'DMSans')),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Forgot password?', style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontFamily: 'DMSans')),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // --- 5. Tombol Sign In ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignIn, // Menggunakan _handleSignIn yang asli

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),

                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3,
                    ),
                  )
                      : const Text(
                      'Sign In',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'DMSans')
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: <Widget>[
                    // Garis kiri
                    const Expanded(
                      child: Divider(
                        color: grayColor,
                        thickness: 1.0,
                      ),
                    ),
                    // Teks 'or' di tengah
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                          'or',
                          style: TextStyle(
                              color: grayColor,
                              fontFamily: 'DMSans'
                          )
                      ),
                    ),
                    // Garis kanan
                    const Expanded(
                      child: Divider(
                        color: grayColor,
                        thickness: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- 7. Tombol Sign In with Google ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: _signInWithGoogle, // Menggunakan _signInWithGoogle

                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(color: grayColor, width: 1.0),
                    padding: EdgeInsets.zero,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/google.png',
                        height: 20,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Sign in with Google',
                        style: TextStyle(
                            fontSize: 18,
                            color: textColor,
                            fontFamily: 'DMSans'
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // --- 8. Teks Sign Up ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: textColor, fontFamily: 'DMSans')),
                  TextButton(
                    onPressed: () {
                      print('Sign up ditekan!');
                    },
                    child: const Text('Sign up', style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontFamily: 'DMSans')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}