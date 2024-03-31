import 'package:freezed_annotation/freezed_annotation.dart';

part 'pcm_sample_rate.freezed.dart';
part 'pcm_sample_rate.g.dart';

@freezed
class PcmSampleRate with _$PcmSampleRate {
  @Assert('16000 <= value && value <= 192000')
  const factory PcmSampleRate([
    @Default(44100) int value,
  ]) = _PcmSampleRate;

  factory PcmSampleRate.fromJson(Map<String, Object?> json) =>
      _$PcmSampleRateFromJson(json);
}
