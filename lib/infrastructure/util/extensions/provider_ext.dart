import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:note_sound/infrastructure/db/isar.dart';

extension ProviderExt on AutoDisposeRef {
  Future<Isar> get isar => watch(isarProvider.future);
}
