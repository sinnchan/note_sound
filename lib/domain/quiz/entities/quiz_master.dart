import 'dart:math';

import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:note_sound/domain/logger/logger.dart';
import 'package:note_sound/domain/providers.dart';
import 'package:note_sound/domain/quiz/value/answer_result.dart';
import 'package:note_sound/domain/quiz/value/quiz_entry.dart';
import 'package:note_sound/domain/quiz/value/quiz_entry_target.dart';
import 'package:note_sound/domain/quiz/value/quiz_master_state.dart';
import 'package:note_sound/domain/sound/note.dart';
import 'package:note_sound/domain/util.dart';
import 'package:note_sound/infrastructure/quiz/quiz_info_repository.dart';
import 'package:note_sound/infrastructure/quiz/quiz_master_state_repository.dart';
import 'package:note_sound/infrastructure/quiz/quiz_target_repository.dart';
import 'package:note_sound/infrastructure/util/uuid/generator.dart';
import 'package:note_sound/presentation/ui/pages/quiz/choice_provider.dart';
import 'package:note_sound/presentation/ui/pages/quiz/correct_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_master.g.dart';

@riverpod
class QuizMaster extends _$QuizMaster with CLogger {
  @override
  Future<QuizMasterState> build() async {
    logger.d('build()');

    final stateRepo = await ref.read(quizMasterStateRepositoryProvider.future);
    final state = (await stateRepo.load()) ?? (await _genNewState());

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

    final state = await future;
    this.state = AsyncData(
      state.copyWith(quizIndex: 0),
    );
  }

  Future<AnswerResult> answer(QuizEntryTarget answer) async {
    logger.d({
      'answer()': {
        'arg1': answer.toJson(),
      },
    });

    var state = await future;
    final q = state.currentQuiz;
    if (q == null) {
      return const AnswerResult.noQuestion();
    }

    final correct = q.target == answer;
    final random = ref.read(randomProvider);
    ref.read(correctProvider.notifier).set((
      correct: correct,
      hash: random.nextInt(1 << 32),
    ));

    if (correct) {
      logger.i('correct!!');
    } else {
      logger.i('wrong..');
    }

    // update correct
    final copiedEntries = [...state.entries];
    copiedEntries[state.quizIndex] = q.copyWith(correct: correct);

    this.state = AsyncValue.data(
      state.copyWith(
        quizIndex: min(state.quizIndex + 1, state.entries.length - 1),
        entries: copiedEntries,
      ),
    );

    if (state.quizIndex == state.entries.length - 1) {
      return const AnswerResult.finished();
    }

    ref.read(choiceProvider.notifier).clear();

    return correct ? const AnswerResult.correct() : const AnswerResult.wrong();
  }

  Future<void> reset() async {
    logger.i('reset');

    state = await AsyncValue.guard(() async {
      return _genNewState();
    });
  }

  Future<QuizMasterState> _genNewState() async {
    const quizWrongChoiceCount = 3;
    final uuid = ref.read(uuidGeneratorProvider);
    final rand = ref.read(randomProvider);
    final infoRepo = await ref.read(quizInfoRepositoryProvider.future);
    final targetRepo = await ref.read(quizTargetRepositoryProvider.future);
    final quizCount = await infoRepo.getQuizCount();
    final targets = await targetRepo.getAllTargetNotes().then((notes) {
      return notes.map(QuizEntryTarget.note).toList();
    });

    return QuizMasterState(
      id: uuid.v4(),
      quizIndex: 0,
      entries: List.generate(quizCount, (index) {
        final targetIndex = rand.nextInt(targets.length);
        final target = targets[targetIndex];

        final wrongChoices = targets
            .where((t) => t != target)
            .toList()
            .also((it) => it.shuffle())
            .take(quizWrongChoiceCount);
        final choices = [target, ...wrongChoices]..shuffle();

        return QuizEntry(
          id: uuid.v4(),
          target: target,
          choices: choices,
        );
      }),
    );
  }

  static List<QuizEntryTarget> createRandomNoteEntries({
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

    final entries = notes.map((e) => QuizEntryTarget.note(e)).toList();
    if (isEnabledShuffle) {
      entries.shuffle();
    } else {
      entries.sort();
    }

    return entries;
  }
}
