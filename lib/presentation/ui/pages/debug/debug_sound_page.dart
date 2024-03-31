import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_sound/domain/models/logger/logger.dart';
import 'package:note_sound/domain/models/note/note.dart';
import 'package:note_sound/domain/models/pcm/value/pcm_velocity.dart';
import 'package:note_sound/presentation/shared_providers/pcm_player_provider.dart';
import 'package:note_sound/presentation/shared_providers/pcm_synthesizer_provider.dart';
import 'package:note_sound/presentation/util/l10n_mixin.dart';

class DebugSoundPlayerPage extends HookConsumerWidget with ClassLogger {
  DebugSoundPlayerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(pcmPlayerProvider);
    final isPlaying = useMemoized(
      () => player.value?.isPlaying ?? false,
      [player.value?.isPlaying],
    );

    useEffect(
      () {
        player.whenOrNull(data: (player) => player.play());
        return null;
      },
      [player],
    );

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
                    onPressed: player.mapOrNull(
                      data: (player) => !isPlaying ? player.value.play : null,
                      error: (e) {
                        logger.e(e.error);
                        return null;
                      },
                    ),
                    child: const Text('PLAY'),
                  ),
                  ElevatedButton(
                    onPressed: player.mapOrNull(
                      data: (player) => isPlaying ? player.value.play : null,
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
                    const PcmVelocity(value: 127),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget synthKey(WidgetRef ref, Note note, PcmVelocity velocity) {
    final synth = ref.read(pcmSynthesizerProvider);

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
