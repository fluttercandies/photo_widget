import 'package:flutter/material.dart';

class ScrollingPlaceholder extends StatelessWidget {
  const ScrollingPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Center(
      widthFactor: 0.25,
      heightFactor: 0.25,
      child: FlutterLogo(),
    );
  }
}
