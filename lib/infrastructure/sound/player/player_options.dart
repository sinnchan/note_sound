import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_sound/infrastructure/sound/synthesizer/synthesizer_options.dart';
import 'package:note_sound/infrastructure/sound/value/buffer_size.dart';
import 'package:note_sound/infrastructure/sound/value/sample_rate.dart';

part 'player_options.freezed.dart';
part 'player_options.g.dart';

@freezed
class SoundPlayerOption with _$SoundPlayerOption {
  const factory SoundPlayerOption({
    @Default(SampleRate()) SampleRate sampleRate,
    @Default(defaultBufferSize) BufferSize bufferSize,
  }) = _SoundPlayerOption;

  factory SoundPlayerOption.fromJson(Map<String, Object?> json) =>
      _$SoundPlayerOptionFromJson(json);
}
