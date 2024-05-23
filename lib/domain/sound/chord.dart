import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_sound/domain/sound/note.dart';

part 'chord.freezed.dart';

part 'chord.g.dart';

@freezed
class Chord with _$Chord {
  const factory Chord(Set<Note> notes) = _Chord;

  factory Chord.fromJson(Map<String, Object?> json) => _$ChordFromJson(json);

  static Chord? fromName(String name, [int defaultOctave = 4]) {
    final pattern = RegExp(r'^([A-G][♯♭#b]?)(.*?)(?::(\d+))?$');
    final match = pattern.firstMatch(name);
    if (match == null) return null;

    final rootName = match.group(1)!;
    final chordType = match.group(2);
    final octaveStr = match.group(3);
    final octave = octaveStr != null ? int.parse(octaveStr) : defaultOctave;

    final rootNote = Note.fromName(rootName, octave);
    if (rootNote == null) return null;

    var formula = chordFormulas[chordType] ?? [0, 4, 7];

    // omit処理
    final omitPattern = RegExp(r'omit(\d+)');
    final omitMatch = omitPattern.firstMatch(chordType ?? '')?.group(1);
    if (omitMatch != null) {
      final omitIntervals = omitMatch.split(',').map(int.parse).toList();
      formula = formula.whereNot(omitIntervals.contains).toList();
    }

    final chordNotes = formula.map(rootNote.shift).toSet();
    return Chord(chordNotes);
  }

  static const chordFormulas = {
    'M': [0, 4, 7],
    'm': [0, 3, 7],
    'dim': [0, 3, 6],
    'aug': [0, 4, 8],
    'sus4': [0, 5, 7],
    'sus2': [0, 2, 7],
    '7': [0, 4, 7, 10],
    '7b5': [0, 4, 6, 10],
    '7-5': [0, 4, 6, 10],
    '7#5': [0, 4, 8, 10],
    '7+5': [0, 4, 8, 10],
    'm7': [0, 3, 7, 10],
    'm7b5': [0, 3, 6, 10],
    'm7-5': [0, 3, 6, 10],
    'm7#5': [0, 3, 8, 10],
    'm7+5': [0, 3, 8, 10],
    'M7': [0, 4, 7, 11],
    'mM7': [0, 3, 7, 11],
    '6': [0, 4, 7, 9],
    'm6': [0, 3, 7, 9],
    '9': [0, 4, 7, 10, 14],
    'M9': [0, 4, 7, 11, 14],
    'm9': [0, 3, 7, 10, 14],
    '69': [0, 4, 7, 9, 14],
    'm69': [0, 3, 7, 9, 14],
    'dim7': [0, 3, 6, 9],
    '7sus4': [0, 5, 7, 10],
    'add9': [0, 4, 7, 14],
    'add11': [0, 4, 7, 17],
    'mM9': [0, 3, 7, 11, 14],
    '11': [0, 4, 7, 10, 14, 17],
    'm11': [0, 3, 7, 10, 14, 17],
    '13': [0, 4, 7, 10, 14, 17, 21],
    'm13': [0, 3, 7, 10, 14, 17, 21],
    'M13': [0, 4, 7, 11, 14, 17, 21],
  };
}
