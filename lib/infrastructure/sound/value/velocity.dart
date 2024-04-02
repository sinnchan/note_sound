import 'package:freezed_annotation/freezed_annotation.dart';

part 'velocity.freezed.dart';
part 'velocity.g.dart';

const int _maxVelocity = 127;
const int _minVelocity = 0;

@freezed
class Velocity with _$Velocity {
  @Assert('_minVelocity <= value && value <= _maxVelocity')
  const factory Velocity({
    required int value,
  }) = _Velocity;

  factory Velocity.fromJson(Map<String, Object?> json) =>
      _$VelocityFromJson(json);
}
