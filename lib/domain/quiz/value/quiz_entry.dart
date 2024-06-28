import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_sound/domain/quiz/value/quiz_entry_target.dart';

part 'quiz_entry.freezed.dart';
part 'quiz_entry.g.dart';

typedef QuizEntryId = String;

@freezed
class QuizEntry with _$QuizEntry {
  const factory QuizEntry({
    required QuizEntryId id,
    required QuizEntryTarget target,
    required List<QuizEntryTarget> choices,
    @Default(null) bool? correct,
  }) = _QuizEntry;

  factory QuizEntry.fromJson(Map<String, Object?> json) =>
      _$QuizEntryFromJson(json);
}
