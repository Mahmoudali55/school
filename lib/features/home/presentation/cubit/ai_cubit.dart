import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/home/data/repository/ai_repo.dart';
import 'package:my_template/features/home/presentation/cubit/ai_state.dart';

class AICubit extends Cubit<AIState> {
  final AIRepo _aiRepo;

  AICubit(this._aiRepo) : super(const AIState());

  Future<void> generateLessonIdeas({
    required String subject,
    required String topic,
    required String gradeLevel,
  }) async {
    if (isClosed) return;
    emit(state.copyWith(lessonIdeasStatus: const StatusState.loading()));

    final result = await _aiRepo.generateLessonIdeas(
      subject: subject,
      topic: topic,
      gradeLevel: gradeLevel,
    );

    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(lessonIdeasStatus: StatusState.failure(failure.errMessage))),
      (ideas) => emit(state.copyWith(lessonIdeasStatus: StatusState.success(ideas))),
    );
  }

  Future<void> generateQuiz({
    required String subject,
    required String topic,
    required int numberOfQuestions,
    required String questionType,
  }) async {
    if (isClosed) return;
    emit(state.copyWith(quizStatus: const StatusState.loading()));

    final result = await _aiRepo.generateQuiz(
      subject: subject,
      topic: topic,
      numberOfQuestions: numberOfQuestions,
      questionType: questionType,
    );

    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(quizStatus: StatusState.failure(failure.errMessage))),
      (quiz) => emit(state.copyWith(quizStatus: StatusState.success(quiz))),
    );
  }

  Future<void> summarizeNotes({required String notes, required String subject}) async {
    if (isClosed) return;
    emit(state.copyWith(summaryStatus: const StatusState.loading()));

    final result = await _aiRepo.summarizeNotes(notes: notes, subject: subject);

    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(summaryStatus: StatusState.failure(failure.errMessage))),
      (summary) => emit(state.copyWith(summaryStatus: StatusState.success(summary))),
    );
  }

  void resetLessonIdeasStatus() {
    if (isClosed) return;
    emit(state.copyWith(lessonIdeasStatus: const StatusState.initial()));
  }

  void resetQuizStatus() {
    if (isClosed) return;
    emit(state.copyWith(quizStatus: const StatusState.initial()));
  }

  void resetSummaryStatus() {
    if (isClosed) return;
    emit(state.copyWith(summaryStatus: const StatusState.initial()));
  }
}
