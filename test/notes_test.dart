import 'package:flutter_test/flutter_test.dart';
import 'package:note_sound/domain/models/note/note.dart';

void main() {
  group('notes', () {
    test('note name', () {
      expect(() => Note(-1).fullName(), throwsA(isA<AssertionError>()));
      expect(() => Note(128).fullName(), throwsA(isA<AssertionError>()));
      expect(const Note(0).fullName(), 'C-1');
      expect(const Note(1).fullName(), 'C♯-1');
      expect(const Note(1).fullName(Accidental.flat), 'D♭-1');
      expect(const Note(127).fullName(), 'G9');
    });

    test('octave', () {
      expect(() => Note(-1).octave, throwsA(isA<AssertionError>()));
      expect(() => Note(128).octave, throwsA(isA<AssertionError>()));
      expect(const Note(0).octave, -1);
      expect(const Note(11).octave, -1);
      expect(const Note(12).octave, 0);
      expect(const Note(23).octave, 0);
      expect(const Note(127).octave, 9);
    });
  });
}
