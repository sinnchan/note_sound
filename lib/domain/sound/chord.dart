import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_sound/domain/sound/note.dart';

part 'chord.freezed.dart';
part 'chord.g.dart';

@freezed
class Chord with _$Chord {
  const factory Chord(Set<Note> notes) = _Chord;

  factory Chord.fromJson(Map<String, Object?> json) => _$ChordFromJson(json);
}
