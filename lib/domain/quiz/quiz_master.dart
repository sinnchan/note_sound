import 'dart:math';

import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_sound/domain/logger/logger.dart';
import 'package:note_sound/domain/quiz/quiz_entry.dart';
import 'package:note_sound/domain/sound/note.dart';
import 'package:note_sound/domain/util.dart';
import 'package:note_sound/infrastructure/quiz/quiz_master_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_master.freezed.dart';
part 'quiz_master.g.dart';

typedef QuizMasterStateId = int;

@freezed
class QuizMasterState with _$QuizMasterState {
  const factory QuizMasterState({
    required QuizMasterStateId? id,
    required List<QuizEntry> entries,
    int? quizIndex,
    required bool isFinished,
    required bool isLoop,
  }) = _QuizMasterState;

  factory QuizMasterState.fromJson(Map<String, Object?> json) =>
      _$QuizMasterStateFromJson(json);
}

@riverpod
class QuizMaster extends _$QuizMaster with ClassLogger {
  @override
  Future<QuizMasterState> build({QuizMasterStateId id = 1}) async {
    logger.d('build(id: $id)');

    final repository = await ref.read(quizMasterRepositoryProvider.future);
    final state = (await repository.load(id: id)) ?? _newState(id);

    final subscription = repository
        .stream(id: id)
        .map(AsyncData.new)
        .listen((s) => this.state = s);

    ref.onDispose(() {
      if (this.state.hasValue) {
        this.state.valueOrNull?.let(repository.save);
      }
      subscription.cancel();
    });

    logger.i(state.toJson());

    return state;
  }

  @override
  set state(AsyncValue<QuizMasterState> newState) {
    logger.v(newState.toJson((data) => data.toJson()));
    super.state = newState;
  }

  void setEntries(List<QuizEntry> entries) {
    state = state.selectMap(
      data: (d) => AsyncValue.data(
        d.value.copyWith(
          entries: entries,
          quizIndex: null,
        ),
      ),
    );
  }

  void start() {
    final state = this.state.valueOrNull;
    if (state == null) {
      logger.w({
        'message': 'illegal state',
        'state': this.state.toJson((data) => data.toJson()),
      });
      return;
    }

    if (state.entries.isEmpty) {
      logger.i('entries is empty');
      return;
    }

    this.state = AsyncData(state.copyWith(quizIndex: 0));
  }

  QuizEntry? getQuestion() {
    final state = this.state.valueOrNull;
    if (state == null) {
      logger.w({
        'message': 'illegal state',
        'state': this.state.toJson((data) => data.toJson()),
      });
      return null;
    }

    final index = state.quizIndex;
    if (state.entries.isEmpty ||
        index == null ||
        state.entries.length < index) {
      logger.i({
        'message': 'entry is empty, or not started, or finished.',
        'state': state.toJson(),
      });
      return null;
    }

    final entry = state.entries[index];
    logger.i({
      'quiz_index': state.quizIndex,
      'entry': entry,
    });

    return entry;
  }

  bool answer(QuizEntry answer) {
    final q = getQuestion();
    if (q == null) {
      return false;
    }

    final correct = q == answer;

    if (correct) {
      logger.i('correct!!');
      _nextQuestion();
    }
    return correct;
  }

  void skip() {
    logger.i('skip');
    _nextQuestion();
  }

  void _nextQuestion() {
    state = state.selectMap(data: (d) {
      final state = d.value;
      final index = state.quizIndex;
      final nextIndex = state.entries.isEmpty || index == null
          ? null
          : min(state.entries.length - 1, index + 1);

      if (nextIndex == null) {
        logger.i('no next index.');
      }
      if (index == nextIndex) {
        logger.i('this is last question!');
      }

      return AsyncValue.data(
        d.value.copyWith(quizIndex: nextIndex),
      );
    });
  }

  void reset() {
    logger.i('reset');
    ref.invalidateSelf();
  }

  QuizMasterState _newState(QuizMasterStateId id) {
    return QuizMasterState(
      id: id,
      entries: [],
      quizIndex: 0,
      isFinished: false,
      isLoop: false,
    );
  }

  static List<QuizEntry> createRandomNoteEntries({
    required int count,
    int max = Note.max,
    int min = Note.min,
    required bool isEnabledShuffle,
  }) {
    final rand = Random();
    final notes = <Note>[];

    for (var i = 0; i < count; i++) {
      final note = Note(number: rand.nextInt(max) + min);
      notes.add(note);
    }

    final entries = notes.map((e) => QuizEntry.note(e)).toList();
    if (isEnabledShuffle) {
      entries.shuffle();
    } else {
      entries.sort();
    }

    return entries;
  }
}
