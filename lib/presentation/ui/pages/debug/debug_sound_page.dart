import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_sound/domain/logger/logger.dart';
import 'package:note_sound/domain/sound/note.dart';
import 'package:note_sound/infrastructure/sound/player/player.dart';
import 'package:note_sound/infrastructure/sound/synthesizer/synthesizer.dart';
import 'package:note_sound/domain/sound/velocity.dart' as sound;
import 'package:note_sound/presentation/util/l10n_mixin.dart';

class DebugSoundPlayerPage extends HookConsumerWidget with ClassLogger {
  DebugSoundPlayerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerProvider = soundPlayerProvider();
    final player = ref.watch(playerProvider.notifier);
    final playerState = ref.watch(playerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.select_notes),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: playerState.mapOrNull(
                      data: (s) => s.value.isPlaying ? null : player.play,
                      error: (e) {
                        logger.e(e.error);
                        return null;
                      },
                    ),
                    child: const Text('PLAY'),
                  ),
                  ElevatedButton(
                    onPressed: playerState.mapOrNull(
                      data: (s) => s.value.isPlaying ? player.pause : null,
                      error: (e) {
                        logger.e(e.error);
                        return null;
                      },
                    ),
                    child: const Text('PAUSE'),
                  )
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                ),
                itemCount: 128,
                itemBuilder: (context, index) {
                  return synthKey(
                    ref,
                    Note(number: index),
                    const sound.Velocity(value: 127),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget synthKey(WidgetRef ref, Note note, sound.Velocity velocity) {
    final synth = ref.read(synthesizerProvider);

    return Material(
      color: note.isBlackKey ? Colors.black.withOpacity(0.5) : null,
      child: InkWell(
        onTapDown: (_) => synth.mapOrNull(
          data: (synth) => synth.value.noteOn(note, velocity),
        ),
        onTapUp: (_) => synth.mapOrNull(
          data: (synth) => synth.value.noteOff(note),
        ),
        onTapCancel: () => synth.mapOrNull(
          data: (synth) => synth.value.noteOff(note),
        ),
        child: Center(
          child: Text(note.fullName()),
        ),
      ),
    );
  }
}
