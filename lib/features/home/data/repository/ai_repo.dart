import 'package:dartz/dartz.dart';
import 'package:my_template/core/error/failures.dart';
import 'package:my_template/core/services/ai_service.dart';

abstract class AIRepo {
  Future<Either<Failure, String>> generateLessonIdeas({
    required String subject,
    required String topic,
    required String gradeLevel,
  });

  Future<Either<Failure, String>> generateQuiz({
    required String subject,
    required String topic,
    required int numberOfQuestions,
    required String questionType,
  });

  Future<Either<Failure, String>> summarizeNotes({required String notes, required String subject});
}

class AIRepoImpl implements AIRepo {
  final AIService _aiService;

  AIRepoImpl(this._aiService);

  @override
  Future<Either<Failure, String>> generateLessonIdeas({
    required String subject,
    required String topic,
    required String gradeLevel,
  }) async {
    try {
      final result = await _aiService.generateLessonIdeas(
        subject: subject,
        topic: topic,
        gradeLevel: gradeLevel,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> generateQuiz({
    required String subject,
    required String topic,
    required int numberOfQuestions,
    required String questionType,
  }) async {
    try {
      final result = await _aiService.generateQuiz(
        subject: subject,
        topic: topic,
        numberOfQuestions: numberOfQuestions,
        questionType: questionType,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> summarizeNotes({
    required String notes,
    required String subject,
  }) async {
    try {
      final result = await _aiService.summarizeNotes(notes: notes, subject: subject);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
