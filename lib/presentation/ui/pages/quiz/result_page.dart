import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_sound/domain/quiz/entities/quiz_master.dart';
import 'package:note_sound/domain/quiz/value/quiz_master_state.dart';
import 'package:note_sound/presentation/route/router.dart';
import 'package:note_sound/presentation/ui/widgets/buttons.dart';
import 'package:note_sound/presentation/util/list_extensions.dart';

class NoteQuizResultPage extends HookConsumerWidget {
  const NoteQuizResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.read(quizMasterProvider).valueOrNull;

    if (state == null) {
      return _stateErrWidget();
    }

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    '結果',
                    style: TextStyle(fontSize: 24),
                  ),
                  _ResultCountText(),
                ].withSeparater(const SizedBox(height: 16)),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!state.isAllCorrect)
                    const ElevatedButton(
                      onPressed: null,
                      child: Text('間違えた問題でもう一度'),
                    ),
                  if (state.isAllCorrect)
                    const ElevatedButton(
                      onPressed: null,
                      child: Text('次のコースへ'),
                    ),
                  const ElevatedButton(
                    onPressed: null,
                    child: Text('コース選択へ戻る'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      TopRoute().go(context);
                    },
                    child: const Text('トップに戻る'),
                  ),
                ].withSeparater(const SizedBox(height: 16)),
              ),
            ),
            const Flexible(
              flex: 1,
              child: SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Scaffold _stateErrWidget() {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('問題が発生しました。'),
            SizedBox(height: 24),
            BorderButton(child: Text('タイトルに戻る')),
          ],
        ),
      ),
    );
  }
}

class _ResultCountText extends HookConsumerWidget {
  const _ResultCountText();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      _getResutlText(ref),
      style: const TextStyle(fontSize: 24),
    );
  }

  String _getResutlText(WidgetRef ref) {
    final masterState = ref.read(quizMasterProvider).valueOrNull;

    String text;
    if (masterState != null) {
      final count = masterState.entries.where((e) => e.correct == true).length;
      final total = masterState.entries.length;
      text = '$count / $total';
    } else {
      text = 'No result..';
    }
    return text;
  }
}
