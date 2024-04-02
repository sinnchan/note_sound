import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_sound/infrastructure/sound/value/block_size.dart';
import 'package:note_sound/infrastructure/sound/value/buffer_size.dart';
import 'package:note_sound/infrastructure/sound/value/sample_rate.dart';
import 'package:note_sound/infrastructure/sound/value/sound_fonts.dart';

part 'synthesizer_options.freezed.dart';
part 'synthesizer_options.g.dart';

@freezed
class SynthesizerOption with _$SynthesizerOption {
  const factory SynthesizerOption({
    required SoundFonts sf,
    @Default(SampleRate()) SampleRate sampleRate,
    @Default(BlockSize()) BlockSize blockSize,
    @Default(BufferSize(size: 2048)) BufferSize bufferSize,
  }) = _SynthesizerOption;

  factory SynthesizerOption.fromJson(Map<String, Object?> json) =>
      _$SynthesizerOptionFromJson(json);
}
