import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/material.dart';
import 'package:note_sound/domain/logger/logger.dart';
import 'package:note_sound/domain/sound/velocity.dart' as sound;
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_sound/domain/quiz/entities/quiz_master.dart';
import 'package:note_sound/domain/quiz/value/quiz_entry.dart';
import 'package:note_sound/domain/quiz/value/quiz_master_values.dart';
import 'package:note_sound/domain/sound/note.dart';
import 'package:note_sound/infrastructure/quiz/quiz_info_repository.dart';
import 'package:note_sound/infrastructure/sound/player/player.dart';
import 'package:note_sound/infrastructure/sound/synthesizer/synthesizer.dart';
import 'package:note_sound/presentation/ui/widgets/buttons.dart';
import 'package:note_sound/presentation/util/list_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_questions_page.g.dart';

@riverpod
class _Choice extends _$Choice {
  @override
  QuizEntry? build() {
    return null;
  }

  void choice(QuizEntry entry) {
    state = entry;
  }

  void clear() {
    state = null;
  }
}

class QuizQuestionsPage extends HookConsumerWidget with CLogger {
  final QuizType type;

  QuizQuestionsPage({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quizMasterProvider).valueOrNull;
    final master = ref.watch(quizMasterProvider.notifier);
    final choice = ref.watch(_choiceProvider);
    final choiceNotifier = ref.watch(_choiceProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: _progress(state),
        automaticallyImplyLeading: false,
        leading: context.canPop()
            ? IconButton(
                onPressed: context.pop,
                icon: const Icon(Icons.close),
              )
            : null,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 5,
            child: Stack(
              children: [
                const _SampleButton(),
                Container(
                  padding: const EdgeInsets.all(12),
                  alignment: Alignment.centerRight,
                  child: Column(
                    children: [
                      AnimatedCrossFade(
                        firstChild: _enableChoiceButton(ref),
                        secondChild: _disableChoiceButton(ref),
                        crossFadeState: ref.watch(enableChoiceSoundProvider)
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 100),
                      ),
                    ].withSeparater(const SizedBox(height: 16)),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: state?.currentQuestion?.choices
                      .map((e) => _ChoiceButton(e))
                      .toList()
                      .withSeparater(const SizedBox(height: 16)) ??
                  [],
            ),
          ),
          Flexible(
            flex: 2,
            child: Center(
              child: ElevatedButton(
                onPressed: choice != null
                    ? () async {
                        final result = await master.answer(choice);
                        if (result.isCorrect || result.isFinished) {
                          choiceNotifier.clear();
                        } else {}
                      }
                    : null,
                child: const Text('決定'),
              ),
            ),
          ),
          const Flexible(
            flex: 1,
            child: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _disableChoiceButton(WidgetRef ref) {
    return SizedBox.square(
      dimension: 48,
      child: IconButton.outlined(
        onPressed: () {
          ref.read(enableChoiceSoundProvider.notifier).save(enable: true);
        },
        icon: const Icon(Icons.volume_off),
      ),
    );
  }

  Widget _enableChoiceButton(WidgetRef ref) {
    return SizedBox.square(
      dimension: 48,
      child: IconButton.filled(
        onPressed: () {
          ref.read(enableChoiceSoundProvider.notifier).save(enable: false);
        },
        icon: const Icon(Icons.volume_up),
      ),
    );
  }

  Widget? _progress(QuizMasterState? state) {
    final current = state?.currentQuestion;
    if (state == null || current == null || state.questionCount <= 0) {
      return null;
    }
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: current.count / state.questionCount,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${current.count} / ${state.questionCount}',
          style: const TextStyle(fontSize: 16),
        )
      ],
    );
  }
}

class _SampleButton extends HookConsumerWidget {
  const _SampleButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const size = 128.0;

    ref.watch(soundPlayerProvider());
    final master = ref.watch(quizMasterProvider).valueOrNull;

    Future<void> notesOn() async {
      final synth = await ref.read(synthesizerProvider.future);
      master?.currentQuestion?.question.toNotes().let((notes) {
        synth.notesOn(notes, sound.Velocity.max());
      });
    }

    Future<void> notesOff() async {
      final synth = await ref.read(synthesizerProvider.future);
      master?.currentQuestion?.question.toNotes().let((notes) {
        synth.notesOff(notes);
      });
    }

    return Center(
      child: SizedBox.square(
        dimension: size,
        child: BorderButton(
          borderRadius: BorderRadius.circular(size / 2),
          onTapDown: (_) => notesOn(),
          onTapUp: (_) => notesOff(),
          onTapCancel: () => notesOff(),
          child: const Center(
            child: Icon(Icons.music_note),
          ),
        ),
      ),
    );
  }
}

class _ChoiceButton extends HookConsumerWidget {
  final QuizEntry entry;

  const _ChoiceButton(this.entry);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(_choiceProvider);

    return BorderButton(
      enableBorder: selected == entry,
      onTapUp: (_) async {
        ref.read(_choiceProvider.notifier).choice(entry);

        if (ref.read(enableChoiceSoundProvider)) {
          final synth = await ref.read(synthesizerProvider.future);
          synth.notesOff(entry.toNotes());
        }
      },
      onTapDown: (_) async {
        if (ref.read(enableChoiceSoundProvider)) {
          final synth = await ref.read(synthesizerProvider.future);
          synth.notesOn(entry.toNotes(), sound.Velocity.max());
        }
      },
      onTapCancel: () async {
        if (ref.read(enableChoiceSoundProvider)) {
          final synth = await ref.read(synthesizerProvider.future);
          synth.notesOff(entry.toNotes());
        }
      },
      child: Center(
        child: Text(
          entry.when(
            note: (note) => note.name(),
            chord: (chord) => chord.toString(),
          ),
        ),
      ),
    );
  }
}
