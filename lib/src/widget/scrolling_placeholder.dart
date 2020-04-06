import 'package:flutter/material.dart';

class ScrollingPlaceholder extends StatelessWidget {
  const ScrollingPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF4A4748),
    );
    // return Center(
    //   widthFactor: 0.25,
    //   heightFactor: 0.25,
    //   child: FlutterLogo(),
    // );
  }
}
