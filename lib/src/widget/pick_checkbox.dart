import 'package:flutter/material.dart';

/// If [checkIndex] is -1 , then it not be checked
typedef Widget PickedCheckboxBuilder(BuildContext context, int checkIndex);

class PickedCheckbox extends StatelessWidget {
  final int checkIndex;
  final VoidCallback onClick;
  final AlignmentGeometry alignment;
  final double radius;
  final Color pickedColor;
  final Color unpickColor;
  final Color textColor;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final double size;

  const PickedCheckbox({
    Key key,
    @required this.checkIndex,
    @required this.onClick,
    this.alignment = Alignment.topRight,
    this.radius = 30,
    this.pickedColor = Colors.blue,
    this.unpickColor = Colors.white,
    this.textColor = Colors.white,
    this.fontSize = 12,
    this.padding = const EdgeInsets.all(8.0),
    this.size = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final checked = checkIndex != -1;
    final checkText = !checked ? "" : (checkIndex + 1).toString();
    final borderRadius = BorderRadius.circular(radius);
    final decoration = !checked
        ? BoxDecoration(
            border: Border.all(
              width: 1,
              color: unpickColor,
            ),
            borderRadius: borderRadius,
          )
        : BoxDecoration(
            color: pickedColor,
            borderRadius: borderRadius,
          );
    return Align(
      alignment: alignment,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          onClick?.call();
        },
        child: Padding(
          padding: padding,
          child: Container(
            width: size,
            height: size,
            decoration: decoration,
            child: Center(
              child: Text(
                checkText,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
