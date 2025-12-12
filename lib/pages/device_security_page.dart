// device_security_page.dart (PERSISTENSI SEDERHANA DENGAN STATIC)

import 'package:flutter/material.dart';

// Definisikan warna yang digunakan (Konsisten)
const Color primaryColor = Color(0xFF2C3E50); 
const Color darkTextColor = Color(0xFF1E2A3B);
const Color lightTextColor = Color(0xFF5A6B80);
const Color warningColor = Color(0xFFE67E22);
const Color successColor = Color(0xFF27AE60);

class DeviceSecurityPage extends StatefulWidget {
  const DeviceSecurityPage({super.key});

  @override
  State<DeviceSecurityPage> createState() => _DeviceSecurityPageState();
}

class _DeviceSecurityPageState extends State<DeviceSecurityPage> {
  
  // --- DATA STATIC (Penyimpanan Sementara) ---
  // Data ini HANYA dibuat sekali selama aplikasi berjalan.
  // Inilah yang membuat perubahan persist saat navigasi.
  static List<Map<String, dynamic>> activeSessions = [
    {'device': 'Samsung Galaxy S23 (Perangkat Ini)', 'location': 'Bekasi, Indonesia', 'time': 'Saat Ini', 'isCurrent': true},
    {'device': 'Chrome Browser (Windows 11)', 'location': 'Jakarta, Indonesia', 'time': '1 jam lalu', 'isCurrent': false},
    {'device': 'iPhone 14 Pro', 'location': 'Bandung, Indonesia', 'time': '3 hari lalu', 'isCurrent': false},
  ];

  static List<Map<String, dynamic>> activityLog = [
    {'activity': 'Ubah Kata Sandi Berhasil', 'time': '20 Des, 14:30', 'isAlert': false},
    {'activity': 'Login di Perangkat Baru (iPhone 14 Pro)', 'time': '19 Des, 10:00', 'isAlert': true},
    {'activity': 'Akses Riwayat Keamanan', 'time': '18 Des, 08:00', 'isAlert': false},
    {'activity': 'Login Berhasil (Samsung S23)', 'time': '17 Des, 19:00', 'isAlert': false},
  ];
  // -------------------------------------------------------------------

  // Fungsi untuk Logout Perangkat Jarak Jauh (Memperbarui State secara instan)
  void _logoutDevice(int index) {
    if (activeSessions[index]['isCurrent']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak bisa mengeluarkan perangkat yang sedang Anda gunakan.")),
      );
      return;
    }
    
    // Konfirmasi sebelum logout
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Keluarkan Perangkat"),
        content: Text("Yakin ingin mengeluarkan sesi dari ${activeSessions[index]['device']}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              // Logika logout: Menghapus dari daftar sesi aktif
              final loggedOutDevice = activeSessions[index]['device'];
              
              // >>> Perubahan menggunakan setState untuk memperbarui UI <<<
              setState(() {
                activeSessions.removeAt(index);
                
                // Menambahkan entri baru ke Riwayat Aktivitas
                activityLog.insert(0, {
                  'activity': 'Logout Paksa Sesi ($loggedOutDevice)', 
                  'time': 'Baru Saja', 
                  'isAlert': true
                });
              });
              
              Navigator.pop(context); // Tutup dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$loggedOutDevice berhasil dikeluarkan!")),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: warningColor),
            child: const Text("Keluarkan"),
          ),
        ],
      ),
    );
  }

  // Widget untuk item Sesi Aktif
  Widget _buildSessionItem(Map<String, dynamic> session, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: session['isCurrent'] ? primaryColor.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: lightTextColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                session['isCurrent'] ? Icons.smartphone : Icons.desktop_windows,
                color: session['isCurrent'] ? primaryColor : darkTextColor,
                size: 24,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  session['device'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: session['isCurrent'] ? primaryColor : darkTextColor,
                  ),
                ),
              ),
              if (session['isCurrent'])
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Aktif', style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
            ],
          ),
          const SizedBox(height: 5),
          Text(session['location'] as String, style: const TextStyle(fontSize: 12, color: lightTextColor)),
          Text('Akses terakhir: ${session['time']}', style: const TextStyle(fontSize: 12, color: lightTextColor)),
          
          if (!session['isCurrent'])
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => _logoutDevice(index),
                child: const Text('Keluarkan Perangkat', style: TextStyle(color: warningColor, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  // Widget untuk item Riwayat Aktivitas
  Widget _buildActivityLogItem(Map<String, dynamic> log) {
    final color = log['isAlert'] ? warningColor : successColor;

    return ListTile(
      leading: Icon(log['isAlert'] ? Icons.notification_important : Icons.check_circle, color: color),
      title: Text(log['activity'] as String, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(log['time'] as String, style: const TextStyle(color: lightTextColor)),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Aktivitas & Sesi Keamanan', style: TextStyle(fontWeight: FontWeight.bold, color: darkTextColor)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- KARTU INFORMASI ---
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Anda dapat melihat semua perangkat yang aktif login dan riwayat perubahan akun Anda di sini. Keluarkan perangkat yang tidak Anda kenali!',
                style: TextStyle(fontSize: 13, color: darkTextColor),
              ),
            ),
            
            const SizedBox(height: 25),

            // --- 1. SESI AKTIF (KELOLA PERANGKAT) ---
            const Text('Sesi Login Aktif', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkTextColor)),
            const SizedBox(height: 10),

            // Daftar Sesi Aktif (menggunakan data static yang persist)
            ...activeSessions.asMap().entries.map((entry) {
              return _buildSessionItem(entry.value, entry.key);
            }).toList(),
            
            const SizedBox(height: 40),

            // --- 2. RIWAYAT AKTIVITAS KEAMANAN ---
            const Text('Riwayat Aktivitas Keamanan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkTextColor)),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
                ]
              ),
              // Daftar Riwayat Aktivitas (menggunakan data static yang persist)
              child: Column(
                children: activityLog.map(_buildActivityLogItem).toList(),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}