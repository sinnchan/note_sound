import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_sound/domain/sound/chord.dart';
import 'package:note_sound/domain/sound/note.dart';

part 'quiz_entry_target.freezed.dart';
part 'quiz_entry_target.g.dart';

@freezed
sealed class QuizEntryTarget with _$QuizEntryTarget {
  const factory QuizEntryTarget.note(Note note) = QuizEntryTargetNote;
  const factory QuizEntryTarget.chord(Chord chord) = QuizEntryTargetChord;

  factory QuizEntryTarget.fromJson(Map<String, Object?> json) =>
      _$QuizEntryTargetFromJson(json);

  factory QuizEntryTarget(Set<Note> notes) {
    switch (notes.length) {
      case 0:
        throw ArgumentError.value(notes);
      case 1:
        return QuizEntryTarget.note(notes.first);
      default:
        return QuizEntryTarget.chord(Chord(notes));
    }
  }
}

extension QuizEntryImpl on QuizEntryTarget {
  Set<Note> toNotes() {
    return when(
      note: (note) => {note},
      chord: (chord) => chord.notes,
    );
  }

  List<int> toNoteNumbers() {
    return toNotes().map((e) => e.number).toList();
  }
}
