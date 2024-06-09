import 'package:freezed_annotation/freezed_annotation.dart';

part 'answer_result.freezed.dart';
part 'answer_result.g.dart';

@freezed
class AnswerResult with _$AnswerResult {
  const factory AnswerResult.correct() = AnswerResultCorrect;
  const factory AnswerResult.wrong() = AnswerResultWrong;
  const factory AnswerResult.finished() = AnswerResultFinished;
  const factory AnswerResult.noQuestion() = AnswerResultNoQuestion;

  factory AnswerResult.fromJson(Map<String, Object?> json) =>
      _$AnswerResultFromJson(json);
}

extension AnswerResultExt on AnswerResult {
  bool get isCorrect => this is AnswerResultCorrect;
  bool get isFinished => this is AnswerResultFinished;
}
