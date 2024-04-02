import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_sound/domain/sound/note.dart';

part 'quiz_master.freezed.dart';
part 'quiz_master.g.dart';

@freezed
sealed class QuizEntry with _$QuizEntry {
  const factory QuizEntry.note(Note note) = QuizEntryNote;
  const factory QuizEntry.chord(Note note) = QuizEntryChord;

  factory QuizEntry.fromJson(Map<String, Object?> json) =>
      _$QuizEntryFromJson(json);
}

class QuizMaster {
  QuizEntry get question {
    throw UnimplementedError();
  }

  bool answer(QuizEntry answer) {
    throw UnimplementedError();
  }

  void skip() {
    throw UnimplementedError();
  }

  void reset() {
    throw UnimplementedError();
  }
}
