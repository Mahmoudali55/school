import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  static const String _apiKey =
      'AIzaSyDRSUw8UGrgZjsY9j8JlNfC-TLEWfP9y8A'; // TODO: Replace with actual API key
  late final GenerativeModel _model;

  AIService() {
    _model = GenerativeModel(model: 'gemini-2.5-flash-lite-preview-09-2025', apiKey: _apiKey);
  }

  /// Generate lesson ideas based on subject and topic
  Future<String> generateLessonIdeas({
    required String subject,
    required String topic,
    required String gradeLevel,
  }) async {
    final prompt =
        '''

 $subject
 $topic
 $gradeLevel


''';

    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    return response.text ?? 'لم يتم توليد أفكار';
  }

  /// Generate quiz questions based on topic
  Future<String> generateQuiz({
    required String subject,
    required String topic,
    required int numberOfQuestions,
    required String questionType, // 'multiple_choice', 'true_false', 'mixed'
  }) async {
    final prompt =
        '''

$subject
 $topic
$numberOfQuestions
${_getQuestionTypeInArabic(questionType)}


''';

    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    return response.text ?? 'لم يتم توليد الاختبار';
  }

  /// Summarize class notes
  Future<String> summarizeNotes({required String notes, required String subject}) async {
    final prompt =
        '''


$subject


$notes

''';

    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    return response.text ?? 'لم يتم توليد الملخص';
  }

  String _getQuestionTypeInArabic(String type) {
    switch (type) {
      case 'multiple_choice':
        return 'اختيار من متعدد';
      case 'true_false':
        return 'صح وخطأ';
      case 'mixed':
        return 'مختلط (اختيار من متعدد وصح وخطأ)';
      default:
        return 'مختلط';
    }
  }
}
