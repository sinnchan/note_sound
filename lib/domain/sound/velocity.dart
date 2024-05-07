import 'package:freezed_annotation/freezed_annotation.dart';

part 'velocity.freezed.dart';
part 'velocity.g.dart';

@freezed
class Velocity with _$Velocity {
  static const int maxValue = 127;
  static const int minValue = 0;

  @Assert('Velocity.minValue <= value && value <= Velocity.maxValue')
  const factory Velocity({
    required int value,
  }) = _Velocity;

  static Velocity max() {
    return const Velocity(value: maxValue);
  }

  factory Velocity.fromJson(Map<String, Object?> json) =>
      _$VelocityFromJson(json);
}
