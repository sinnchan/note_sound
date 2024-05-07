import 'package:note_sound/domain/logger/logger.dart';
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

  final _quizNoteCountStream = BehaviorSubject<int>();

  QuizInfoRepository(this.prefs) {
    _quizNoteCountStream.add(
      prefs.getInt(PrefsKeys.quizNoteCount.name) ?? 0,
    );
  }

  Stream<int> get quizNoteCountStream {
    logger.d('get quizNoteCountStream');
    return _quizNoteCountStream;
  }

  Future<void> setQuizNoteCount(int count) async {
    logger.d('setQuizNoteCount($count)');

    final success = await prefs.setInt(PrefsKeys.quizNoteCount.name, count);
    if (success) {
      _quizNoteCountStream.add(count);
    }
  }

  Future<int> getQuizNoteCount() async {
    return prefs.getInt(PrefsKeys.quizNoteCount.name) ?? 0;
  }
}
