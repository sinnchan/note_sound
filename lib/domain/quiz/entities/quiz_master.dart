import 'dart:math';

import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:note_sound/domain/logger/logger.dart';
import 'package:note_sound/domain/quiz/value/quiz_entry.dart';
import 'package:note_sound/domain/quiz/value/quiz_master_values.dart';
import 'package:note_sound/domain/sound/note.dart';
import 'package:note_sound/domain/util.dart';
import 'package:note_sound/infrastructure/quiz/quiz_info_repository.dart';
import 'package:note_sound/infrastructure/quiz/quiz_master_repository.dart';
import 'package:note_sound/infrastructure/quiz/quiz_target_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_master.g.dart';

@riverpod
class QuizMaster extends _$QuizMaster with CLogger {
  @override
  Future<QuizMasterState> build() async {
    logger.d('build()');

    final stateRepo = await ref.read(quizMasterRepositoryProvider.future);
    final state = (await stateRepo.load()) ?? (await _newState());

    ref.onDispose(() {
      if (this.state.hasValue) {
        this.state.valueOrNull?.let(stateRepo.save);
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

  Future<void> start({bool withReset = true}) async {
    logger.d('start()');

    if (withReset) {
      await reset();
    }

    await nextQuestion(first: true);
  }

  Future<AnswerResult> answer(QuizEntry answer) async {
    logger.d({
      'answer()': {
        'arg1': answer.toJson(),
      },
    });

    final state = await future;
    final q = state.currentQuestion?.question;
    if (q == null) {
      return const AnswerResult.noQuestion();
    }

    final correct = q == answer;
    if (correct) {
      logger.i('correct!!');
      if (state.isFinished) {
        return const AnswerResult.finished();
      } else {
        await nextQuestion();
      }
    } else {
      logger.i('wrong..');
    }

    return correct ? const AnswerResult.correct() : const AnswerResult.wrong();
  }

  Future<void> nextQuestion({bool first = false}) async {
    logger.v('nextQuestion(first: $first)');

    state = await AsyncValue.guard(() async {
      const choiceCount = 3;
      final state = await future;

      if (state.questionCount == state.currentQuestion?.count) {
        logger.i('quiz finished');
        return state;
      }

      final entries = [...state.entries]..shuffle();
      final nextQuestion = entries.removeLast();
      final wrongChoices = List.generate(
        choiceCount - 1,
        (_) => entries.removeLast(),
      ).toList();

      return state.copyWith(
        currentQuestion: CurrentQuizQuestion(
          count:
              first ? 1 : state.currentQuestion?.count.let((it) => it + 1) ?? 1,
          question: nextQuestion,
          choices: [nextQuestion, ...wrongChoices]..shuffle(),
        ),
      );
    });
  }

  Future<void> reset() async {
    logger.i('reset');

    state = await AsyncValue.guard(() async {
      return _newState();
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