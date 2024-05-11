import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'correct_provider.g.dart';

typedef CorrectInfo = ({bool correct, int hash});

@riverpod
class Correct extends _$Correct {
  @override
  CorrectInfo? build() {
    return null;
  }

  void set(CorrectInfo info) {
    state = info;
  }

  void clear() {
    state = null;
  }
}
