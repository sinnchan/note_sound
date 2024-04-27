import 'package:flutter_test/flutter_test.dart';
import 'package:note_sound/domain/sound/accidental.dart';
import 'package:note_sound/domain/sound/note.dart';

void main() {
  group('notes', () {
    test('note name', () {
      expect(() => Note(number: -1).fullName(), throwsA(isA<AssertionError>()));
      expect(
          () => Note(number: 128).fullName(), throwsA(isA<AssertionError>()));
      expect(const Note(number: 0).fullName(), 'C-1');
      expect(const Note(number: 1).fullName(), 'C♯-1');
      expect(const Note(number: 1).fullName(Accidental.flat), 'D♭-1');
      expect(const Note(number: 127).fullName(), 'G9');
    });

    test('octave', () {
      expect(
          () => Note(number: -1).octaveNumber, throwsA(isA<AssertionError>()));
      expect(
          () => Note(number: 128).octaveNumber, throwsA(isA<AssertionError>()));
      expect(const Note(number: 0).octaveNumber, -1);
      expect(const Note(number: 11).octaveNumber, -1);
      expect(const Note(number: 12).octaveNumber, 0);
      expect(const Note(number: 23).octaveNumber, 0);
      expect(const Note(number: 127).octaveNumber, 9);
    });

    test('sharp', () {
      expect(Note.c.sharp.number, 37);
      expect(Note.c.sharp.name(), 'C♯');
      expect(Note.c.sharp.sharp, Note.d);
    });

    test('flat', () {
      expect(Note.c.flat.number, 35);
      expect(Note.c.flat.name(), 'B');
      expect(Note.c.flat.flat, Note.a.sharp.shift(octave: -1));
    });

    test('shift', () {
      expect(Note.c.shift(octave: 1), const Note(number: 48));
    });
  });
}
