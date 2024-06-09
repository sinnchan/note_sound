import 'dart:convert';

import 'package:note_sound/domain/logger/logger.dart';
import 'package:note_sound/domain/quiz/value/quiz_master_state.dart';
import 'package:note_sound/infrastructure/shared_preference/shared_preference_keys.dart';
import 'package:note_sound/infrastructure/util/extensions/provider_ext.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'quiz_master_state_repository.g.dart';

@riverpod
Future<QuizMasterStateRepository> quizMasterStateRepository(
  QuizMasterStateRepositoryRef ref,
) async {
  return QuizMasterStateRepository(await ref.prefs);
}

class QuizMasterStateRepository with CLogger {
  final SharedPreferences prefs;

  QuizMasterStateRepository(this.prefs);

  Future<QuizMasterState?> load() async {
    final json = prefs.getString(PrefsKeys.quizMasterState);

    if (json == null) {
      return null;
    }

    try {
      return QuizMasterState.fromJson(jsonDecode(json));
    } catch (e, st) {
      logger.w('failed to json decode: $json', e, st);
      return null;
    }
  }

  Future<void> save(QuizMasterState state) {
    return prefs.setString(
      PrefsKeys.quizMasterState,
      jsonEncode(state.toJson()),
    );
  }

  Future<void> clear() {
    return prefs.remove(PrefsKeys.quizMasterState);
  }
}
