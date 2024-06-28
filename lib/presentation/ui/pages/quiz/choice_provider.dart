import 'package:note_sound/domain/quiz/value/quiz_entry_target.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'choice_provider.g.dart';

@riverpod
class Choice extends _$Choice {
  @override
  QuizEntryTarget? build() {
    return null;
  }

  void choice(QuizEntryTarget entry) {
    state = entry;
  }

  void clear() {
    state = null;
  }
}
