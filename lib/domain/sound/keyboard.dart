import 'package:note_sound/domain/sound/note.dart';
import 'package:note_sound/domain/sound/velocity.dart';

abstract class IKeyboard {
  Future<void> push(
    Set<Note> notes, [
    Duration duration = const Duration(seconds: 1),
    Velocity velocity = const Velocity(value: 127),
  ]);
}
