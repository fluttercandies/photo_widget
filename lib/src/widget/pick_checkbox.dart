import 'package:flutter/material.dart';

/// If [checkIndex] is -1 , then it not be checked
typedef Widget PickedCheckboxBuilder(BuildContext context, int checkIndex);

class PickedCheckbox extends StatelessWidget {
  final int checkIndex;
  final ValueChanged<bool> onChanged;
  const PickedCheckbox({
    Key key,
    this.checkIndex,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final checked = checkIndex != -1;
    final checkText = !checked ? "" : (checkIndex + 1).toString();
    final decoration = !checked
        ? BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          )
        : BoxDecoration(
            color: Colors.blue,
          );
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: () {
          onChanged?.call(!checked);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 20,
            height: 20,
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
