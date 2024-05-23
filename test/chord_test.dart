import 'package:flutter_test/flutter_test.dart';
import 'package:note_sound/domain/sound/chord.dart';
import 'package:note_sound/domain/sound/note.dart';

void main() {
  group('chord', () {
    test('fromName', () {
      // #, b
      expect(
        Chord.fromName('C#M')?.notes,
        {Note.c.sharp, Note.e.sharp, Note.g.sharp},
      );
      expect(
        Chord.fromName('CbM')?.notes,
        {Note.c.flat, Note.e.flat, Note.g.flat},
      );

      // omits
      expect(
        Chord.fromName('CMomit4')?.notes,
        {Note.c, Note.g},
      );
      expect(
        Chord.fromName('CbMomit0')?.notes,
        {Note.e.flat, Note.g.flat},
      );

      // 分数コード
      expect(
        Chord.fromName('C/E')?.notes,
        {Note.c, Note.e, Note.g},
      );

      // octave
      expect(
        Chord.fromName('CM:4')?.notes,
        {Note.c, Note.e, Note.g},
      );
      expect(
        Chord.fromName('CM:5')?.notes,
        {
          Note.c.shiftOctave(1),
          Note.e.shiftOctave(1),
          Note.g.shiftOctave(1),
        },
      );

      // chords
      expect(
        Chord.fromName('CM')?.notes,
        {Note.c, Note.e, Note.g},
      );
      expect(
        Chord.fromName('Cm')?.notes,
        {Note.c, Note.e.flat, Note.g},
      );
      expect(
        Chord.fromName('C7')?.notes,
        {Note.c, Note.e, Note.g, Note.b.flat},
      );
      expect(
        Chord.fromName('Cm7')?.notes,
        {Note.c, Note.e.flat, Note.g, Note.b.flat},
      );
      expect(
        Chord.fromName('CM7')?.notes,
        {Note.c, Note.e, Note.g, Note.b},
      );
      expect(
        Chord.fromName('Cdim7')?.notes,
        {Note.c, Note.e.flat, Note.g.flat, Note.a},
      );
      expect(
        Chord.fromName('Cdim')?.notes,
        {Note.c, Note.e.flat, Note.g.flat},
      );
      expect(
        Chord.fromName('Caug')?.notes,
        {Note.c, Note.e, Note.g.sharp},
      );
      expect(
        Chord.fromName('Csus4')?.notes,
        {Note.c, Note.f, Note.g},
      );
      expect(
        Chord.fromName('Csus2')?.notes,
        {Note.c, Note.d, Note.g},
      );
      expect(
        Chord.fromName('C6')?.notes,
        {Note.c, Note.e, Note.g, Note.a},
      );
      expect(
        Chord.fromName('Cm6')?.notes,
        {Note.c, Note.e.flat, Note.g, Note.a},
      );
      expect(
        Chord.fromName('C9')?.notes,
        {Note.c, Note.e, Note.g, Note.b.flat, Note.d.shiftOctave(1)},
      );
      expect(
        Chord.fromName('CM9')?.notes,
        {Note.c, Note.e, Note.g, Note.b, Note.d.shiftOctave(1)},
      );
      expect(
        Chord.fromName('Cm9')?.notes,
        {Note.c, Note.e.flat, Note.g, Note.b.flat, Note.d.shiftOctave(1)},
      );
      expect(
        Chord.fromName('C69')?.notes,
        {Note.c, Note.e, Note.g, Note.a, Note.d.shiftOctave(1)},
      );
      expect(
        Chord.fromName('Cm69')?.notes,
        {Note.c, Note.e.flat, Note.g, Note.a, Note.d.shiftOctave(1)},
      );
      expect(
        Chord.fromName('CmM9')?.notes,
        {Note.c, Note.e.flat, Note.g, Note.b, Note.d.shiftOctave(1)},
      );
      expect(
        Chord.fromName('C7sus4')?.notes,
        {Note.c, Note.f, Note.g, Note.b.flat},
      );
      expect(
        Chord.fromName('Cadd9')?.notes,
        {Note.c, Note.e, Note.g, Note.d.shiftOctave(1)},
      );
      expect(
        Chord.fromName('Cadd11')?.notes,
        {Note.c, Note.e, Note.g, Note.f.shiftOctave(1)},
      );
      expect(
        Chord.fromName('C7b5')?.notes,
        {Note.c, Note.e, Note.g.flat, Note.b.flat},
      );
      expect(
        Chord.fromName('C7-5')?.notes,
        {Note.c, Note.e, Note.g.flat, Note.b.flat},
      );
      expect(
        Chord.fromName('C7#5')?.notes,
        {Note.c, Note.e, Note.g.sharp, Note.b.flat},
      );
      expect(
        Chord.fromName('C7+5')?.notes,
        {Note.c, Note.e, Note.g.sharp, Note.b.flat},
      );
      expect(
        Chord.fromName('Cm7b5')?.notes,
        {Note.c, Note.e.flat, Note.g.flat, Note.b.flat},
      );
      expect(
        Chord.fromName('Cm7-5')?.notes,
        {Note.c, Note.e.flat, Note.g.flat, Note.b.flat},
      );
      expect(
        Chord.fromName('Cm7#5')?.notes,
        {Note.c, Note.e.flat, Note.g.sharp, Note.b.flat},
      );
      expect(
        Chord.fromName('Cm7+5')?.notes,
        {Note.c, Note.e.flat, Note.g.sharp, Note.b.flat},
      );
      expect(
        Chord.fromName('C11')?.notes,
        {
          Note.c,
          Note.e,
          Note.g,
          Note.b.flat,
          Note.d.shiftOctave(1),
          Note.f.shiftOctave(1),
        },
      );
      expect(
        Chord.fromName('Cm11')?.notes,
        {
          Note.c,
          Note.e.flat,
          Note.g,
          Note.b.flat,
          Note.d.shiftOctave(1),
          Note.f.shiftOctave(1),
        },
      );
      expect(
        Chord.fromName('C13')?.notes,
        {
          Note.c,
          Note.e,
          Note.g,
          Note.b.flat,
          Note.d.shiftOctave(1),
          Note.f.shiftOctave(1),
          Note.a.shiftOctave(1),
        },
      );
      expect(
        Chord.fromName('Cm13')?.notes,
        {
          Note.c,
          Note.e.flat,
          Note.g,
          Note.b.flat,
          Note.d.shiftOctave(1),
          Note.f.shiftOctave(1),
          Note.a.shiftOctave(1),
        },
      );
      expect(
        Chord.fromName('CM13')?.notes,
        {
          Note.c,
          Note.e,
          Note.g,
          Note.b,
          Note.d.shiftOctave(1),
          Note.f.shiftOctave(1),
          Note.a.shiftOctave(1),
        },
      );
    });
  });
}
