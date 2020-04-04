import 'package:flutter/material.dart';

typedef Widget PickColorMaskBuilder(BuildContext context, bool picked);

class PickColorMask extends StatelessWidget {
  final Color maskColor;
  final bool picked;
  const PickColorMask({
    Key key,
    this.maskColor = const Color(0x99000000),
    @required this.picked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedContainer(
        width: double.infinity,
        height: double.infinity,
        color: picked ? maskColor : Colors.transparent,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  static PickColorMask buildWidget(BuildContext context, bool picked) {
    return PickColorMask(
      picked: picked,
    );
  }
}
