import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'generator.g.dart';

@riverpod
UuidGenerator uuidGenerator(UuidGeneratorRef ref) {
  return const UuidGenerator();
}

class UuidGenerator {
  const UuidGenerator();

  final uuid = const Uuid();

  String v4() {
    return uuid.v4();
  }
}
