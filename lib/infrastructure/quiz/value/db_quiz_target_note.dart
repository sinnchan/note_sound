import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';
import 'package:note_sound/domain/sound/note.dart';

part 'db_quiz_target_note.freezed.dart';
part 'db_quiz_target_note.g.dart';

@freezed
@collection
class DbQuizTargetNote with _$DbQuizTargetNote {
  const factory DbQuizTargetNote({
    @Id() required NoteNumber number,
  }) = _DbQuizTargetNote;

  factory DbQuizTargetNote.fromJson(Map<String, Object?> json) =>
      _$DbQuizTargetNoteFromJson(json);
}
