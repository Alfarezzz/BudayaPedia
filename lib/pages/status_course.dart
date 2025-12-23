import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import Auth
import 'form_course.dart';
import 'draft_course.dart';
// import 'status_course.dart'; // Jika kamu butuh enum, tapi di sini kita pakai String dari DB

const Color darkTextColor = Color(0xFF333333);
const Color lightTextColor = Color(0xFF999999);
const Color primaryColor = Color(0xFF2196F3);

class CourseStatusPage extends StatefulWidget {
  const CourseStatusPage({Key? key}) : super(key: key);

  @override
  State<CourseStatusPage> createState() => _CourseStatusPageState();
}

class _CourseStatusPageState extends State<CourseStatusPage> {
  // Ambil User ID yang sedang login agar list course sesuai dengan akunnya
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return '-';
    DateTime date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Course Saya'),
        backgroundColor: Colors.white,
        foregroundColor: darkTextColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.drafts_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DraftCoursePage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddCourseFormPage()),
              );
            },
          ),
        ],
      ),
      // MENGGUNAKAN STREAM BUILDER UNTUK DATA REAL-TIME
      body: userId == null 
          ? const Center(child: Text("Silakan login terlebih dahulu"))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('courses')
                  .where('authorId', isEqualTo: userId) // Filter hanya course milik user ini
                  // .orderBy('createdAt', descending: true) // Opsional: Urutkan dari yg terbaru (Pastikan bikin index di firebase jika error)
                  .snapshots(),
              builder: (context, snapshot) {
                // 1. Handling Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 2. Handling Error
                if (snapshot.hasError) {
                  return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
                }

                // 3. Handling Data Kosong
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_open, size: 60, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        const Text("Belum ada course yang diupload", style: TextStyle(color: lightTextColor)),
                      ],
                    ),
                  );
                }

                // 4. Menampilkan Data
                final docs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    // Ambil data per dokumen
                    final data = docs[index].data() as Map<String, dynamic>;
                    
                    // Ambil field status (String) dari Firebase
                    String statusString = data['status'] ?? 'pending';
                    
                    // Logic Warna & Icon berdasarkan Status Firebase
                    Color statusColor;
                    IconData statusIcon;
                    String statusLabel;

                    if (statusString == 'approved') {
                      statusColor = Colors.green;
                      statusIcon = Icons.check_circle_outline;
                      statusLabel = 'Diterima';
                    } else if (statusString == 'rejected') {
                      statusColor = Colors.red;
                      statusIcon = Icons.cancel_outlined;
                      statusLabel = 'Ditolak';
                    } else {
                      // Default Pending
                      statusColor = Colors.orange;
                      statusIcon = Icons.pending_outlined;
                      statusLabel = 'Pending Review';
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[200]!),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['title'] ?? 'Tanpa Judul',
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkTextColor),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        data['category'] ?? 'Umum', 
                                        style: const TextStyle(fontSize: 13, color: lightTextColor)
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: statusColor.withOpacity(0.3)),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(statusIcon, size: 16, color: statusColor),
                                      const SizedBox(width: 4),
                                      Text(statusLabel, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: statusColor)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined, size: 14, color: lightTextColor),
                                const SizedBox(width: 6),
                                // Menampilkan tanggal upload (createdAt)
                                Text(
                                  'Diupload: ${_formatDate(data['createdAt'])}', 
                                  style: const TextStyle(fontSize: 12, color: lightTextColor)
                                ),
                              ],
                            ),
                            // Pesan khusus jika status pending
                            if (statusString == 'pending') ...[
                              const SizedBox(height: 8),
                              const Text(
                                'Menunggu review admin (1-3 hari)', 
                                style: TextStyle(fontSize: 12, color: lightTextColor, fontStyle: FontStyle.italic)
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}