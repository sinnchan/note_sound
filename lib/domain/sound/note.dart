import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_sound/domain/sound/accidental.dart';

part 'note.freezed.dart';
part 'note.g.dart';

const int _maxNoteNum = 127;
const int _minNoteNum = 0;
const int _semitonePerOctave = 12;

@freezed
class Note with _$Note {
  @Assert('_minNoteNum <= number && number <= _maxNoteNum')
  const factory Note({
    required int number,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}

extension NoteImpl on Note {
  String fullName([Accidental accidental = Accidental.sharp]) {
    return '${name(accidental)}$octave';
  }

  String name([Accidental accidental = Accidental.sharp]) {
    return _notes[number % _semitonePerOctave]![accidental]!;
  }

  int get octave {
    return (number ~/ _semitonePerOctave) - 1;
  }

  bool get isBlackKey {
    return switch (number % _semitonePerOctave) {
      1 || 3 || 5 || 8 || 10 => true,
      _ => false,
    };
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
