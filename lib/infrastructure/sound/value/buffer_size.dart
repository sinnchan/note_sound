import 'package:freezed_annotation/freezed_annotation.dart';

part 'buffer_size.freezed.dart';
part 'buffer_size.g.dart';

@freezed
class BufferSize with _$BufferSize {
  @Assert('0 < size')
  const factory BufferSize({
    required int size,
  }) = _BufferSize;

  factory BufferSize.fromJson(Map<String, Object?> json) =>
      _$BufferSizeFromJson(json);
}
