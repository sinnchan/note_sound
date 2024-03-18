import 'package:freezed_annotation/freezed_annotation.dart';

part 'pcm_velocity.freezed.dart';
part 'pcm_velocity.g.dart';

const int _maxVelocity = 127;
const int _minVelocity = 0;

@freezed
class PcmVelocity with _$PcmVelocity {
  @Assert('_minVelocity <= value && value <= _maxVelocity')
  const factory PcmVelocity({
    required int value,
  }) = _PcmVelocity;

  factory PcmVelocity.fromJson(Map<String, Object?> json) =>
      _$PcmVelocityFromJson(json);
}
