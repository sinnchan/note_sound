import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

extension WidgetList on List<Widget> {
  List<Widget> withSeparater(Widget separater) {
    return mapIndexed((i, e) => i != length - 1 ? [e, separater] : [e])
        .expand((e) => e)
        .toList();
  }
}
