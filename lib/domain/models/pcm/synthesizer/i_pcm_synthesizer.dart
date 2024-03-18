import 'dart:typed_data';

import 'package:note_sound/domain/models/note/note.dart';
import 'package:note_sound/domain/models/pcm/synthesizer/pcm_synthesizer_options.dart';
import 'package:note_sound/domain/models/pcm/value/pcm_velocity.dart';

abstract class IPcmSynthesizer {
  final PcmSynthesizerOption option;

  IPcmSynthesizer(this.option);

  Future<void> init();
  Future<void> dispose();

  void noteOn(Note note, PcmVelocity velocity);
  void noteOff(Note note);

  ByteData render(int sampleCount);
}
