import 'package:flutter/material.dart';

class ProgressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      widthFactor: 0.3,
      heightFactor: 0.3,
      child: CircularProgressIndicator(),
    );
  }
}
