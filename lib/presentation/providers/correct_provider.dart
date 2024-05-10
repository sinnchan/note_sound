import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef CorrectInfo = ({bool correct, int hash});

final correctProvider = StateProvider<CorrectInfo?>((ref) {
  return null;
});
