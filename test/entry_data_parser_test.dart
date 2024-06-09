import 'package:flutter_test/flutter_test.dart';
import 'package:note_sound/domain/quiz/data/parser.dart';
import 'package:note_sound/domain/quiz/value/quiz_entry_target.dart';
import 'package:note_sound/domain/sound/note.dart';

void main() {
  final parser = EntryDataPaser();

  test('C', () {
    expect(parser.parse('C:4'), QuizEntryTarget.note(Note.c));
    expect(parser.parse('D:4'), QuizEntryTarget.note(Note.d));
    expect(parser.parse('E:4'), QuizEntryTarget.note(Note.e));
    expect(parser.parse('F:4'), QuizEntryTarget.note(Note.f));
    expect(parser.parse('G:4'), QuizEntryTarget.note(Note.g));
    expect(parser.parse('A:4'), QuizEntryTarget.note(Note.a));
    expect(parser.parse('B:4'), QuizEntryTarget.note(Note.b));

    expect(parser.parse('C:-1'), QuizEntryTarget.note(Note.c.shiftOctave(-5)));
    expect(parser.parse('G:9'), QuizEntryTarget.note(Note.g.shiftOctave(5)));
  });
}
