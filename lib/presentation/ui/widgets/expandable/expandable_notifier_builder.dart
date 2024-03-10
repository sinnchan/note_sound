import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class ExpandableNotifierBuilder extends StatelessWidget {
  const ExpandableNotifierBuilder({
    super.key,
    this.initialExpanded,
    this.controller,
    this.themeData,
    required this.builder,
  });

  final bool? initialExpanded;
  final ExpandableController? controller;
  final ExpandableThemeData? themeData;
  final Widget Function(BuildContext, ExpandableController) builder;

  @override
  Widget build(BuildContext context) {
    return ExpandableTheme(
      data: themeData ?? ExpandableThemeData.of(context),
      child: ExpandableNotifier(
        initialExpanded: initialExpanded,
        controller: controller,
        child: Builder(
          builder: (context) {
            return builder(
              context,
              ExpandableController.of(context)!,
            );
          },
        ),
      ),
    );
  }
}
