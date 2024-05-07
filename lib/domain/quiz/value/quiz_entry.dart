import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_sound/domain/sound/chord.dart';
import 'package:note_sound/domain/sound/note.dart';

part 'quiz_entry.freezed.dart';
part 'quiz_entry.g.dart';

@freezed
sealed class QuizEntry with _$QuizEntry {
  const factory QuizEntry.note(Note note) = QuizEntryNote;
  const factory QuizEntry.chord(Chord chord) = QuizEntryChord;

  factory QuizEntry.fromJson(Map<String, Object?> json) =>
      _$QuizEntryFromJson(json);

  factory QuizEntry(Set<Note> notes) {
    switch (notes.length) {
      case 0:
        throw ArgumentError.value(notes);
      case 1:
        return QuizEntry.note(notes.first);
      default:
        return QuizEntry.chord(Chord(notes));
    }
  }
}

extension QuizEntryImpl on QuizEntry {
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
