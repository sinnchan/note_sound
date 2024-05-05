import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:note_sound/infrastructure/db/isar.dart';
import 'package:note_sound/infrastructure/shared_preference/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension ProviderExt on AutoDisposeRef {
  Future<Isar> get isar => watch(isarProvider.future);

  Future<SharedPreferences> get prefs => watch(prefsProvider.future);
}
