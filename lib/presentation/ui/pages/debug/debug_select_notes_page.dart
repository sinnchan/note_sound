import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_sound/domain/logger/logger.dart';
import 'package:note_sound/domain/sound/note.dart';
import 'package:note_sound/infrastructure/quiz/quiz_target_repository.dart';
import 'package:note_sound/presentation/util/l10n_mixin.dart';

part 'debug_select_notes_page.freezed.dart';
part 'debug_select_notes_page.g.dart';

@freezed
class DebugSelectNotesTab with _$DebugSelectNotesTab {
  const factory DebugSelectNotesTab({
    required String tabName,
    required List<Note> notes,
  }) = _DebugSelectNotesTab;

  factory DebugSelectNotesTab.fromJson(Map<String, Object?> json) =>
      _$DebugSelectNotesTabFromJson(json);
}

class DebugSelectNotesPage extends HookConsumerWidget with CLogger {
  DebugSelectNotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = _getTabs();
    final tabController = useTabController(
      initialLength: tabs.length,
      initialIndex: 5,
    );
    final futureRepository = ref.watch(quizTargetRepositoryProvider.future);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.select_notes),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(46 * 2),
          child: Column(
            children: [
              SizedBox(
                height: 46,
                child: _allButtons(futureRepository),
              ),
              TabBar(
                controller: tabController,
                isScrollable: true,
                tabs: tabs.map((e) => Tab(text: e.tabName)).toList(),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: tabs.map((e) {
          return ListView.separated(
            itemCount: e.notes.length,
            separatorBuilder: (context, i) {
              return const Divider(indent: 12);
            },
            itemBuilder: (context, i) {
              return _ListItem(e.notes[i]);
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _allButtons(Future<QuizTargetRepository> futureRepository) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () async {
            (await futureRepository).saveTargetAllNote(true);
          },
          child: const Text('All ON'),
        ),
        ElevatedButton(
          onPressed: () async {
            (await futureRepository).saveTargetAllNote(false);
          },
          child: const Text('All OFF'),
        ),
      ],
    );
  }

  List<DebugSelectNotesTab> _getTabs() {
    final noteMap = groupBy(
      List.generate(Note.max + 1, (i) => i),
      (p) => (p / 12).floor(),
    );

    final tabs = noteMap.entries.map((e) {
      return DebugSelectNotesTab(
        tabName: (e.key - 1).toString(),
        notes: e.value.map((e) => Note(number: e)).toList(),
      );
    }).toList();

    return tabs;
  }
}

class _ListItem extends HookConsumerWidget with CLogger {
  final Note note;

  _ListItem(this.note);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();
    final repository = ref.watch(quizTargetRepositoryProvider).valueOrNull;
    final isSelected = useState(false);
    useEffect(
      () => repository
          ?.isTargetNote(note.number)
          .listen((isTarget) => isSelected.value = isTarget)
          .cancel,
      [repository, note],
    );

    return SizedBox(
      height: 42,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(note.name()),
              Checkbox(
                value: isSelected.value,
                tristate: true,
                onChanged: (_) {
                  switch (isSelected.value) {
                    case true:
                      repository?.clearTargetNote(note.number);
                    case false:
                      repository?.saveTargetNote(note.number);
                    default:
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
