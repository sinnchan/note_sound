import 'package:collection/collection.dart';
import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:isar/isar.dart';
import 'package:note_sound/domain/logger/logger.dart';
import 'package:note_sound/domain/quiz/quiz_entry.dart';
import 'package:note_sound/domain/quiz/quiz_master.dart';
import 'package:note_sound/domain/sound/note.dart';
import 'package:note_sound/infrastructure/quiz/db_quiz_master_satate.dart';
import 'package:note_sound/infrastructure/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'quiz_master_repository.g.dart';

@riverpod
Future<QuizMasterRepository> quizMasterRepository(
  QuizMasterRepositoryRef ref,
) async {
  final repository = QuizMasterRepository(null);

  await repository.init();

  return repository;
}

class QuizMasterRepository extends Repository
    with ClassLogger
    implements IQuizMasterRepository {
  QuizMasterRepository(super._isar);

  @override
  Stream<QuizMasterState> stream({required QuizMasterStateId id}) {
    final stateStream = isar.dbQuizMasterStates
        .watchObject(id, fireImmediately: true)
        .whereNotNull();
    final entriesStream = isar.dbQuizEntrys
        .where()
        .parentIdEqualTo(id)
        .watch(fireImmediately: true);

    return CombineLatestStream.combine2(
      stateStream,
      entriesStream,
      _decode,
    );
  }

  @override
  Future<QuizMasterState?> load({required QuizMasterStateId id}) async {
    final state = isar.dbQuizMasterStates.get(id);
    final entries = isar.dbQuizEntrys.where().parentIdEqualTo(id).findAll();

    return state?.let((it) => _decode(it, entries));
  }

  @override
  Future<void> save(QuizMasterState value) async {
    final encoded = _encode(value);

    await isar.writeAsync((isar) {
      isar.dbQuizMasterStates.put(encoded.state);
      isar.dbQuizEntrys.putAll(encoded.entries);
    });
  }

  ({DbQuizMasterState state, List<DbQuizEntry> entries}) _encode(
    QuizMasterState state,
  ) {
    final parentId = state.id ?? isar.dbQuizMasterStates.autoIncrement();
    final dbState = DbQuizMasterState(
      id: parentId,
      quizIndex: state.quizIndex,
      isFinished: state.isFinished,
      isLoop: state.isLoop,
    );
    final dbEntries = state.entries.mapIndexed((i, e) {
      return DbQuizEntry(
        id: _cantorPair(parentId, i),
        parentId: parentId,
        index: i,
        entry: e.toNoteNumbers(),
      );
    }).toList();

    return (state: dbState, entries: dbEntries);
  }

  QuizMasterState _decode(
    DbQuizMasterState state,
    List<DbQuizEntry> entries,
  ) {
    return QuizMasterState(
      id: state.id,
      entries: entries
          .sorted((a, b) => a.index.compareTo(b.index))
          .map((e) => QuizEntry(e.entry.map((e) => Note(number: e)).toSet()))
          .toList(),
      quizIndex: state.quizIndex,
      isFinished: state.isFinished,
      isLoop: state.isLoop,
    );
  }

  // ２つの数字が一意に定まる方程式
  int _cantorPair(int x, int y) {
    return (((x + y) * (x + y + 1) / 2) + y).toInt();
  }
}