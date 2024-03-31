import 'package:freezed_annotation/freezed_annotation.dart';

part 'pcm_block_size.freezed.dart';
part 'pcm_block_size.g.dart';

@freezed
class PcmBlockSize with _$PcmBlockSize {
  @Assert('0 <= value && value <= 1024')
  const factory PcmBlockSize({
    @Default(64) int value,
  }) = _PcmBlockSize;

  factory PcmBlockSize.fromJson(Map<String, Object?> json) =>
      _$PcmBlockSizeFromJson(json);
}
