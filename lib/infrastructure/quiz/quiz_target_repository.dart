import 'package:isar/isar.dart';
import 'package:note_sound/domain/logger/logger.dart';
import 'package:note_sound/domain/sound/note.dart';
import 'package:note_sound/infrastructure/quiz/value/db_quiz_target_note.dart';
import 'package:note_sound/infrastructure/util/extensions/provider_ext.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_target_repository.g.dart';

@riverpod
Future<QuizTargetRepository> quizTargetRepository(
  QuizTargetRepositoryRef ref,
) async {
  return QuizTargetRepository(await ref.isar);
}

class QuizTargetRepository with CLogger {
  final Isar isar;

  QuizTargetRepository(this.isar);

  Stream<bool> isTargetNote(NoteNumber number) {
    logger.d('isTargetNote($number)');

    return isar.dbQuizTargetNotes
        .watchObject(number, fireImmediately: true)
        .map((target) => target != null);
  }

  Future<List<NoteNumber>> getAllTargetNotes() async {
    return isar.dbQuizTargetNotes
        .where()
        .findAll()
        .map((e) => e.number)
        .toList();
  }

  Future<void> saveTargetAllNote(bool enable) async {
    logger.d('saveTargetAllNote($enable)');

    final notes = Note.all().map((e) {
      return DbQuizTargetNote(number: e.number);
    }).toList();

    await isar.writeAsync((isar) {
      if (enable) {
        isar.dbQuizTargetNotes.putAll(notes);
      } else {
        final ids = notes.map((e) => e.number).toList();
        isar.dbQuizTargetNotes.deleteAll(ids);
      }
    });
  }

  Future<void> saveTargetNote(NoteNumber number) async {
    logger.d('saveTargetNote($number)');

    await isar.writeAsync((isar) {
      isar.dbQuizTargetNotes.put(
        DbQuizTargetNote(number: number),
      );
    });
  }

  Future<void> clearTargetNote(NoteNumber number) async {
    logger.d('clearTargetNote($number)');

    await isar.writeAsync((isar) {
      isar.dbQuizTargetNotes.delete(number);
    });
  }
}
