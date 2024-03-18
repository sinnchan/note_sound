import 'package:dart_melty_soundfont/dart_melty_soundfont.dart';
import 'package:flutter/services.dart';
import 'package:note_sound/domain/models/note/note.dart';
import 'package:note_sound/domain/models/pcm/synthesizer/i_pcm_synthesizer.dart';
import 'package:note_sound/domain/models/pcm/value/pcm_sound_fonts.dart';
import 'package:note_sound/domain/models/pcm/value/pcm_velocity.dart';
import 'package:note_sound/gen/assets.gen.dart';
import 'package:note_sound/infrastructure/logger/logger.dart';

class PcmSynthesizer extends IPcmSynthesizer {
  Synthesizer? _synthesizer;

  PcmSynthesizer(super.option);

  @override
  Future<void> init() async {
    logger.d('$runtimeType.init()');
    if (_synthesizer != null) {
      logger.w('$runtimeType is initialized.');
      return;
    }

    final synthesizer = await getSoundFontData(option.sf).then((sfData) {
      return Synthesizer.loadByteData(
        sfData,
        SynthesizerSettings(
          sampleRate: option.sampleRate.value,
          blockSize: option.blockSize.value,
        ),
      );
    });

    _synthesizer = synthesizer;
  }

  @override
  Future<void> dispose() async {
    logger.d('$runtimeType.dispose()');
    _synthesizer?.reset();
    _synthesizer = null;
  }

  @override
  void noteOn(Note note, PcmVelocity velocity, [int channel = 0]) {
    logger.d('$runtimeType.noteOn()');
    _synthesizer?.noteOn(
      channel: channel,
      key: note.number,
      velocity: velocity.value,
    );
  }

  @override
  void noteOff(Note note, [int channel = 0]) {
    logger.d('$runtimeType.noteOff()');
    _synthesizer?.noteOff(
      channel: channel,
      key: note.number,
    );
  }

  @override
  ByteData render([int? sampleCount]) {
    logger.d('$runtimeType.render()');
    final buffer = ArrayInt16.zeros(
      numShorts: sampleCount ?? option.bufferSize.size,
    );

    _synthesizer?.renderInterleavedInt16(buffer);

    return buffer.bytes;
  }

  Future<ByteData> getSoundFontData(PcmSoundFont sf) async {
    return rootBundle.load(
      switch (sf) {
        PcmSoundFont.korgIS50Marimboyd1115 =>
          Assets.soundFonts.korgIS50Marimboyd1115,
      },
    );
  }
}
