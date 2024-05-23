import 'package:flutter_test/flutter_test.dart';
import 'package:note_sound/domain/lesson/provider.dart';

void main() {
  test('data parse test', () async {
    final hoge = ChordFinder.find(['CEG']);
    expect(hoge, 'C');
  });
}
