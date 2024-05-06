import 'dart:math';

import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_sound/domain/logger/logger.dart';
import 'package:note_sound/domain/quiz/value/quiz_entry.dart';
import 'package:note_sound/domain/sound/note.dart';
import 'package:note_sound/domain/util.dart';
import 'package:note_sound/infrastructure/quiz/quiz_info_repository.dart';
import 'package:note_sound/infrastructure/quiz/quiz_master_repository.dart';
import 'package:note_sound/infrastructure/quiz/quiz_target_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_master.freezed.dart';
part 'quiz_master.g.dart';

@freezed
class QuizMasterState with _$QuizMasterState {
  const factory QuizMasterState({
    required List<QuizEntry> entries,
    required CurrentQuizQuestion? currentQuestion,
    required bool isLoop,
    required int questionCount,
    required int correctCount,
  }) = _QuizMasterState;

  factory QuizMasterState.fromJson(Map<String, Object?> json) =>
      _$QuizMasterStateFromJson(json);
}

@freezed
class CurrentQuizQuestion with _$CurrentQuizQuestion {
  const factory CurrentQuizQuestion({
    required int count,
    required QuizEntry question,
    required List<QuizEntry> choices,
  }) = _CurrentQuizQuestion;

  factory CurrentQuizQuestion.fromJson(Map<String, Object?> json) =>
      _$CurrentQuizQuestionFromJson(json);
}

enum QuizType {
  notes,
  chords,
}

@riverpod
class QuizMaster extends _$QuizMaster with ClassLogger {
  @override
  Future<QuizMasterState> build() async {
    logger.d('build()');

    final repository = await ref.read(quizMasterRepositoryProvider.future);
    final state = (await repository.load()) ?? (await _newState());

    ref.onDispose(() {
      if (this.state.hasValue) {
        this.state.valueOrNull?.let(repository.save);
      }
    });

    logger.i(state.toJson());

    return state;
  }

  @override
  set state(AsyncValue<QuizMasterState> newState) {
    logger.v(newState.toJson((data) => data.toJson()));
    super.state = newState;
  }

  Future<void> start() async {
    logger.d('start()');

    final state = this.state.valueOrNull;
    if (state == null) {
      logger.w({
        'message': 'illegal state',
        'state': this.state.toJson((data) => data.toJson()),
      });
      return;
    }

    await nextQuestion(reset: true);
  }

  bool answer(QuizEntry answer) {
    logger.d({
      'answer()': {
        'arg1': answer.toJson(),
      },
    });

    final q = state.mapOrNull(data: (d) {
      return d.valueOrNull?.currentQuestion?.question;
    });
    if (q == null) {
      return false;
    }

    final correct = q == answer;
    if (correct) {
      logger.i('correct!!');
    } else {
      logger.i('wrong..');
    }

    return correct;
  }

  void skip() {
    logger.d('skip');
    nextQuestion();
  }

  Future<void> nextQuestion({bool reset = false}) async {
    logger.v('nextQuestion(reset: $reset)');

    state = state.selectMap(data: (d) {
      const choiceCount = 3;
      final state = d.value;
      final entries = [...state.entries]..shuffle();
      final nextQuestion = entries.removeLast();
      final wrongChoices = List.generate(
        choiceCount - 1,
        (_) => entries.removeLast(),
      ).toList();

      return AsyncData(
        state.copyWith(
          currentQuestion: CurrentQuizQuestion(
            count: reset
                ? 1
                : state.currentQuestion?.count.let((it) => it + 1) ?? 1,
            question: nextQuestion,
            choices: [nextQuestion, ...wrongChoices]..shuffle(),
          ),
        ),
      );
    });
  }

  void clear() {
    logger.i('clear');
    state = state.selectMap(data: (d) {
      return const AsyncData(
        QuizMasterState(
          entries: [],
          currentQuestion: null,
          isLoop: false,
          questionCount: 0,
          correctCount: 0,
        ),
      );
    });
  }

  Future<QuizMasterState> _newState() async {
    final infoRepo = await ref.read(quizInfoRepositoryProvider.future);
    final targetRepo = await ref.read(quizTargetRepositoryProvider.future);
    final targets = await targetRepo.getAllTargetNotes();
    final questionCount = await infoRepo.getQuizNoteCount();

    return QuizMasterState(
      entries: targets
          .map((number) => Note(number: number))
          .map((note) => QuizEntry.note(note))
          .toList(),
      currentQuestion: null,
      questionCount: questionCount,
      correctCount: 0,
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
