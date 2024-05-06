import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
Random random(RandomRef ref) {
  return Random();
}
