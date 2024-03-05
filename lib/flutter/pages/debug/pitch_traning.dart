import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:note_sound/flutter/util/l10n_mixin.dart';
import 'package:note_sound/flutter/widgets/expandable/expandable_card.dart';

class DebugPitchTraningPage extends HookWidget {
  const DebugPitchTraningPage({super.key});

  final padding = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.pitch_traning),
      ),
      body: DividerTheme(
        data: DividerTheme.of(context).copyWith(space: 1),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            ExpandableCard(
              title: context.l10n.quiz_mode,
              expanded: Column(
                children: [
                  nextPageButton(
                    text: context.l10n.select_notes,
                    onTap: () {},
                  ),
                  Divider(indent: padding),
                  input(
                    text: context.l10n.quiz_count,
                    initValue: '',
                    onChanged: (value) {},
                  ),
                  const Divider(),
                  startButton(() {}),
                ],
              ),
            ),
            ExpandableCard(
              title: context.l10n.listening_mode,
              expanded: Column(
                children: [
                  nextPageButton(
                    text: context.l10n.select_notes,
                    onTap: () {},
                  ),
                  Divider(indent: padding),
                  input(
                    text: context.l10n.quiz_count,
                    initValue: '',
                    onChanged: (value) {},
                  ),
                  const Divider(),
                  startButton(() {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget input({
    required String text,
    required String initValue,
    required void Function(String) onChanged,
  }) {
    final controller = useTextEditingController(text: initValue);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: 16,
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text),
            SizedBox(
              width: 72,
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                ),
                onSubmitted: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget nextPageButton({
    required String text,
    required void Function()? onTap,
  }) {
    return Material(
      color: onTap == null
          ? Theme.of(useContext()).disabledColor.withOpacity(0.3)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text),
              const Icon(Icons.navigate_next),
            ],
          ),
        ),
      ),
    );
  }

  Widget startButton(void Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(useContext().l10n.start),
      ),
    );
  }
}
