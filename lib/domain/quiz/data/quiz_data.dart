import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_sound/domain/quiz/value/quiz_entry_target.dart';

part 'quiz_data.freezed.dart';
part 'quiz_data.g.dart';

@freezed
class QuizData with _$QuizData {
  const factory QuizData({
    required String version,
    required DateTime updatedAt,
    required List<NoteQuiz> note,
  }) = _QuizData;

  factory QuizData.fromJson(Map<String, Object?> json) =>
      _$QuizDataFromJson(json);
}

@freezed
class NoteQuiz with _$NoteQuiz {
  const factory NoteQuiz({
    required String title,
    required String description,
    required List<Quiz> quizList,
  }) = _NoteQuiz;

  factory NoteQuiz.fromJson(Map<String, Object?> json) =>
      _$NoteQuizFromJson(json);
}

@freezed
class Quiz with _$Quiz {
  const factory Quiz({
    required String title,
    String? description,
    required int questions,
    int? choices,
    required List<QuizEntryTarget> entries,
  }) = _Quiz;

  factory Quiz.fromJson(Map<String, Object?> json) => _$QuizFromJson(json);
}

// class _QuizEntryConverter implements JsonConverter<List<QuizEntry>, String> {
//   const _QuizEntryConverter();
//
//   @override
//   List<QuizEntry> fromJson(String json) {
//     throw 1;
//   }
//
//   @override
//   String toJson(List<QuizEntry> data) {
//     jsonEncode(data);
//   }
// }
