import 'package:freezed_annotation/freezed_annotation.dart';

part 'block_size.freezed.dart';
part 'block_size.g.dart';

@freezed
class BlockSize with _$BlockSize {
  @Assert('0 <= value && value <= 1024')
  const factory BlockSize({
    @Default(64) int value,
  }) = _BlockSize;

  factory BlockSize.fromJson(Map<String, Object?> json) =>
      _$BlockSizeFromJson(json);
}
