import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';
import 'package:note_sound/domain/sound/note.dart';

part 'db_quiz_master_satate.freezed.dart';
part 'db_quiz_master_satate.g.dart';

typedef DbQuisMasterStateId = int;
typedef DbQuisEntryId = int;

@freezed
@collection
class DbQuizMasterState with _$DbQuizMasterState {
  const factory DbQuizMasterState({
    required DbQuisMasterStateId id,
    required int? quizIndex,
    required bool isFinished,
    required bool isLoop,
  }) = _DbQuizMasterState;

  factory DbQuizMasterState.fromJson(Map<String, Object?> json) =>
      _$DbQuizMasterStateFromJson(json);
}

@freezed
@collection
class DbQuizEntry with _$DbQuizEntry {
  const factory DbQuizEntry({
    required DbQuisEntryId id,
    required DbQuisMasterStateId parentId,
    required int index,
    required List<NoteNumber> entry,
  }) = _DbQuizEntry;

  factory DbQuizEntry.fromJson(Map<String, Object?> json) =>
      _$DbQuizEntryFromJson(json);
}
