import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'asset_widget.dart';

class PickedDetailWidget extends StatefulWidget {
  final List<AssetEntity> entityList;

  const PickedDetailWidget({
    Key key,
    @required this.entityList,
    int initIndex = 0,
  }) : super(key: key);

  @override
  _PickedDetailWidgetState createState() => _PickedDetailWidgetState();
}

class _PickedDetailWidgetState extends State<PickedDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: _buildItem,
      itemCount: widget.entityList.length,
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return Image(
      image: AssetEntityFileImage(
        widget.entityList[index],
      ),
    );
  }
}

class PathDetailWidget extends StatefulWidget {
  final AssetPathEntity path;
  final int initIndex;

  const PathDetailWidget({
    Key key,
    @required this.path,
    this.initIndex = 0,
  }) : super(key: key);

  @override
  _PathDetailWidgetState createState() => _PathDetailWidgetState();
}

class _PathDetailWidgetState extends State<PathDetailWidget> {
  PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(
      initialPage: widget.initIndex ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: _buildItem,
      itemCount: widget.path.assetCount,
      controller: controller,
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final size = MediaQuery.of(context).size;
    return Image(
      image: PathItemImageProvider(
        index: index,
        path: widget.path,
        width: size.width,
        height: size.height,
      ),
    );
  }
}
