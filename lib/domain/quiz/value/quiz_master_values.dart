import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_sound/domain/quiz/value/quiz_entry_target.dart';

part 'quiz_master_values.freezed.dart';
part 'quiz_master_values.g.dart';

@freezed
class QuizMasterState with _$QuizMasterState {
  const factory QuizMasterState({
    required List<QuizEntryTarget> entries,
    required CurrentQuiz? currentQuiz,
    required bool isLoop,
    required int quizCount,
    required int correctCount,
  }) = _QuizMasterState;

  factory QuizMasterState.fromJson(Map<String, Object?> json) =>
      _$QuizMasterStateFromJson(json);
}

@freezed
class CurrentQuiz with _$CurrentQuiz {
  const factory CurrentQuiz({
    required int count,
    required QuizEntryTarget entry,
    required List<QuizEntryTarget> choices,
  }) = _CurrentQuiz;

  factory CurrentQuiz.fromJson(Map<String, Object?> json) =>
      _$CurrentQuizFromJson(json);
}

@freezed
class AnswerResult with _$AnswerResult {
  const factory AnswerResult.correct() = AnswerResultCorrect;
  const factory AnswerResult.wrong() = AnswerResultWrong;
  const factory AnswerResult.finished() = AnswerResultFinished;
  const factory AnswerResult.noQuestion() = AnswerResultNoQuestion;

  factory AnswerResult.fromJson(Map<String, Object?> json) =>
      _$AnswerResultFromJson(json);
}

enum QuizType {
  notes,
  chords,
}

extension AnswerResultExt on AnswerResult {
  bool get isCorrect => this is AnswerResultCorrect;
  bool get isFinished => this is AnswerResultFinished;
}
