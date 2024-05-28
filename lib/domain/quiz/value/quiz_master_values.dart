import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_sound/domain/quiz/value/quiz_entry.dart';

part 'quiz_master_values.freezed.dart';
part 'quiz_master_values.g.dart';

@freezed
class QuizMasterState with _$QuizMasterState {
  const factory QuizMasterState({
    required List<QuizEntry> entries,
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
    required QuizEntry entry,
    required List<QuizEntry> choices,
  }) = _CurrentQuiz;

  factory CurrentQuiz.fromJson(Map<String, Object?> json) =>
      _$CurrentQuizFromJson(json);
}

@freezed
class AnswerResult with _$AnswerResult {
  const factory AnswerResult.correct() = _AnswerResultCorrect;
  const factory AnswerResult.wrong() = _AnswerResultWrong;
  const factory AnswerResult.finished() = _AnswerResultFinished;
  const factory AnswerResult.noQuestion() = _AnswerResultNoQuestion;

  factory AnswerResult.fromJson(Map<String, Object?> json) =>
      _$AnswerResultFromJson(json);
}

enum QuizType {
  notes,
  chords,
}

extension QuizMasterStateExt on QuizMasterState {
  bool get isFinished => quizCount == currentQuiz?.count;
}

extension AnswerResultExt on AnswerResult {
  bool get isCorrect => this is _AnswerResultCorrect;
  bool get isFinished => this is _AnswerResultFinished;
}
