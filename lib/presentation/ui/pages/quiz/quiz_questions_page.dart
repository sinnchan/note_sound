import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_sound/domain/quiz/entities/quiz_master.dart';
import 'package:note_sound/domain/quiz/value/quiz_entry.dart';
import 'package:note_sound/domain/quiz/value/quiz_master_values.dart';
import 'package:note_sound/domain/sound/note.dart';
import 'package:note_sound/presentation/util/context_extensions.dart';
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

class QuizQuestionsPage extends HookConsumerWidget {
  final QuizType type;
  final _borderRadius = BorderRadius.circular(12);

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
                _sampleButton(context),
                Container(
                  padding: const EdgeInsets.all(12),
                  alignment: Alignment.centerRight,
                  child: Column(
                    children: [
                      SizedBox.square(
                        dimension: 48,
                        child: Placeholder(),
                      ),
                      SizedBox.square(
                        dimension: 48,
                        child: Placeholder(),
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
                        if ((await master.answer(choice)).isCorrect) {
                          choiceNotifier.clear();
                        } else {}
                      }
                    : null,
                child: Text('決定'),
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

  Widget _sampleButton(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: 128,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            side: BorderSide(color: context.theme.colorScheme.primary),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: _borderRadius,
            ),
            child: const Center(
              child: Icon(Icons.music_note),
            ),
          ),
        ),
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

class _ChoiceButton extends HookConsumerWidget {
  final QuizEntry entry;

  const _ChoiceButton(this.entry);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(_choiceProvider);

    return ElevatedButton(
      onPressed: () {
        ref.read(_choiceProvider.notifier).choice(entry);
      },
      style: ElevatedButton.styleFrom(
        side: selected == entry
            ? BorderSide(color: context.theme.colorScheme.primary)
            : BorderSide(color: Colors.transparent),
      ),
      child: Text(
        entry.when(
          note: (note) => note.name(),
          chord: (chord) => chord.toString(),
        ),
      ),
    );
  }
}
