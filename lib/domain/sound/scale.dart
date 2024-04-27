import 'package:note_sound/domain/sound/note.dart';

enum Scale {
  ionian,
  aeolian,
  dorian,
  phrigian,
  lydian,
  mixolydian,
  locrian,
}

extension ScaleImpl on Scale {
  List<Note> get notes {
    switch (this) {
      case Scale.ionian:
        return [
          Note.c,
          Note.d,
          Note.e,
          Note.f,
          Note.g,
          Note.a,
          Note.b,
        ];
      case Scale.dorian:
        return [
          Note.c,
          Note.d,
          Note.e.flat,
          Note.f,
          Note.g,
          Note.a,
          Note.b.flat,
        ];
      case Scale.phrigian:
        return [
          Note.c,
          Note.d.flat,
          Note.e.flat,
          Note.f,
          Note.g,
          Note.a.flat,
          Note.b.flat,
        ];
      case Scale.lydian:
        return [
          Note.c,
          Note.d,
          Note.e,
          Note.f.sharp,
          Note.g,
          Note.a,
          Note.b,
        ];
      case Scale.mixolydian:
        return [
          Note.c,
          Note.d,
          Note.e,
          Note.f,
          Note.g,
          Note.a,
          Note.b.flat,
        ];
      case Scale.aeolian:
        return [
          Note.c,
          Note.d,
          Note.e.flat,
          Note.f,
          Note.g,
          Note.a.flat,
          Note.b.flat,
        ];
      case Scale.locrian:
        return [
          Note.c,
          Note.d.flat,
          Note.e.flat,
          Note.f,
          Note.g.flat,
          Note.a.flat,
          Note.b.flat,
        ];
    }
  }
}
