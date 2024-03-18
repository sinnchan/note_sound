import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_sound/domain/models/pcm/value/pcm_sample_rate.dart';

part 'pcm_player_options.freezed.dart';
part 'pcm_player_options.g.dart';

@freezed
class PcmPlayerOption with _$PcmPlayerOption {
  const factory PcmPlayerOption({
    @Default(PcmSampleRate()) PcmSampleRate sampleRate,
  }) = _PcmPlayerOption;

  factory PcmPlayerOption.fromJson(Map<String, Object?> json) =>
      _$PcmPlayerOptionFromJson(json);
}
