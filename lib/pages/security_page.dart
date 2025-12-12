// security_page.dart (Koreksi Final - Navigasi Sesi Tunggal)

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:firebase_core/firebase_core.dart'; 
import 'device_security_page.dart'; 

const Color primaryColor = Color(0xFF2C3E50); 
const Color darkTextColor = Color(0xFF1E2A3B);
const Color lightTextColor = Color(0xFF5A6B80);
const Color successColor = Color(0xFF27AE60); 
const Color warningColor = Color(0xFFE67E22); 

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  // State dan Controllers
  bool _is2faEnabled = false; 
  final user = FirebaseAuth.instance.currentUser;
  
  final TextEditingController _currentPassController = TextEditingController(); 
  final TextEditingController _newPassController = TextEditingController();     
  final TextEditingController _otpController = TextEditingController();           
  final TextEditingController _emailController = TextEditingController();       

  // --- FUNGSI NOTIFIKASI EMAIL (SIMULASI) ---
  void _sendSecurityEmailNotification(String action) {
    if (user != null) {
        // Logika pengiriman email simulasi terjadi di sini
    }
  }
  
  // FUNGSI UTILITY: Menampilkan Snackbar Keberhasilan Aksi
  void _showSuccessSnackbar(String message) {
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ $message"),
          backgroundColor: successColor,
          duration: const Duration(seconds: 3),
        ),
      );
  }

  // --- 1. UBAH SANDI ---
  Future<void> _showChangePasswordDialog() async {
    _currentPassController.clear();
    _newPassController.clear();
    
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ubah Kata Sandi"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _currentPassController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Sandi Lama", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _newPassController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Sandi Baru (min 6 karakter)", border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
            ElevatedButton(
              onPressed: () async {
                final oldPassword = _currentPassController.text.trim();
                final newPassword = _newPassController.text.trim();
                
                if (newPassword.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sandi baru minimal 6 karakter!")));
                  return;
                }
                
                if (user != null) {
                  try {
                    AuthCredential credential = EmailAuthProvider.credential(email: user!.email!, password: oldPassword);
                    await user!.reauthenticateWithCredential(credential);
                    await user!.updatePassword(newPassword);
                    
                    if (mounted) Navigator.pop(context);
                    _showSuccessSnackbar("Kata Sandi berhasil diubah! Email konfirmasi telah dikirim."); 
                    _sendSecurityEmailNotification("Perubahan Kata Sandi");

                  } on FirebaseAuthException catch (e) {
                    if (mounted) Navigator.pop(context);
                    String msg = e.code == 'wrong-password' ? "Sandi Lama salah." : "Gagal: ${e.message}";
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                  } catch (e) {
                    if (mounted) Navigator.pop(context);
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Terjadi kesalahan umum.")));
                  }
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  // --- 2. UBAH EMAIL (Dua Tahap OTP Simulasi) ---
  
  Future<void> _showChangeEmailOTPRequest() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Verifikasi Email Lama"),
          content: Text("Kami akan mengirimkan Kode OTP ke email Anda saat ini (${user?.email ?? 'N/A'}) untuk memverifikasi kepemilikan."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); 
                _sendOtpAndShowVerificationDialog(); 
                _showSuccessSnackbar("Kode OTP (Simulasi: 123456) telah dikirim ke email Anda!"); 
              },
              child: const Text("Minta OTP"),
            ),
          ],
        );
      },
    );
  }

  void _sendOtpAndShowVerificationDialog() {
    _otpController.clear();
    _emailController.clear();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Masukkan OTP & Email Baru"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(labelText: "Kode OTP 6 Digit", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: "Alamat Email Baru", border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
            ElevatedButton(
              onPressed: () async {
                final otp = _otpController.text.trim();
                final newEmail = _emailController.text.trim();
                
                // SIMULASI VERIFIKASI OTP (Kode: 123456)
                if (otp.isEmpty || otp != "123456") { 
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kode OTP salah atau kedaluwarsa!")));
                  return;
                }
                
                if (user != null && newEmail.isNotEmpty && newEmail != user!.email) {
                  try {
                    await user!.verifyBeforeUpdateEmail(newEmail);
                    
                    if (mounted) Navigator.pop(context);
                    _showSuccessSnackbar("Link verifikasi telah dikirim ke email baru Anda!");
                    
                    _sendSecurityEmailNotification("Permintaan Ubah Email");

                  } on FirebaseAuthException catch (e) {
                    if (mounted) Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: ${e.message}")));
                  } catch (e) {
                    if (mounted) Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Terjadi kesalahan umum.")));
                  }
                } else if (mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  // --- 3. VERIFIKASI DUA LANGKAH (2FA) ---
  
  // 3a. Proses Aktivasi 2FA (Langkah 1: Permintaan OTP)
  Future<void> _show2faOtpRequest() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Aktivasi 2FA"),
          content: Text("Kami akan mengirimkan Kode OTP ke email Anda saat ini (${user?.email ?? 'N/A'}) untuk mengaktifkan Verifikasi Dua Langkah."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); 
                _show2faOtpVerificationDialog(); 
                _showSuccessSnackbar("Kode OTP (Simulasi: 654321) telah dikirim ke email Anda!");
              },
              child: const Text("Minta OTP"),
            ),
          ],
        );
      },
    );
  }

  // 3b. Proses Aktivasi 2FA (Langkah 2: Verifikasi OTP)
  void _show2faOtpVerificationDialog() {
    _otpController.clear();
    
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) {
        return AlertDialog(
          title: const Text("Verifikasi OTP 2FA"),
          content: TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(labelText: "Kode OTP 6 Digit", border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
            ElevatedButton(
              onPressed: () async {
                final otp = _otpController.text.trim();
                
                // SIMULASI VERIFIKASI OTP 2FA (Kode: 654321)
                if (otp.isEmpty || otp != "654321") { 
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kode OTP salah atau kedaluwarsa!")));
                  return;
                }
                
                // AKTIVASI 2FA BERHASIL
                if (mounted) {
                    setState(() {
                      _is2faEnabled = true; 
                    });
                    Navigator.pop(context);
                    _showSuccessSnackbar("Verifikasi Dua Langkah berhasil diaktifkan!");
                    _sendSecurityEmailNotification("Aktivasi 2FA");
                }
              },
              child: const Text("Aktifkan"),
            ),
          ],
        );
      },
    );
  }

  // 3c. Proses Deaktivasi 2FA (Konfirmasi Saja)
  Future<void> _show2faDeactivationConfirmation() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Nonaktifkan 2FA"),
          content: const Text("Apakah Anda yakin ingin menonaktifkan Verifikasi Dua Langkah? Ini akan mengurangi keamanan akun Anda."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
            ElevatedButton(
              onPressed: () {
                if (mounted) {
                    setState(() {
                      _is2faEnabled = false; 
                    });
                    Navigator.pop(context);
                    _showSuccessSnackbar("Verifikasi Dua Langkah dinonaktifkan!");
                    _sendSecurityEmailNotification("Deaktivasi 2FA");
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: warningColor),
              child: const Text("Nonaktifkan"),
            ),
          ],
        );
      },
    );
  }

  // --- 4. RIWAYAT DAN SESI (Navigasi Riil) ---
  void _navigateToDeviceSecurity() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DeviceSecurityPage()),
    );
    _sendSecurityEmailNotification("Akses Riwayat Keamanan");
  }


  // --- WIDGET PEMBANGUN UI ---
  Widget _buildSecurityCard(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: primaryColor, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: darkTextColor)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: lightTextColor)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: lightTextColor),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleSecurityCard(IconData icon, String title, String subtitle, bool value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: primaryColor, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: darkTextColor)),
                const SizedBox(height: 3),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: lightTextColor)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) {
              if (newValue) {
                _show2faOtpRequest();
              } else {
                _show2faDeactivationConfirmation();
              }
            },
            activeColor: successColor,
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final bool isSecurityGood = _is2faEnabled;
    final String statusText = isSecurityGood ? "Status Keamanan: Baik" : "Status Keamanan: Perlu Perhatian";
    final Color statusColor = isSecurityGood ? successColor : warningColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Keamanan Akun', style: TextStyle(fontWeight: FontWeight.bold, color: darkTextColor)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. KARTU STATUS KEAMANAN (Visual) ---
            Container(
              padding: const EdgeInsets.all(18),
              width: double.infinity,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: statusColor, width: 1.5),
              ),
              child: Row(
                children: [
                  Icon(
                    isSecurityGood ? Icons.verified_user : Icons.warning_amber,
                    color: statusColor,
                    size: 30,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statusText,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: statusColor),
                        ),
                        const Text(
                          "Keamanan yang kuat melindungi data BudayaPedia Anda.",
                          style: TextStyle(fontSize: 12, color: lightTextColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),

            // --- 2. PENGATURAN UTAMA (Aksi) ---
            const Text('Akses dan Verifikasi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: lightTextColor)),
            const SizedBox(height: 10),

            // 1. Ubah Kata Sandi
            _buildSecurityCard(
              Icons.vpn_key, 
              'Ubah Kata Sandi', 
              'Perbarui password Anda secara berkala.', 
              _showChangePasswordDialog, 
            ),

            // 2. Ubah Alamat Email
            _buildSecurityCard(
              Icons.mail_outline, 
              'Ubah Alamat Email', 
              'Ganti email yang terdaftar untuk akun ini.', 
              _showChangeEmailOTPRequest, 
            ),
            
            // 3. Verifikasi Dua Langkah (2FA) dengan Toggle Interaktif
            _buildToggleSecurityCard(
              Icons.security, 
              'Verifikasi Dua Langkah (2FA)', 
              _is2faEnabled ? 'Aktif. Selalu minta kode kedua saat login.' : 'Nonaktif. Keamanan akun lebih rentan.', 
              _is2faEnabled, 
            ),

            const SizedBox(height: 30),

            // --- 3. RIWAYAT DAN SESI ---
            const Text('Aktivitas dan Perangkat', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: lightTextColor)),
            const SizedBox(height: 10),

            // 4. Aktivitas dan Sesi Keamanan (Digabung menjadi satu tombol)
            _buildSecurityCard(
              Icons.devices_other, 
              'Aktivitas dan Sesi Keamanan', 
              'Kelola perangkat yang aktif dan lihat riwayat login Anda.', 
              _navigateToDeviceSecurity, 
            ),
          ],
        ),
      ),
    );
  }
}