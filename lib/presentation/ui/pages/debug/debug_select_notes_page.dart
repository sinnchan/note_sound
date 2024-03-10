import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_sound/presentation/util/l10n_mixin.dart';
import 'package:note_sound/domain/models/note/note.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'debug_select_notes_page.freezed.dart';
part 'debug_select_notes_page.g.dart';

@freezed
class QuizNoteInfo with _$QuizNoteInfo {
  const factory QuizNoteInfo({
    required Note note,
    @Default(true) bool isSelected,
  }) = _QuizNoteInfo;

  factory QuizNoteInfo.fromJson(Map<String, Object?> json) =>
      _$QuizNoteInfoFromJson(json);
}

@freezed
class DebugSelectNotesTab with _$DebugSelectNotesTab {
  const factory DebugSelectNotesTab({
    required String tabName,
    required List<QuizNoteInfo> notes,
  }) = _DebugSelectNotesTab;

  factory DebugSelectNotesTab.fromJson(Map<String, Object?> json) =>
      _$DebugSelectNotesTabFromJson(json);
}

@riverpod
class SelectQuizNotesNotifier extends _$SelectQuizNotesNotifier {
  @override
  List<DebugSelectNotesTab> build() {
    throw 1;
  }
}

class DebugSelectNotesPage extends HookConsumerWidget {
  const DebugSelectNotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.select_notes),
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}
