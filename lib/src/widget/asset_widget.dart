import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';


typedef Widget AssetWidgetBuilder(
  BuildContext context,
  AssetEntity path, {
  int thumbSize,
});

class AssetWidget extends StatefulWidget {
  final AssetEntity asset;
  final int thumbSize;

  const AssetWidget({
    Key key,
    @required this.asset,
    this.thumbSize = 100,
  }) : super(key: key);

  @override
  _AssetWidgetState createState() => _AssetWidgetState();

  static AssetWidget buildWidget(BuildContext context, AssetEntity asset,
      {int thumbSize = 100}) {
    return AssetWidget(
      asset: asset,
    );
  }
}

class _AssetWidgetState extends State<AssetWidget> {
  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetEntityThumbImage(
        entity: widget.asset,
        width: widget.thumbSize,
        height: widget.thumbSize,
      ),
      fit: BoxFit.cover,
    );
  }
}

class AssetEntityFileImage extends ImageProvider<AssetEntityFileImage> {
  final AssetEntity entity;
  final double scale;

  const AssetEntityFileImage(
    this.entity, {
    this.scale = 1.0,
  });

  @override
  ImageStreamCompleter load(AssetEntityFileImage key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
    );
  }

  Future<ui.Codec> _loadAsync(
      AssetEntityFileImage key, DecoderCallback decode) async {
    assert(key == this);
    final bytes = (await entity.file).readAsBytesSync();
    return decode(bytes);
  }

  @override
  Future<AssetEntityFileImage> obtainKey(
      ImageConfiguration configuration) async {
    return this;
  }
}

class AssetEntityThumbImage extends ImageProvider<AssetEntityThumbImage> {
  final AssetEntity entity;
  final int width;
  final int height;
  final double scale;

  AssetEntityThumbImage({
    @required this.entity,
    int width,
    int height,
    this.scale = 1.0,
  })  : width = width ?? entity.width,
        height = height ?? entity.height;

  @override
  ImageStreamCompleter load(AssetEntityThumbImage key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
    );
  }

  Future<ui.Codec> _loadAsync(
      AssetEntityThumbImage key, DecoderCallback decode) async {
    assert(key == this);
    final bytes = await entity.thumbDataWithSize(width, height);
    return decode(bytes);
  }

  @override
  Future<AssetEntityThumbImage> obtainKey(
      ImageConfiguration configuration) async {
    return this;
  }
}
