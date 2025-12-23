// ============================================
// FILE: lib/pages/admin_dashboard.dart
// ============================================

import 'package:flutter/material.dart';
import 'course_model.dart';
import 'package:budayapedia/pages/form_course.dart';
import 'package:budayapedia/pages/admin_edit_course.dart';
import 'package:budayapedia/pages/course_detail_page.dart';

const Color primaryColor = Color(0xFF2C3E50);
const Color darkTextColor = Color(0xFF1E2A3B);
const Color lightTextColor = Color(0xFF5A6B80);

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedIndex = 0;

  // Statistik
  int get pendingCount => CourseDatabase.uploadedCourses
      .where((c) => c.status == CourseStatus.pending)
      .length;
  
  int get approvedCount => CourseDatabase.publishedCourses
      .where((c) => c.status == CourseStatus.approved)
      .length;
  
  int get rejectedCount => CourseDatabase.uploadedCourses
      .where((c) => c.status == CourseStatus.rejected)
      .length;

  // Lifetime Access - Semua courses yang tersedia
  List<Course> get allAvailableCourses => CourseDatabase.publishedCourses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Buat Course Baru',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddCourseFormPage(),
                ),
              ).then((_) => setState(() {}));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Statistics
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Pending',
                        pendingCount.toString(),
                        Icons.pending_outlined,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Published',
                        approvedCount.toString(),
                        Icons.check_circle_outline,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Rejected',
                        rejectedCount.toString(),
                        Icons.cancel_outlined,
                        Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Tab Navigation
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildTabButton('Review', 0, Icons.rate_review_outlined),
                ),
                Expanded(
                  child: _buildTabButton('Published', 1, Icons.library_books_outlined),
                ),
                Expanded(
                  child: _buildTabButton('All Courses', 2, Icons.school_outlined),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _selectedIndex == 0 
                ? _buildReviewTab()
                : _selectedIndex == 1
                    ? _buildPublishedCoursesTab()
                    : _buildAllCoursesTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: lightTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index, IconData icon) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : lightTextColor,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : lightTextColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: Review Pending Courses
  Widget _buildReviewTab() {
    final pendingCourses = CourseDatabase.uploadedCourses
        .where((c) => c.status == CourseStatus.pending)  // ← Filter PENDING doang
        .toList();

    if (pendingCourses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Tidak ada course yang perlu direview',
              style: TextStyle(fontSize: 16, color: lightTextColor),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: pendingCourses.length,
      itemBuilder: (context, index) {
        final course = pendingCourses[index];
        return _buildPendingCourseCard(course);
      },
    );
  }

  Widget _buildPendingCourseCard(CourseData course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          if (course.thumbnail != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.file(
                course.thumbnail,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title & Category
                Text(
                  course.title ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        course.category ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Author & Duration
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 16, color: lightTextColor),
                    const SizedBox(width: 4),
                    Text(course.author ?? '', style: TextStyle(fontSize: 13, color: lightTextColor)),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time, size: 16, color: lightTextColor),
                    const SizedBox(width: 4),
                    Text(course.duration ?? '-', style: TextStyle(fontSize: 13, color: lightTextColor)),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Description
                Text(
                  course.description ?? '',
                  style: TextStyle(fontSize: 14, color: lightTextColor, height: 1.5),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                
                // Sections Info
                Text(
                  '${course.sections.length} Sections • ${course.sections.fold(0, (sum, s) => sum + s.lessons.length)} Lessons',
                  style: TextStyle(fontSize: 13, color: lightTextColor, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.visibility_outlined, size: 18),
                        label: const Text('Detail'),
                        onPressed: () => _showCourseDetailFromData(course),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.cancel_outlined, size: 18),
                        label: const Text('Tolak'),
                        onPressed: () => _showRejectDialog(course),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle_outline, size: 18),
                        label: const Text('Publish'),
                        onPressed: () => _approveCourse(course),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: Published Courses
  Widget _buildPublishedCoursesTab() {
    final publishedCourses = CourseDatabase.publishedCourses;

    if (publishedCourses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.library_books_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Belum ada course yang dipublish',
              style: TextStyle(fontSize: 16, color: lightTextColor),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: publishedCourses.length,
      itemBuilder: (context, index) {
        final course = publishedCourses[index];
        return _buildPublishedCourseCard(course);
      },
    );
  }

  Widget _buildPublishedCourseCard(Course course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            course.imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 60,
              height: 60,
              color: Colors.grey[200],
              child: const Icon(Icons.image_outlined),
            ),
          ),
        ),
        title: Text(
          course.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              course.category,
              style: TextStyle(fontSize: 12, color: lightTextColor),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.check_circle, size: 14, color: Colors.green),
                const SizedBox(width: 4),
                const Text(
                  'Published',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  course.videoCount,
                  style: TextStyle(fontSize: 11, color: lightTextColor),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'view') {
              _viewCourseAsStudent(course);
            } else if (value == 'edit') {
              _editPublishedCourse(course);
            } else if (value == 'delete') {
              _deletePublishedCourse(course);
            } else if (value == 'detail') {
              _showCourseDetail(course);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.play_circle_outline, size: 18, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Lihat Kursus'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'detail',
              child: Row(
                children: [
                  Icon(Icons.visibility_outlined, size: 18),
                  SizedBox(width: 8),
                  Text('Detail Info'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: 18),
                  SizedBox(width: 8),
                  Text('Edit Course'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Hapus Course', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 3: All Courses (Lifetime Access)
  Widget _buildAllCoursesTab() {
    final allCourses = allAvailableCourses;

    if (allCourses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Belum ada course yang tersedia',
              style: TextStyle(fontSize: 16, color: lightTextColor),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: allCourses.length,
      itemBuilder: (context, index) {
        final course = allCourses[index];
        return _buildAllCourseCard(course);
      },
    );
  }

  Widget _buildAllCourseCard(Course course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _viewCourseAsStudent(course),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  course.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.image_outlined),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Course Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: darkTextColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.video_library, size: 14, color: lightTextColor),
                        const SizedBox(width: 4),
                        Text(
                          course.videoCount,
                          style: TextStyle(fontSize: 12, color: lightTextColor),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.access_time, size: 14, color: lightTextColor),
                        const SizedBox(width: 4),
                        Text(
                          course.duration,
                          style: TextStyle(fontSize: 12, color: lightTextColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Admin Actions Menu
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'view') {
                    _viewCourseAsStudent(course);
                  } else if (value == 'edit') {
                    _editPublishedCourse(course);
                  } else if (value == 'detail') {
                    _showCourseDetail(course);
                  } else if (value == 'delete') {
                    _deletePublishedCourse(course);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.play_circle_outline, size: 18, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Lihat Kursus'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'detail',
                    child: Row(
                      children: [
                        Icon(Icons.visibility_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Detail Info'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Edit Course'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Hapus Course', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ACTIONS
  void _approveCourse(CourseData course) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text('Publish Course'),
          ],
        ),
        content: Text('Course "${course.title}" akan dipublish dan tampil di My Courses?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                CourseDatabase.approveCourse(course);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Course berhasil dipublish & notifikasi terkirim ke user!'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Publish'),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(CourseData course) {
    final TextEditingController reasonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [
            Icon(Icons.cancel, color: Colors.red),
            SizedBox(width: 10),
            Text('Tolak Course'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tolak course "${course.title}"?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Alasan Penolakan *',
                hintText: 'Jelaskan alasan kenapa course ini ditolak...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.isNotEmpty) {
                setState(() {
                  CourseDatabase.rejectCourse(course, reasonController.text);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Course ditolak & notifikasi terkirim ke user!'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Tolak'),
          ),
        ],
      ),
    );
  }

  void _viewCourseAsStudent(Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailPage(course: course),
      ),
    ).then((_) => setState(() {}));
  }

  void _editPublishedCourse(Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminEditCoursePage(course: course),
      ),
    ).then((_) => setState(() {}));
  }

  void _deletePublishedCourse(Course course) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 10),
            Text('Hapus Course'),
          ],
        ),
        content: Text('Yakin ingin menghapus course "${course.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                CourseDatabase.deletePublishedCourse(course.id ?? '');
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Course berhasil dihapus'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showCourseDetail(Course course) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    course.imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_outlined, size: 50),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Title & Category
                Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: darkTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        course.category,
                        style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.video_library, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      course.videoCount,
                      style: TextStyle(fontSize: 14, color: lightTextColor),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      course.duration,
                      style: TextStyle(fontSize: 14, color: lightTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Author & Level
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 20, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      course.author ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.signal_cellular_alt, size: 20, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      course.level ?? 'Beginner',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.language, size: 20, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      course.language ?? 'Indonesian',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Description
                const Text(
                  'Deskripsi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  course.description,
                  style: TextStyle(
                    fontSize: 15,
                    color: lightTextColor,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Learning Outcomes
                if (course.learningOutcomes != null && course.learningOutcomes!.isNotEmpty) ...[
                  const Text(
                    'Learning Outcomes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkTextColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...course.learningOutcomes!.map((outcome) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle, size: 20, color: Colors.green),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              outcome,
                              style: TextStyle(
                                fontSize: 15,
                                color: lightTextColor,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 24),
                ],
                
                // Prerequisites
                if (course.prerequisites != null && course.prerequisites!.isNotEmpty) ...[
                  const Text(
                    'Prasyarat',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkTextColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...course.prerequisites!.map((prerequisite) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline, size: 20, color: Colors.orange),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              prerequisite,
                              style: TextStyle(
                                fontSize: 15,
                                color: lightTextColor,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 24),
                ],
                
                // Course Content - Sections with Lessons, Quizzes, Assignments
                const Text(
                  'Konten Course',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkTextColor,
                  ),
                ),
                const SizedBox(height: 12),
                ...course.sections?.asMap().entries.map((entry) {
                  int sectionIndex = entry.key;
                  var section = entry.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Header
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.folder_open, size: 20, color: primaryColor),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Section ${sectionIndex + 1}: ${section.title}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: darkTextColor,
                                ),
                              ),
                            ),
                            Text(
                              '${section.lessons.length} lessons',
                              style: TextStyle(
                                fontSize: 12,
                                color: lightTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Lessons
                      ...section.lessons.map((lesson) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.play_circle_outline, size: 18, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  lesson.title,
                                  style: TextStyle(fontSize: 14, color: lightTextColor),
                                ),
                              ),
                              if (lesson.duration != null)
                                Text(
                                  lesson.duration!,
                                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                      
                      // Quizzes
                      if (section.quizzes != null && section.quizzes!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        ...section.quizzes!.map((quiz) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 16, bottom: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.quiz, size: 18, color: Colors.amber),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Quiz: ${quiz.title}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: lightTextColor,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                      
                      // Assignments/Modules
                      if (section.assignments != null && section.assignments!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        ...section.assignments!.map((assignment) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 16, bottom: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.assignment, size: 18, color: Colors.green),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Assignment: ${assignment.title}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: lightTextColor,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                      
                      const SizedBox(height: 16),
                    ],
                  );
                }).toList() ?? [],
                
                // Resources
                if (course.resources != null && course.resources!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Resources',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkTextColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...course.resources!.map((resource) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.attach_file, size: 18, color: primaryColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              resource.name,
                              style: TextStyle(fontSize: 14, color: lightTextColor),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCourseDetailFromData(CourseData course) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Thumbnail
                if (course.thumbnail != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      course.thumbnail,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 20),
                
                // Title
                Text(
                  course.title ?? 'Untitled',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: darkTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Category & Duration
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        course.category ?? '',
                        style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.access_time, size: 16, color: lightTextColor),
                    const SizedBox(width: 4),
                    Text(
                      course.duration ?? '-',
                      style: TextStyle(fontSize: 14, color: lightTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Author
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 20, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      course.author ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Description
                const Text(
                  'Deskripsi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  course.description ?? '',
                  style: TextStyle(
                    fontSize: 15,
                    color: lightTextColor,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Learning Outcomes
                if (course.learningOutcomes != null && course.learningOutcomes!.isNotEmpty) ...[
                  const Text(
                    'Learning Outcomes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkTextColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...course.learningOutcomes!.map((outcome) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle, size: 20, color: Colors.green),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              outcome,
                              style: TextStyle(
                                fontSize: 15,
                                color: lightTextColor,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 24),
                ],
                
                // Prerequisites
                if (course.prerequisites != null && course.prerequisites!.isNotEmpty) ...[
                  const Text(
                    'Prasyarat',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkTextColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...course.prerequisites!.map((prerequisite) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline, size: 20, color: Colors.orange),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              prerequisite,
                              style: TextStyle(
                                fontSize: 15,
                                color: lightTextColor,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 24),
                ],
                
                // Course Content - Sections with Lessons, Quizzes, Assignments
                const Text(
                  'Konten Course',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkTextColor,
                  ),
                ),
                const SizedBox(height: 12),
                ...course.sections?.asMap().entries.map((entry) {
                  int sectionIndex = entry.key;
                  var section = entry.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Header
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.folder_open, size: 20, color: primaryColor),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Section ${sectionIndex + 1}: ${section.title}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: darkTextColor,
                                ),
                              ),
                            ),
                            Text(
                              '${section.lessons.length} lessons',
                              style: TextStyle(
                                fontSize: 12,
                                color: lightTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Lessons
                      ...section.lessons.map((lesson) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.play_circle_outline, size: 18, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  lesson.title,
                                  style: TextStyle(fontSize: 14, color: lightTextColor),
                                ),
                              ),
                              if (lesson.duration != null)
                                Text(
                                  lesson.duration!,
                                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                      
                      // Quizzes
                      if (section.quizzes != null && section.quizzes!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        ...section.quizzes!.map((quiz) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 16, bottom: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.quiz, size: 18, color: Colors.amber),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Quiz: ${quiz.title}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: lightTextColor,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                      
                      // Assignments/Modules
                      if (section.assignments != null && section.assignments!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        ...section.assignments!.map((assignment) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 16, bottom: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.assignment, size: 18, color: Colors.green),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Assignment: ${assignment.title}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: lightTextColor,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                      
                      const SizedBox(height: 16),
                    ],
                  );
                }).toList() ?? [],
                
                // Resources
                if (course.resources != null && course.resources!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Resources',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkTextColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...course.resources!.map((resource) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.attach_file, size: 18, color: primaryColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              resource.name,
                              style: TextStyle(fontSize: 14, color: lightTextColor),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}