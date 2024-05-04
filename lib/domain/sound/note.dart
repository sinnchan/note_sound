import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_sound/domain/sound/accidental.dart';

part 'note.freezed.dart';
part 'note.g.dart';

typedef NoteNumber = int;

@freezed
class Note with _$Note {
  static const NoteNumber max = 127;
  static const NoteNumber min = 0;
  static const NoteNumber semitonePerOctave = 12;

  @Assert('Note.min <= number && number <= Note.max')
  const factory Note({
    required NoteNumber number,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  static List<Note> all() {
    return List.generate(
      Note.max + 1,
      (i) => Note(number: i),
    );
  }

  static Note get c => const Note(number: 36);
  static Note get d => const Note(number: 38);
  static Note get e => const Note(number: 40);
  static Note get f => const Note(number: 41);
  static Note get g => const Note(number: 43);
  static Note get a => const Note(number: 45);
  static Note get b => const Note(number: 47);
}

extension NoteImpl on Note {
  String fullName([Accidental accidental = Accidental.sharp]) {
    return '${name(accidental)}$octaveNumber';
  }

  String name([Accidental accidental = Accidental.sharp]) {
    return _notes[number % Note.semitonePerOctave]![accidental]!;
  }

  int get octaveNumber {
    return (number ~/ Note.semitonePerOctave) - 1;
  }

  bool get isBlackKey {
    return switch (number % Note.semitonePerOctave) {
      1 || 3 || 5 || 8 || 10 => true,
      _ => false,
    };
  }

  Note get sharp => Note(number: number + 1);

  Note get flat => Note(number: number - 1);

  Note shift({required int octave}) {
    return Note(number: number + (Note.semitonePerOctave * octave));
  }
}

final _notes = {
  0: {
    Accidental.sharp: 'C',
    Accidental.flat: 'C',
  },
  1: {
    Accidental.sharp: 'C♯',
    Accidental.flat: 'D♭',
  },
  2: {
    Accidental.sharp: 'D',
    Accidental.flat: 'D',
  },
  3: {
    Accidental.sharp: 'D♯',
    Accidental.flat: 'E♭',
  },
  4: {
    Accidental.sharp: 'E',
    Accidental.flat: 'E',
  },
  5: {
    Accidental.sharp: 'E♯',
    Accidental.flat: 'F♭',
  },
  6: {
    Accidental.sharp: 'F',
    Accidental.flat: 'F',
  },
  7: {
    Accidental.sharp: 'G',
    Accidental.flat: 'G',
  },
  8: {
    Accidental.sharp: 'G♯',
    Accidental.flat: 'A♭',
  },
  9: {
    Accidental.sharp: 'A',
    Accidental.flat: 'A',
  },
  10: {
    Accidental.sharp: 'A♯',
    Accidental.flat: 'B♭',
  },
  11: {
    Accidental.sharp: 'B',
    Accidental.flat: 'B',
  },
};
