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
      expect(const Note(number: 65).fullName(), 'F4');
      expect(const Note(number: 66).fullName(), 'F♯4');
    });

    test('octave', () {
      expect(
        () => Note(number: -1).octaveNumber,
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => Note(number: 128).octaveNumber,
        throwsA(isA<AssertionError>()),
      );
      expect(const Note(number: 0).octaveNumber, -1);
      expect(const Note(number: 11).octaveNumber, -1);
      expect(const Note(number: 12).octaveNumber, 0);
      expect(const Note(number: 23).octaveNumber, 0);
      expect(const Note(number: 127).octaveNumber, 9);
    });

    test('sharp', () {
      expect(Note.c.sharp.number, 61);
      expect(Note.c.sharp.name(), 'C♯');
      expect(Note.c.sharp.sharp, Note.d);
    });

    test('flat', () {
      expect(Note.c.flat.number, 59);
      expect(Note.c.flat.name(), 'B');
      expect(Note.c.flat.flat, Note.a.sharp.shiftOctave(-1));
    });

    test('shift', () {
      expect(Note.c.shiftOctave(1), const Note(number: 72));
    });

    test('fromName', () {
      expect(Note.fromName('C'), Note.c);
      expect(Note.fromName('C♯'), Note.c.sharp);
      expect(Note.fromName('C♭'), Note.c.flat);
      expect(Note.fromName('C', 3), Note.c.shiftOctave(-1));
      expect(Note.fromName('C♯', 3), Note.c.sharp.shiftOctave(-1));
      expect(Note.fromName('C#', 3), Note.c.sharp.shiftOctave(-1));
      expect(Note.fromName('C♭', 3), Note.c.flat.shiftOctave(-1));
      expect(Note.fromName('Cb', 3), Note.c.flat.shiftOctave(-1));
      expect(Note.fromName('C', -1), const Note(number: 0));
      expect(Note.fromName('C6'), null);
      expect(Note.fromName('C6'), null);
      expect(Note.fromName('C7(13)'), null);
      expect(Note.fromName('C7(9)'), null);
      expect(Note.fromName('C7-5'), null);
      expect(Note.fromName('C7'), null);
      expect(Note.fromName('C7sus4'), null);
      expect(Note.fromName('CM7'), null);
      expect(Note.fromName('CM'), null);
      expect(Note.fromName('Cadd9'), null);
      expect(Note.fromName('Caug'), null);
      expect(Note.fromName('Cdim'), null);
      expect(Note.fromName('Cm6'), null);
      expect(Note.fromName('Cm7(9)'), null);
      expect(Note.fromName('Cm7-5'), null);
      expect(Note.fromName('Cm7'), null);
      expect(Note.fromName('Cm'), null);
      expect(Note.fromName('CmM7'), null);
      expect(Note.fromName('Csus4'), null);
    });
  });
}
