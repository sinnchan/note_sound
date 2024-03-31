import 'package:collection/collection.dart';
import 'package:dart_melty_soundfont/dart_melty_soundfont.dart';
import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/services.dart';
import 'package:note_sound/domain/models/logger/logger.dart';
import 'package:note_sound/domain/models/note/note.dart';
import 'package:note_sound/domain/models/pcm/synthesizer/i_pcm_synthesizer.dart';
import 'package:note_sound/domain/models/pcm/value/pcm_sound_fonts.dart';
import 'package:note_sound/domain/models/pcm/value/pcm_velocity.dart';
import 'package:note_sound/gen/assets.gen.dart';

class PcmSynthesizer extends IPcmSynthesizer with ClassLogger {
  Synthesizer? _synthesizer;

  PcmSynthesizer(super.option);

  @override
  Future<void> init() async {
    logger.d('init()');
    logger.v(option.toJson());

    if (_synthesizer != null) {
      logger.w('already initialized.');
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
    logger.d('dispose()');
    _synthesizer?.reset();
    _synthesizer = null;
  }

  @override
  void noteOn(Note note, PcmVelocity velocity, [int channel = 0]) {
    logger.d('noteOn($note, $velocity, channel: $channel)');
    _synthesizer?.noteOn(
      channel: channel,
      key: note.number,
      velocity: velocity.value,
    );
    super.noteOn(note, velocity);
  }

  @override
  void noteOff(Note note, [int channel = 0]) {
    logger.d('noteOff()');
    _synthesizer?.noteOff(
      channel: channel,
      key: note.number,
    );
    super.noteOff(note);
  }

  @override
  void noteOffAll([int channel = 0]) {
    logger.d('noteOffAll()');
    _synthesizer?.noteOffAll(channel: channel);
    super.noteOffAll();
  }

  final bufferPool = <ArrayInt16>{};

  @override
  ByteData render([int? sampleCount]) {
    logger.d('render(sampleCount: $sampleCount)');

    var buffer = bufferPool.firstWhereOrNull((e) {
      return e.bytes.lengthInBytes == sampleCount;
    });
    buffer ??= ArrayInt16.zeros(
      numShorts: sampleCount ?? option.bufferSize.size,
    ).also(bufferPool.add);

    _synthesizer?.renderMonoInt16(buffer);

    return buffer.bytes;
  }

  Future<ByteData> getSoundFontData(PcmSoundFont sf) async {
    logger.d('getSoundFontData(sf: ${sf.name})');

    return rootBundle.load(
      switch (sf) {
        PcmSoundFont.korgIS50Marimboyd1115 =>
          Assets.soundFonts.korgIS50Marimboyd1115,
      },
    );
  }
}
