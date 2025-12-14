// settings_page.dart (FINAL - PENGATURAN APLIKASI: TANPA MODE GELAP)

import 'package:flutter/material.dart';

// Definisikan warna yang sama agar konsisten
const Color primaryColor = Color(0xFF2C3E50); 
const Color darkTextColor = Color(0xFF1E2A3B);
const Color lightTextColor = Color(0xFF8D99AE);
const Color accentColor = Color(0xFFFFA000); 

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // --- STATE SETTING ---
  String _selectedLanguage = 'Bahasa Indonesia'; // Status Bahasa
  bool _allowNotifications = true; // Status Notifikasi Umum
  // ---------------------

  // Widget Pembantu untuk Item Menu yang dapat diklik (Navigasi)
  Widget _buildClickableItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: primaryColor),
      title: Text(title, style: const TextStyle(color: darkTextColor, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: lightTextColor),
      onTap: onTap,
    );
  }

  // Widget Pembantu untuk Item Menu dengan Switch (Toggle)
  Widget _buildSwitchItem(IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      leading: Icon(icon, color: primaryColor),
      title: Text(title, style: const TextStyle(color: darkTextColor, fontWeight: FontWeight.w500)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: accentColor,
      ),
      onTap: () => onChanged(!value), // Memungkinkan toggle lewat tap pada list
    );
  }

  // Widget Pembantu untuk Pilihan Bahasa (Dropdown/Dialog)
  Widget _buildLanguageItem() {
    return ListTile(
      leading: const Icon(Icons.language, color: primaryColor),
      title: const Text('Bahasa Aplikasi', style: TextStyle(color: darkTextColor, fontWeight: FontWeight.w500)),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLanguage,
          icon: const Icon(Icons.arrow_drop_down, color: lightTextColor),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedLanguage = newValue;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bahasa diubah ke: $newValue')));
            }
          },
          // Pilihan hanya INDONESIA dan ENGLISH
          items: <String>['Bahasa Indonesia', 'English']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(color: darkTextColor)),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Aplikasi', style: TextStyle(fontWeight: FontWeight.bold, color: darkTextColor)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- KELOMPOK 1: TAMPILAN & BAHASA ---
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 10, bottom: 8),
              child: Text('Bahasa', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: lightTextColor)),
            ),
            
            // 1. PENGATURAN BAHASA
            _buildLanguageItem(),
            
            const Divider(height: 30, thickness: 1),

            // --- KELOMPOK 2: NOTIFIKASI ---
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 10, bottom: 8),
              child: Text('Notifikasi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: lightTextColor)),
            ),

            // 2. NOTIFIKASI UMUM
            _buildSwitchItem(
              Icons.notifications_active_outlined,
              'Izinkan Notifikasi',
              _allowNotifications,
              (bool newValue) {
                setState(() {
                  _allowNotifications = newValue;
                });
              },
            ),

            const Divider(height: 30, thickness: 1),

            // --- KELOMPOK 3: CACHE & DATA ---
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 10, bottom: 8),
              child: Text('Data', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: lightTextColor)),
            ),

            // 3. HAPUS CACHE
            _buildClickableItem(
              Icons.cleaning_services_outlined,
              'Bersihkan Cache',
              () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cache berhasil dibersihkan!')));
              },
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}