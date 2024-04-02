import 'package:freezed_annotation/freezed_annotation.dart';

part 'sample_rate.freezed.dart';
part 'sample_rate.g.dart';

@freezed
class SampleRate with _$SampleRate {
  @Assert('16000 <= value && value <= 192000')
  const factory SampleRate([
    @Default(44100) int value,
  ]) = _SampleRate;

  factory SampleRate.fromJson(Map<String, Object?> json) =>
      _$SampleRateFromJson(json);
}
