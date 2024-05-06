import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:note_sound/infrastructure/quiz/value/db_quiz_target_note.dart';

part 'isar.g.dart';

@riverpod
Future<Isar> isar(IsarRef ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = Isar.open(
    schemas: [
      DbQuizTargetNoteSchema,
    ],
    directory: dir.path,
  );

  ref.onDispose(isar.close);

  return isar;
}
