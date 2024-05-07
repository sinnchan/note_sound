import 'dart:convert';

import 'package:note_sound/domain/logger/logger.dart';
import 'package:note_sound/domain/quiz/entities/quiz_master.dart';
import 'package:note_sound/infrastructure/shared_preference/shared_preference_keys.dart';
import 'package:note_sound/infrastructure/util/extensions/provider_ext.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'quiz_master_repository.g.dart';

@riverpod
Future<QuizMasterRepository> quizMasterRepository(
  QuizMasterRepositoryRef ref,
) async {
  return QuizMasterRepository(await ref.prefs);
}

class QuizMasterRepository with CLogger {
  final SharedPreferences prefs;

  QuizMasterRepository(this.prefs);

  Future<QuizMasterState?> load() async {
    final json = prefs.getString(PrefsKeys.quizMasterState.name);

    if (json == null) {
      return null;
    }

    try {
      return QuizMasterState.fromJson(jsonDecode(json));
    } catch (e, st) {
      logger.w('failed to json decode: $json', error: e, stackTrace: st);
      return null;
    }
  }

  Future<void> save(QuizMasterState state) {
    return prefs.setString(
      PrefsKeys.quizMasterState.name,
      jsonEncode(state.toJson()),
    );
  }
}
