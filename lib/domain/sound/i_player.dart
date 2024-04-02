import 'package:note_sound/domain/sound/note.dart';

abstract class ISoundPlayer {
  Future<void> play(
    Set<Note> notes, [
    Duration duration = const Duration(seconds: 1),
  ]);
}
