import 'package:note_sound/domain/logger/logger.dart';
import 'package:note_sound/infrastructure/shared_preference/shared_preference.dart';
import 'package:note_sound/infrastructure/shared_preference/shared_preference_keys.dart';
import 'package:note_sound/infrastructure/util/extensions/provider_ext.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'quiz_info_repository.g.dart';

@riverpod
Future<QuizInfoRepository> quizInfoRepository(QuizInfoRepositoryRef ref) async {
  return QuizInfoRepository(await ref.prefs);
}

class QuizInfoRepository with CLogger {
  final SharedPreferences prefs;

  final _quizCountStream = BehaviorSubject<int>();

  QuizInfoRepository(this.prefs) {
    _quizCountStream.add(
      prefs.getInt(PrefsKeys.quizCount) ?? 0,
    );
  }

  Stream<int> get quizCountStream {
    logger.d('get quizCountStream');
    return _quizCountStream;
  }

  Future<void> setQuizCount(int count) async {
    logger.d('setQuizNoteCount($count)');

    final success = await prefs.setInt(PrefsKeys.quizCount, count);
    if (success) {
      _quizCountStream.add(count);
    }
  }

  Future<int> getQuizCount() async {
    return prefs.getInt(PrefsKeys.quizCount) ?? 0;
  }
}

@Riverpod(keepAlive: true)
class EnableChoiceSound extends _$EnableChoiceSound with CLogger {
  final _defaultValue = false;

  @override
  bool build() {
    load();
    return _defaultValue;
  }

  Future<void> save({required bool enable}) async {
    logger.d('set(enable: $enable)');

    final prefs = await ref.read(prefsProvider.future);
    await prefs.setBool(PrefsKeys.enableChoiceSound, enable);
    await load();
  }

  Future<bool> load() async {
    final prefs = await ref.read(prefsProvider.future);
    final value = prefs.getBool(PrefsKeys.enableChoiceSound) ?? _defaultValue;
    state = value;
    return value;
  }
}
