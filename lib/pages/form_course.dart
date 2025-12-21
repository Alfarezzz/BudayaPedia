// lib/pages/form_course.dart
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'course_model.dart';
import 'status_course.dart';

const Color primaryColor = Color(0xFF2196F3);
const Color darkTextColor = Color(0xFF5A6B80);
const Color lightTextColor = Color(0xFF1E2A3B);

class AddCourseFormPage extends StatefulWidget {
  final CourseData? draftData;
  
  const AddCourseFormPage({Key? key, this.draftData}) : super(key: key);

  @override
  State<AddCourseFormPage> createState() => _AddCourseFormPageState();
}

class _AddCourseFormPageState extends State<AddCourseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _descriptionController;
  late TextEditingController _authorController;
  late TextEditingController _durationController;
  
  String? _selectedCategory;
  dynamic _thumbnailFile;
  List<String> _learningOutcomes = [];
  List<CourseSection> _sections = [];
  
  final List<String> _categories = [
    'Programming', 'Design', 'Business', 'Marketing',
    'Photography', 'Music', 'Language', 'Kuliner', 'Budaya', 'Other'
  ];

  @override
  void initState() {
    super.initState();
    
    _titleController = TextEditingController(text: widget.draftData?.title ?? '');
    _subtitleController = TextEditingController(text: widget.draftData?.subtitle ?? '');
    _descriptionController = TextEditingController(text: widget.draftData?.description ?? '');
    _authorController = TextEditingController(text: widget.draftData?.author ?? '');
    _durationController = TextEditingController(text: widget.draftData?.duration ?? '');
    
    if (widget.draftData != null) {
      _selectedCategory = widget.draftData!.category;
      _thumbnailFile = widget.draftData!.thumbnail;
      _learningOutcomes = List.from(widget.draftData!.learningOutcomes);
      _sections = List.from(widget.draftData!.sections);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _descriptionController.dispose();
    _authorController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  // UPLOAD THUMBNAIL
  Future<void> _pickThumbnail() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _thumbnailFile = File(image.path);
      });
    }
  }

  void _saveDraft() {
    final draftCourse = CourseData(
      title: _titleController.text,
      subtitle: _subtitleController.text,
      author: _authorController.text,
      category: _selectedCategory,
      duration: _durationController.text,
      description: _descriptionController.text,
      thumbnail: _thumbnailFile,
      learningOutcomes: _learningOutcomes,
      sections: _sections,
      isDraft: true,
    );
    
    // Cek apakah ini edit draft atau draft baru
    if (widget.draftData != null) {
      int index = CourseDatabase.draftCourses.indexOf(widget.draftData!);
      if (index != -1) {
        CourseDatabase.draftCourses[index] = draftCourse;
      }
    } else {
      CourseDatabase.draftCourses.add(draftCourse);
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text('Draft Tersimpan'),
          ],
        ),
        content: const Text('Course telah disimpan ke draft.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Kembali ke halaman sebelumnya (akan refresh otomatis)
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _submitCourse() {
    if (_formKey.currentState!.validate()) {
      if (_thumbnailFile == null) {
        _showError('Harap upload thumbnail course');
        return;
      }
      
      if (_sections.isEmpty) {
        _showError('Harap tambahkan minimal satu section');
        return;
      }
      
      bool hasEmptySection = _sections.any((section) => section.lessons.isEmpty);
      if (hasEmptySection) {
        _showError('Setiap section harus memiliki minimal satu lesson');
        return;
      }
      
      final uploadedCourse = CourseData(
        title: _titleController.text,
        subtitle: _subtitleController.text,
        author: _authorController.text,
        category: _selectedCategory,
        duration: _durationController.text,
        description: _descriptionController.text,
        thumbnail: _thumbnailFile,
        learningOutcomes: _learningOutcomes,
        sections: _sections,
        status: CourseStatus.pending,
        uploadDate: _formatDate(DateTime.now()),
        isDraft: false,
      );
      
      CourseDatabase.uploadedCourses.add(uploadedCourse);
      
      // Hapus dari draft jika ini adalah edit draft
      if (widget.draftData != null) {
        CourseDatabase.draftCourses.remove(widget.draftData);
      }
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const CourseStatusPage()),
        (route) => false,
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showAddLearningOutcomeDialog() {
    final TextEditingController controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Tambah Learning Outcome'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'Apa yang akan dipelajari?',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() => _learningOutcomes.add(controller.text));
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  void _addSection() {
    final TextEditingController sectionTitleController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Tambah Section'),
        content: TextField(
          controller: sectionTitleController,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Nama Section',
            hintText: 'Contoh: Pengenalan Dasar',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (sectionTitleController.text.isNotEmpty) {
                setState(() {
                  _sections.add(CourseSection(
                    title: sectionTitleController.text,
                    lessons: [],
                  ));
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  void _showAddLessonDialog(int sectionIndex) {
    final TextEditingController lessonTitleController = TextEditingController();
    String? selectedType;
    String? contentPath;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text('Tambah Lesson'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: lessonTitleController,
                    decoration: InputDecoration(
                      labelText: 'Judul Lesson',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: InputDecoration(
                      labelText: 'Tipe Konten',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'video', child: Text('Video')),
                      DropdownMenuItem(value: 'pdf', child: Text('PDF')),
                      DropdownMenuItem(value: 'text', child: Text('Text')),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        selectedType = value;
                        contentPath = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  if (selectedType != null)
                    OutlinedButton.icon(
                      icon: const Icon(Icons.upload_file),
                      label: Text(contentPath == null ? 'Upload File' : 'File: ${contentPath!.split('/').last}'),
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: selectedType == 'video' 
                              ? ['mp4', 'mov', 'avi']
                              : selectedType == 'pdf'
                                  ? ['pdf']
                                  : ['txt', 'docx'],
                        );
                        
                        if (result != null) {
                          setDialogState(() {
                            contentPath = result.files.single.path;
                          });
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 45),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (lessonTitleController.text.isNotEmpty && selectedType != null) {
                    setState(() {
                      _sections[sectionIndex].lessons.add(
                        Lesson(
                          title: lessonTitleController.text,
                          type: selectedType!,
                          contentPath: contentPath,
                        ),
                      );
                    });
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Tambah'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.draftData != null ? 'Edit Draft' : 'Buat Course Baru'),
        backgroundColor: Colors.white,
        foregroundColor: darkTextColor,
        elevation: 0,
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.save_outlined, size: 20),
            label: const Text('Draft'),
            onPressed: _saveDraft,
            style: TextButton.styleFrom(foregroundColor: primaryColor),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // THUMBNAIL SECTION
              const Text('Thumbnail Course', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkTextColor)),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickThumbnail,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: _thumbnailFile == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined, size: 50, color: Colors.grey[400]),
                            const SizedBox(height: 8),
                            Text('Tap untuk upload thumbnail', style: TextStyle(color: lightTextColor)),
                            Text('Format: JPG, PNG (Max 5MB)', style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_thumbnailFile, fit: BoxFit.cover),
                        ),
                ),
              ),
              const SizedBox(height: 32),
              
              const Text('Informasi Dasar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkTextColor)),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _titleController,
                maxLength: 60,
                decoration: InputDecoration(
                  labelText: 'Judul Course *',
                  prefixIcon: const Icon(Icons.title, color: primaryColor),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) => v?.isEmpty ?? true ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: 'Penulis/Instruktur *',
                  prefixIcon: const Icon(Icons.person_outline, color: primaryColor),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) => v?.isEmpty ?? true ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Kategori *',
                  prefixIcon: const Icon(Icons.category_outlined, color: primaryColor),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (v) => setState(() => _selectedCategory = v),
                validator: (v) => v == null ? 'Kategori wajib dipilih' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(
                  labelText: 'Durasi (contoh: 2 jam 30 menit)',
                  prefixIcon: const Icon(Icons.access_time, color: primaryColor),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 32),
              
              const Text('Deskripsi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkTextColor)),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _descriptionController,
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Lengkap *',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) => v?.isEmpty ?? true ? 'Deskripsi wajib diisi' : null,
              ),
              const SizedBox(height: 32),
              
              const Text('Learning Outcomes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkTextColor)),
              const SizedBox(height: 16),
              
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    if (_learningOutcomes.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text('Belum ada outcome', style: TextStyle(color: lightTextColor)),
                      )
                    else
                      ..._learningOutcomes.asMap().entries.map((e) {
                        return ListTile(
                          leading: const Icon(Icons.check_circle, color: Colors.green, size: 20),
                          title: Text(e.value, style: const TextStyle(fontSize: 14)),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () => setState(() => _learningOutcomes.removeAt(e.key)),
                          ),
                        );
                      }).toList(),
                    Divider(height: 1, color: Colors.grey[200]),
                    ListTile(
                      leading: const Icon(Icons.add_circle_outline, color: primaryColor),
                      title: const Text('Tambah Outcome', style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600)),
                      onTap: _showAddLearningOutcomeDialog,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              const Text('Sections & Lessons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkTextColor)),
              const SizedBox(height: 16),
              
              if (_sections.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Center(
                    child: Text('Belum ada section', style: TextStyle(color: lightTextColor)),
                  ),
                )
              else
                ..._sections.asMap().entries.map((e) {
                  final sectionIndex = e.key;
                  final section = e.value;
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: primaryColor,
                            child: Text('${sectionIndex + 1}', style: const TextStyle(color: Colors.white)),
                          ),
                          title: Text(section.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${section.lessons.length} lessons'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => setState(() => _sections.removeAt(sectionIndex)),
                          ),
                        ),
                        if (section.lessons.isNotEmpty) ...[
                          Divider(height: 1, color: Colors.grey[200]),
                          ...section.lessons.asMap().entries.map((lessonEntry) {
                            return ListTile(
                              dense: true,
                              leading: const SizedBox(width: 20),
                              title: Text(lessonEntry.value.title, style: const TextStyle(fontSize: 14)),
                              subtitle: Text(
                                '${lessonEntry.value.type.toUpperCase()}${lessonEntry.value.contentPath != null ? ' - File uploaded' : ''}',
                                style: TextStyle(fontSize: 12, color: lightTextColor),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () => setState(() => section.lessons.removeAt(lessonEntry.key)),
                              ),
                            );
                          }).toList(),
                        ],
                        Divider(height: 1, color: Colors.grey[200]),
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.add, size: 20, color: primaryColor),
                          title: const Text('Tambah Lesson', style: TextStyle(color: primaryColor, fontSize: 14)),
                          onTap: () => _showAddLessonDialog(sectionIndex),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Tambah Section'),
                onPressed: _addSection,
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 40),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _saveDraft,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Save Draft'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _submitCourse,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Submit Course'),
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
}