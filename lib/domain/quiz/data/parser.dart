import 'package:note_sound/domain/logger/logger.dart';
import 'package:note_sound/domain/quiz/value/quiz_entry_target.dart';
import 'package:note_sound/domain/sound/note.dart';

class EntryDataPaser with CLogger {
  EntryDataPaser();

  QuizEntryTarget? parse(String entry) {
    try {
      final splited = entry.split(':');
      final sound = splited.first;
      final octave = int.parse(splited.last);

      if (sound.isEmpty) {
        throw 'sound is empty';
      }

      final note = Note.fromName(sound, octave);
      if (note != null) {
        return QuizEntryTarget.note(note);
      }

      // TODO
      throw 1;
    } catch (e, st) {
      logger.w('failed to parse: $entry', error: e, stackTrace: st);
      return null;
    }
  }
}
