import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_sound/domain/models/pcm/value/pcm_block_size.dart';
import 'package:note_sound/domain/models/pcm/value/pcm_buffer_size.dart';
import 'package:note_sound/domain/models/pcm/value/pcm_sample_rate.dart';
import 'package:note_sound/domain/models/pcm/value/pcm_sound_fonts.dart';

part 'pcm_synthesizer_options.freezed.dart';
part 'pcm_synthesizer_options.g.dart';

@freezed
class PcmSynthesizerOption with _$PcmSynthesizerOption {
  const factory PcmSynthesizerOption({
    required PcmSoundFont sf,
    @Default(PcmSampleRate()) PcmSampleRate sampleRate,
    @Default(PcmBlockSize()) PcmBlockSize blockSize,
    @Default(PcmBufferSize(size: 2048)) PcmBufferSize bufferSize,
  }) = _PcmSynthesizerOption;

  factory PcmSynthesizerOption.fromJson(Map<String, Object?> json) =>
      _$PcmSynthesizerOptionFromJson(json);
}
