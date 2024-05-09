import 'package:flutter/material.dart';
import 'package:note_sound/presentation/util/context_extensions.dart';

class BorderButton extends StatelessWidget {
  const BorderButton({
    super.key,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.enableBorder = true,
    this.padding = const EdgeInsets.all(12),
    this.child,
  });

  final BorderRadius borderRadius;
  final void Function(TapDownDetails)? onTapDown;
  final void Function(TapUpDetails)? onTapUp;
  final void Function()? onTapCancel;
  final bool enableBorder;
  final EdgeInsets padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.05),
        borderRadius: borderRadius,
        border: Border.all(
          color: enableBorder ? primaryColor : primaryColor.withOpacity(0.2),
        ),
      ),
      child: InkWell(
        borderRadius: borderRadius,
        splashColor: primaryColor.withOpacity(0.3),
        highlightColor: primaryColor.withOpacity(0.2),
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        onTapCancel: onTapCancel,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
