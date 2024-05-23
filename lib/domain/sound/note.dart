import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_sound/domain/sound/accidental.dart';

part 'note.freezed.dart';
part 'note.g.dart';

typedef NoteNumber = int;

const sharp = '♯';
const flat = '♭';

@freezed
class Note with _$Note {
  static const NoteNumber max = 127;
  static const NoteNumber min = 0;
  static const NoteNumber octaveCount = 12;

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

  static Note get c => const Note(number: 60);
  static Note get d => const Note(number: 62);
  static Note get e => const Note(number: 64);
  static Note get f => const Note(number: 65);
  static Note get g => const Note(number: 67);
  static Note get a => const Note(number: 69);
  static Note get b => const Note(number: 71);

  static Note? fromName(String name, [int octave = 4]) {
    try {
      final String strNote;
      final String? strAcc;

      switch (name.runes.length) {
        case 1:
          strNote = name.substring(0, 1);
          strAcc = null;
        case 2:
          strNote = name.substring(0, 1);
          strAcc = name.substring(1, 2);
        default:
          return null;
      }

      var note = switch (strNote) {
        'C' => Note.c,
        'D' => Note.d,
        'E' => Note.e,
        'F' => Note.f,
        'G' => Note.g,
        'A' => Note.a,
        'B' => Note.b,
        _ => throw "Invalid arg: $name",
      };

      note = note.shiftOctave(octave - note.octaveNumber);

      note = switch (strAcc) {
        null => note,
        sharp => note.sharp,
        '#' => note.sharp,
        flat => note.flat,
        'b' => note.flat,
        _ => throw "Invalid arg: $name",
      };

      return note;
    } catch (_) {
      return null;
    }
  }
}

extension NoteImpl on Note {
  String fullName([Accidental accidental = Accidental.sharp]) {
    return '${name(accidental)}$octaveNumber';
  }

  String name([Accidental accidental = Accidental.sharp]) {
    return _notes[number % Note.octaveCount]![accidental]!;
  }

  int get octaveNumber {
    return (number ~/ Note.octaveCount) - 1;
  }

  bool get isBlackKey {
    return switch (number % Note.octaveCount) {
      1 || 3 || 5 || 8 || 10 => true,
      _ => false,
    };
  }

  Note get sharp => shift(1);

  Note get flat => shift(-1);

  Note shift(int count) {
    return Note(number: number + count);
  }

  Note shiftOctave(int octave) {
    return shift(Note.octaveCount * octave);
  }
}

final _notes = {
  0: {
    Accidental.sharp: 'C',
    Accidental.flat: 'C',
  },
  1: {
    Accidental.sharp: 'C$sharp',
    Accidental.flat: 'D♭',
  },
  2: {
    Accidental.sharp: 'D',
    Accidental.flat: 'D',
  },
  3: {
    Accidental.sharp: 'D$sharp',
    Accidental.flat: 'E♭',
  },
  4: {
    Accidental.sharp: 'E',
    Accidental.flat: 'E',
  },
  5: {
    Accidental.sharp: 'F',
    Accidental.flat: 'F',
  },
  6: {
    Accidental.sharp: 'F$sharp',
    Accidental.flat: 'G♭',
  },
  7: {
    Accidental.sharp: 'G',
    Accidental.flat: 'G',
  },
  8: {
    Accidental.sharp: 'G$sharp',
    Accidental.flat: 'A♭',
  },
  9: {
    Accidental.sharp: 'A',
    Accidental.flat: 'A',
  },
  10: {
    Accidental.sharp: 'A$sharp',
    Accidental.flat: 'B♭',
  },
  11: {
    Accidental.sharp: 'B',
    Accidental.flat: 'B',
  },
};
