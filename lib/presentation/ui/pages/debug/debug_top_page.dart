import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_sound/presentation/route/router.dart';
import 'package:note_sound/presentation/util/l10n_mixin.dart';

class DebugTopPage extends HookConsumerWidget {
  const DebugTopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.debug_page),
      ),
      body: ListView(
        children: [
          _divider(),
          _button(
            text: context.l10n.sound_player,
            onTap: () => DebugSoundPlayerRoute().go(context),
          ),
          _divider(),
          _button(
            text: context.l10n.pitch_traning,
            onTap: () => DebugPitchTraningRoute().go(context),
          ),
          _divider(),
          _button(
            text: context.l10n.chord_traning,
            onTap: null,
          ),
          _divider(),
        ],
      ),
    );
  }

  Widget _button({
    required String text,
    required void Function()? onTap,
  }) {
    return Material(
      color: onTap == null
          ? Theme.of(useContext()).disabledColor.withOpacity(0.2)
          : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
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

  Widget _divider() {
    return const Divider(height: 1);
  }
}
