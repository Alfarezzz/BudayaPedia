// lib/pages/form_course.dart
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'course_model.dart';
import 'status_course.dart';
import 'draft_course.dart';

const Color primaryColor = Color(0xFF2C3E50);
const Color darkTextColor = Color(0xFF1E2A3B);
const Color lightTextColor = Color(0xFF5A6B80);
const Color accentColor = Color(0xFF3498DB);

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

  Future<void> _pickThumbnail() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _thumbnailFile = File(image.path);
      });
    }
  }

  // 1. Fungsi internal untuk menyimpan data ke database tanpa memunculkan dialog
  void _saveDraftInternal() {
    final draftCourse = CourseData(
      title: _titleController.text.isNotEmpty ? _titleController.text : 'Untitled Course',
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
    
    if (widget.draftData != null) {
      int index = CourseDatabase.draftCourses.indexOf(widget.draftData!);
      if (index != -1) {
        CourseDatabase.draftCourses[index] = draftCourse;
      }
    } else {
      CourseDatabase.draftCourses.add(draftCourse);
    }
  }

  // 2. Fungsi baru khusus untuk tombol pojok kanan atas
  void _saveAndGoToDrafts() {
    _saveDraftInternal(); // Simpan data dulu
    
    // Langsung navigasi ke halaman Draft
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DraftCoursePage()),
    );
  }

  void _saveDraft() {
    final draftCourse = CourseData(
      title: _titleController.text.isNotEmpty ? _titleController.text : 'Untitled Course',
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 12),
            Text('Draft Tersimpan'),
          ],
        ),
        content: const Text('Course telah disimpan ke draft.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    List<QuizQuestion> quizQuestions = [];

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
                      DropdownMenuItem(value: 'pdf', child: Text('📄 PDF Document')),
                      DropdownMenuItem(value: 'text', child: Text('📝 Text/Article')),
                      DropdownMenuItem(value: 'quiz', child: Text('❓ Quiz')),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        selectedType = value;
                        contentPath = null;
                        quizQuestions = [];
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // PDF Upload
                  if (selectedType == 'pdf')
                    OutlinedButton.icon(
                      icon: const Icon(Icons.upload_file),
                      label: Text(contentPath == null ? 'Upload PDF' : 'File: ${contentPath!.split('/').last}'),
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                        
                        if (result != null) {
                          setDialogState(() {
                            contentPath = result.files.single.path;
                          });
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        minimumSize: const Size(double.infinity, 45),
                      ),
                    ),
                  
                  // Text/Article Input
                  if (selectedType == 'text')
                    TextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Tulis artikel/konten',
                        hintText: 'Ketik konten teks di sini...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onChanged: (value) {
                        contentPath = value;
                      },
                    ),
                  
                  // Quiz Builder
                  if (selectedType == 'quiz') ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: accentColor.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.quiz, color: accentColor, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Quiz Questions (${quizQuestions.length})',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: accentColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (quizQuestions.isEmpty)
                            Center(
                              child: Text(
                                'Belum ada pertanyaan',
                                style: TextStyle(color: lightTextColor, fontSize: 13),
                              ),
                            )
                          else
                            ...quizQuestions.asMap().entries.map((entry) {
                              final idx = entry.key;
                              final q = entry.value;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: primaryColor,
                                      child: Text('${idx + 1}', style: const TextStyle(fontSize: 10, color: Colors.white)),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        q.question,
                                        style: const TextStyle(fontSize: 13),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close, size: 18),
                                      onPressed: () {
                                        setDialogState(() {
                                          quizQuestions.removeAt(idx);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Tambah Pertanyaan'),
                            onPressed: () {
                              _showAddQuizQuestionDialog(context, (question) {
                                setDialogState(() {
                                  quizQuestions.add(question);
                                });
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: accentColor,
                              minimumSize: const Size(double.infinity, 40),
                              side: BorderSide(color: accentColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                  if (lessonTitleController.text.isEmpty) {
                    _showError('Judul lesson harus diisi');
                    return;
                  }
                  
                  if (selectedType == null) {
                    _showError('Pilih tipe konten');
                    return;
                  }
                  
                  if (selectedType == 'pdf' && contentPath == null) {
                    _showError('Upload file PDF terlebih dahulu');
                    return;
                  }
                  
                  if (selectedType == 'text' && (contentPath == null || contentPath!.isEmpty)) {
                    _showError('Tulis konten artikel terlebih dahulu');
                    return;
                  }
                  
                  if (selectedType == 'quiz' && quizQuestions.isEmpty) {
                    _showError('Tambahkan minimal 1 pertanyaan quiz');
                    return;
                  }
                  
                  setState(() {
                    _sections[sectionIndex].lessons.add(
                      Lesson(
                        title: lessonTitleController.text,
                        type: selectedType!,
                        contentPath: selectedType == 'quiz' ? '${quizQuestions.length} questions' : contentPath,
                        quizQuestions: selectedType == 'quiz' ? quizQuestions : null,
                      ),
                    );
                  });
                  Navigator.pop(context);
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

  void _showAddQuizQuestionDialog(BuildContext parentContext, Function(QuizQuestion) onAdd) {
    final questionController = TextEditingController();
    final option1Controller = TextEditingController();
    final option2Controller = TextEditingController();
    final option3Controller = TextEditingController();
    final option4Controller = TextEditingController();
    int correctAnswer = 0;

    showDialog(
      context: parentContext,
      builder: (context) => StatefulBuilder(
        builder: (context, setQuizState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text('Buat Pertanyaan Quiz'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: questionController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Pertanyaan',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Pilihan Jawaban:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  
                  _buildQuizOption(option1Controller, 'A', 0, correctAnswer, (val) {
                    setQuizState(() => correctAnswer = val);
                  }),
                  const SizedBox(height: 8),
                  _buildQuizOption(option2Controller, 'B', 1, correctAnswer, (val) {
                    setQuizState(() => correctAnswer = val);
                  }),
                  const SizedBox(height: 8),
                  _buildQuizOption(option3Controller, 'C', 2, correctAnswer, (val) {
                    setQuizState(() => correctAnswer = val);
                  }),
                  const SizedBox(height: 8),
                  _buildQuizOption(option4Controller, 'D', 3, correctAnswer, (val) {
                    setQuizState(() => correctAnswer = val);
                  }),
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
                  if (questionController.text.isEmpty) {
                    _showError('Pertanyaan harus diisi');
                    return;
                  }
                  
                  if (option1Controller.text.isEmpty || option2Controller.text.isEmpty ||
                      option3Controller.text.isEmpty || option4Controller.text.isEmpty) {
                    _showError('Semua pilihan jawaban harus diisi');
                    return;
                  }
                  
                  final question = QuizQuestion(
                    question: questionController.text,
                    options: [
                      option1Controller.text,
                      option2Controller.text,
                      option3Controller.text,
                      option4Controller.text,
                    ],
                    correctAnswer: correctAnswer,
                  );
                  
                  onAdd(question);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuizOption(TextEditingController controller, String label, int value, int groupValue, Function(int) onChanged) {
    return Row(
      children: [
        Radio<int>(
          value: value,
          groupValue: groupValue,
          onChanged: (val) => onChanged(val!),
          activeColor: Colors.green,
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Opsi $label',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(widget.draftData != null ? 'Edit Draft' : 'Buat Course Baru'),
        backgroundColor: Colors.white,
        foregroundColor: darkTextColor,
        elevation: 0,
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.save_outlined, size: 20),
            label: const Text('Draft'),
            onPressed: _saveAndGoToDrafts,
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
              // THUMBNAIL
              const Text('Thumbnail Course', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkTextColor)),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickThumbnail,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
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
                  filled: true,
                  fillColor: Colors.white,
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
                  filled: true,
                  fillColor: Colors.white,
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
                  filled: true,
                  fillColor: Colors.white,
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
                  filled: true,
                  fillColor: Colors.white,
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
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (v) => v?.isEmpty ?? true ? 'Deskripsi wajib diisi' : null,
              ),
              const SizedBox(height: 32),
              
              const Text('Learning Outcomes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkTextColor)),
              const SizedBox(height: 16),
              
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Center(
                    child: Text('Belum ada section', style: TextStyle(color: lightTextColor)),
                  ),
                )
              else
                ..._sections.asMap().entries.map((e) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: primaryColor,
                        child: Text('${e.key + 1}', style: const TextStyle(color: Colors.white)),
                      ),
                      title: Text(e.value.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${e.value.lessons.length} lessons'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => setState(() => _sections.removeAt(e.key)),
                      ),
                      children: [
                        if (e.value.lessons.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text('Belum ada lesson', style: TextStyle(color: lightTextColor)),
                          )
                        else
                          ...e.value.lessons.map((lesson) {
                            IconData lessonIcon;
                            Color lessonColor;
                            
                            switch (lesson.type) {
                              case 'pdf':
                                lessonIcon = Icons.picture_as_pdf;
                                lessonColor = Colors.red;
                                break;
                              case 'text':
                                lessonIcon = Icons.article;
                                lessonColor = Colors.blue;
                                break;
                              case 'quiz':
                                lessonIcon = Icons.quiz;
                                lessonColor = Colors.orange;
                                break;
                              default:
                                lessonIcon = Icons.circle;
                                lessonColor = Colors.grey;
                            }
                            
                            return ListTile(
                              dense: true,
                              leading: Icon(lessonIcon, color: lessonColor, size: 20),
                              title: Text(lesson.title, style: const TextStyle(fontSize: 14)),
                              subtitle: Text(lesson.type.toUpperCase(), style: const TextStyle(fontSize: 11)),
                            );
                          }).toList(),
                        Divider(height: 1, color: Colors.grey[200]),
                        ListTile(
                          leading: const Icon(Icons.add_circle_outline, color: primaryColor),
                          title: const Text('Tambah Lesson', style: TextStyle(color: primaryColor)),
                          onTap: () => _showAddLessonDialog(e.key),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              
              OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Tambah Section'),
                onPressed: _addSection,
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: const BorderSide(color: primaryColor),
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
                        foregroundColor: Colors.grey[700],
                        side: BorderSide(color: Colors.grey[400]!),
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
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 50),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Submit untuk Review', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}