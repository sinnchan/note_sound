import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:note_sound/flutter/widgets/expandable/expandable_notifier_builder.dart';

class ExpandableCard extends StatelessWidget {
  const ExpandableCard({
    super.key,
    required this.title,
    this.collapsed = const SizedBox.shrink(),
    required this.expanded,
    this.animationDuration = const Duration(milliseconds: 300),
    this.radius = 8,
  });

  final String title;
  final Widget collapsed;
  final Widget expanded;
  final Duration animationDuration;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return DividerTheme(
      data: DividerTheme.of(context).copyWith(space: 1),
      child: ExpandableTheme(
        data: ExpandableThemeData(
          animationDuration: animationDuration,
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          inkWellBorderRadius: BorderRadius.vertical(
            top: Radius.circular(radius),
          ),
        ),
        child: ExpandableNotifierBuilder(
          builder: (context, controller) {
            return ScrollOnExpand(
              child: Card(
                clipBehavior: Clip.hardEdge,
                child: Column(
                  children: [
                    ExpandablePanel(
                      header: Padding(
                        padding: EdgeInsets.all(radius + (radius / 2)),
                        child: Text(
                          title,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      collapsed: collapsed,
                      expanded: Column(
                        children: [
                          const Divider(),
                          expanded,
                        ],
                      ),
                    ),
                    const Divider(),
                    SizedBox(height: radius + 4),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
