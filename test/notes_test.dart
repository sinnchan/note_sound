import 'package:flutter_test/flutter_test.dart';
import 'package:note_sound/domain/sound/accidental.dart';
import 'package:note_sound/domain/sound/note.dart';

void main() {
  group('notes', () {
    test('note name', () {
      expect(() => Note(number: -1).fullName(), throwsA(isA<AssertionError>()));
      expect(() => Note(number: 128).fullName(), throwsA(isA<AssertionError>()));
      expect(const Note(number: 0).fullName(), 'C-1');
      expect(const Note(number: 1).fullName(), 'C♯-1');
      expect(const Note(number: 1).fullName(Accidental.flat), 'D♭-1');
      expect(const Note(number: 127).fullName(), 'G9');
    });

    test('octave', () {
      expect(() => Note(number: -1).octave, throwsA(isA<AssertionError>()));
      expect(() => Note(number: 128).octave, throwsA(isA<AssertionError>()));
      expect(const Note(number: 0).octave, -1);
      expect(const Note(number: 11).octave, -1);
      expect(const Note(number: 12).octave, 0);
      expect(const Note(number: 23).octave, 0);
      expect(const Note(number: 127).octave, 9);
    });
  });
}
