import 'package:equatable/equatable.dart';
import 'package:my_template/core/network/status.state.dart';

class AIState extends Equatable {
  final StatusState<String> lessonIdeasStatus;
  final StatusState<String> quizStatus;
  final StatusState<String> summaryStatus;

  const AIState({
    this.lessonIdeasStatus = const StatusState.initial(),
    this.quizStatus = const StatusState.initial(),
    this.summaryStatus = const StatusState.initial(),
  });

  AIState copyWith({
    StatusState<String>? lessonIdeasStatus,
    StatusState<String>? quizStatus,
    StatusState<String>? summaryStatus,
  }) {
    return AIState(
      lessonIdeasStatus: lessonIdeasStatus ?? this.lessonIdeasStatus,
      quizStatus: quizStatus ?? this.quizStatus,
      summaryStatus: summaryStatus ?? this.summaryStatus,
    );
  }

  @override
  List<Object?> get props => [lessonIdeasStatus, quizStatus, summaryStatus];
}
