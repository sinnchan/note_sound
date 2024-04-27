import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_sound/domain/logger/logger.dart';
import 'package:note_sound/domain/quiz/quiz_master.dart';
import 'package:note_sound/presentation/route/router.dart';
import 'package:note_sound/presentation/util/l10n_mixin.dart';

class DebugTopPage extends HookConsumerWidget with ClassLogger {
  DebugTopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final master = ref.watch(quizMasterProvider().notifier);
    final state = ref.watch(quizMasterProvider()).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.debug_page),
      ),
      body: ListView(
        children: [
          _divider(),
          _button(
            text: context.l10n.sound_player,
            onTap: () => DebugSoundPlayerRoute().go(context),
          ),
          _divider(),
          _button(
            text: context.l10n.pitch_traning,
            onTap: () => DebugPitchTraningRoute().go(context),
          ),
          _divider(),
          _button(
            text: context.l10n.chord_traning,
            onTap: null,
          ),
          _divider(),
          Text(state?.quizIndex.toString() ?? 'start'),
          _divider(),
          _button(
            text: 'add',
            onTap: () => master.setEntries(QuizMaster.createRandomNoteEntries(
              count: 10,
              isEnabledShuffle: true,
            )),
          ),
          _divider(),
          _button(
            text: 'start',
            onTap: master.start,
          ),
          _divider(),
          _button(
            text: 'get',
            onTap: master.getQuestion,
          ),
          _divider(),
          _button(
            text: 'next',
            onTap: () => master.skip(),
          ),
          _divider(),
          _button(
            text: 'reset',
            onTap: () => master.reset(),
          ),
        ],
      ),
    );
  }

  Widget _button({
    required String text,
    required void Function()? onTap,
  }) {
    return Material(
      color: onTap == null
          ? Theme.of(useContext()).disabledColor.withOpacity(0.2)
          : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text),
              const Icon(Icons.navigate_next),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return const Divider(height: 1);
  }
}
