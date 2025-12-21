// lib/module_content_model.dart

class ModuleContent {
  final String title;
  final String duration;
  final String contentTitle;
  final String contentText;
  final bool isQuiz;

  ModuleContent({
    required this.title,
    required this.duration,
    required this.contentTitle,
    required this.contentText,
    this.isQuiz = false,
  });
}