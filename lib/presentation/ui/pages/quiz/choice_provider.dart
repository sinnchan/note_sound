import 'package:note_sound/domain/quiz/value/quiz_entry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'choice_provider.g.dart';

@riverpod
class Choice extends _$Choice {
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
