import 'package:flutter_test/flutter_test.dart';
import 'package:note_sound/domain/lesson/parser.dart';
import 'package:note_sound/domain/quiz/value/quiz_entry.dart';
import 'package:note_sound/domain/sound/note.dart';

void main() {
  final parser = EntryDataPaser();

  test('C', () {
    expect(parser.parse('C:4'), QuizEntry.note(Note.c));
    expect(parser.parse('D:4'), QuizEntry.note(Note.d));
    expect(parser.parse('E:4'), QuizEntry.note(Note.e));
    expect(parser.parse('F:4'), QuizEntry.note(Note.f));
    expect(parser.parse('G:4'), QuizEntry.note(Note.g));
    expect(parser.parse('A:4'), QuizEntry.note(Note.a));
    expect(parser.parse('B:4'), QuizEntry.note(Note.b));

    expect(parser.parse('C:-1'), QuizEntry.note(Note.c.shiftOctave(-5)));
    expect(parser.parse('G:9'), QuizEntry.note(Note.g.shiftOctave(5)));
  });
}
