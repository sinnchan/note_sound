import 'package:freezed_annotation/freezed_annotation.dart';

part 'pcm_buffer_size.freezed.dart';
part 'pcm_buffer_size.g.dart';

@freezed
class PcmBufferSize with _$PcmBufferSize {
  @Assert('0 < size')
  const factory PcmBufferSize({
    required int size,
  }) = _PcmBufferSize;

  factory PcmBufferSize.fromJson(Map<String, Object?> json) =>
      _$PcmBufferSizeFromJson(json);
}
