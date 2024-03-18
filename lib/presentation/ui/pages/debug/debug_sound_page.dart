import 'dart:math';

import 'package:dart_melty_soundfont/dart_melty_soundfont.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pcm_sound/flutter_pcm_sound.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_sound/domain/models/note/note.dart';
import 'package:note_sound/domain/models/pcm/value/pcm_velocity.dart';
import 'package:note_sound/gen/assets.gen.dart';
import 'package:note_sound/infrastructure/logger/logger.dart';
import 'package:note_sound/presentation/shared_providers/pcm_player_provider.dart';
import 'package:note_sound/presentation/shared_providers/synthesizer_provider.dart';
import 'package:note_sound/presentation/util/l10n_mixin.dart';

class DebugSoundPlayerPage extends HookConsumerWidget {
  DebugSoundPlayerPage({super.key});

  final _sfData = rootBundle.load(
    Assets.soundFonts.korgIS50Marimboyd1115,
  );
  late final _synth = _sfData.then(Synthesizer.loadByteData);

  Future<void> init() async {
    const bufferCount = 1000;
    final synth = await _synth;
    // synth.noteOn(channel: 0, key: 72, velocity: 120);

    await FlutterPcmSound.setup(sampleRate: 44100, channelCount: 1);
    await FlutterPcmSound.setFeedThreshold(bufferCount);
    final buffer = ArrayInt16.zeros(numShorts: bufferCount);
    synth.renderMonoInt16(buffer);
    await FlutterPcmSound.feed(PcmArrayInt16(bytes: buffer.bytes));

    FlutterPcmSound.setFeedCallback((remainingFrames) async {
      logger.d(remainingFrames);
      final buffer = ArrayInt16.zeros(
        numShorts: max(remainingFrames, bufferCount),
      );
      synth.renderMonoInt16(buffer);
      await FlutterPcmSound.feed(PcmArrayInt16(bytes: buffer.bytes));
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(pcmPlayerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.select_notes),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: init,
              child: const Text('INIT'),
            ),
            ElevatedButton(
              onPressed: player.mapOrNull(
                data: (player) => player.value.play,
              ),
              child: const Text('PLAY'),
            ),
            ElevatedButton(
              onPressed: player.mapOrNull(
                data: (player) => player.value.pause,
              ),
              child: const Text('PAUSE'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: ref.read(synthesizerProvider).mapOrNull(
                data: (synth) {
                  return () {
                    synth.value.noteOn(
                      const Note(number: 72),
                      const PcmVelocity(value: 120),
                    );
                  };
                },
              ),
              child: const Text('SOUND'),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: ref.read(synthesizerProvider).mapOrNull(
                data: (synth) {
                  return () {
                    synth.value.noteOn(
                      const Note(number: 74),
                      const PcmVelocity(value: 120),
                    );
                  };
                },
              ),
              child: const Text('SOUND'),
            ),
            ElevatedButton(
              onPressed: player.mapOrNull(
                data: (player) => player.value.dispose,
              ),
              child: const Text('RESET'),
            ),
          ],
        ),
      ),
    );
  }
}
