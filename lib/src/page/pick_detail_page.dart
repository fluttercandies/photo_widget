import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_widget/src/widget/detail_widget.dart';

class PickDetailPage extends StatelessWidget {
  final int? initIndex;
  final AssetPathEntity? path;

  const PickDetailPage({
    Key? key,
    this.path,
    this.initIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PathDetailWidget(
            path: path,
            initIndex: initIndex,
          ),
        ],
      ),
    );
  }
}

class OnlyPickDetailPage extends StatelessWidget {
  final int? initIndex;

  const OnlyPickDetailPage({
    Key? key,
    this.initIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
