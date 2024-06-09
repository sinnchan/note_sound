import 'dart:math';

import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:note_sound/domain/logger/logger.dart';
import 'package:note_sound/domain/providers.dart';
import 'package:note_sound/domain/quiz/value/quiz_entry.dart';
import 'package:note_sound/domain/quiz/value/quiz_master_values.dart';
import 'package:note_sound/domain/sound/note.dart';
import 'package:note_sound/domain/util.dart';
import 'package:note_sound/infrastructure/quiz/quiz_info_repository.dart';
import 'package:note_sound/infrastructure/quiz/quiz_master_repository.dart';
import 'package:note_sound/infrastructure/quiz/quiz_target_repository.dart';
import 'package:note_sound/presentation/ui/pages/quiz/choice_provider.dart';
import 'package:note_sound/presentation/ui/pages/quiz/correct_provider.dart';
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
    final q = state.currentQuiz?.entry;
    if (q == null) {
      return const AnswerResult.noQuestion();
    }

    final correct = q == answer;
    final random = ref.read(randomProvider);
    ref.read(correctProvider.notifier).set((
      correct: correct,
      hash: random.nextInt(1 << 32),
    ));

    if (correct) {
      logger.i('correct!!');
      this.state = AsyncValue.data(
        state.copyWith(correctCount: state.correctCount + 1),
      );
    } else {
      logger.i('wrong..');
    }

    if (state.quizCount == state.currentQuiz?.count) {
      this.state = AsyncValue.data(
        state.copyWith(currentQuiz: null),
      );
      return const AnswerResult.finished();
    }

    await nextQuestion();
    ref.read(choiceProvider.notifier).clear();

    return correct ? const AnswerResult.correct() : const AnswerResult.wrong();
  }

  Future<void> nextQuestion({bool first = false}) async {
    logger.v('nextQuestion(first: $first)');

    state = await AsyncValue.guard(() async {
      const choiceCount = 3;
      final state = await future;

      if (state.quizCount == state.currentQuiz?.count) {
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
        currentQuiz: CurrentQuiz(
          count: first ? 1 : state.currentQuiz?.count.let((it) => it + 1) ?? 1,
          entry: nextQuestion,
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
      currentQuiz: null,
      quizCount: questionCount,
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
