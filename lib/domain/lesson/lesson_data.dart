import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_sound/domain/quiz/value/quiz_entry.dart';

part 'lesson_data.freezed.dart';
part 'lesson_data.g.dart';

@freezed
class LessonData with _$LessonData {
  const factory LessonData({
    required String version,
    required DateTime updatedAt,
    required List<NoteLesson> note,
  }) = _LessonData;

  factory LessonData.fromJson(Map<String, Object?> json) =>
      _$LessonDataFromJson(json);
}

@freezed
class NoteLesson with _$NoteLesson {
  const factory NoteLesson({
    required String title,
    required String description,
    required List<Lesson> lessons,
  }) = _NoteLesson;

  factory NoteLesson.fromJson(Map<String, Object?> json) =>
      _$NoteLessonFromJson(json);
}

@freezed
class Lesson with _$Lesson {
  const factory Lesson({
    required String title,
    String? description,
    required int questions,
    int? choices,
    required List<QuizEntry> entries,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, Object?> json) => _$LessonFromJson(json);
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
