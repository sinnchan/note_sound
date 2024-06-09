import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_sound/domain/quiz/value/quiz_entry.dart';
import 'package:note_sound/infrastructure/logger/logger_impl.dart';

part 'quiz_master_state.freezed.dart';
part 'quiz_master_state.g.dart';

typedef QuizMasterStateId = String;

final _logger = CustomLogger('QuizMasterStateExt');

@freezed
class QuizMasterState with _$QuizMasterState {
  const factory QuizMasterState({
    required QuizMasterStateId id,
    required List<QuizEntry> entries,
    required int quizIndex,
  }) = _QuizMasterState;

  factory QuizMasterState.fromJson(Map<String, Object?> json) =>
      _$QuizMasterStateFromJson(json);
}

extension QuizMasterStateExt on QuizMasterState {
  QuizEntry? get currentQuiz {
    try {
      return entries[quizIndex];
    } catch (e, st) {
      _logger.w('failed to get current quiz...', e, st);
      return null;
    }
  }
}
