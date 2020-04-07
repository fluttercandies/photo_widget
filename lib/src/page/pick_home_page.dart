import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../photo_provider.dart';
import '../widget/asset_path_widget.dart';
import '../widget/pick/pick_app_bar.dart';
import '../widget/pick/pick_asset_widget.dart';

typedef PreferredSizeWidget PickAppBarBuilder(BuildContext context);

class PhotoPickHomePage extends StatefulWidget {
  final PickAppBarBuilder appBarBuilder;

  final PickerDataProvider provider;

  final int thumbSize;

  const PhotoPickHomePage({
    Key key,
    @required this.provider,
    this.appBarBuilder,
    this.thumbSize = 100,
  }) : super(key: key);

  @override
  _PhotoPickHomePageState createState() => _PhotoPickHomePageState();
}

class _PhotoPickHomePageState extends State<PhotoPickHomePage> {
  @override
  void initState() {
    super.initState();
    if (widget.provider.pathList.isEmpty) {
      PhotoManager.getAssetPathList().then((value) {
        widget.provider.resetPathList(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget appbar;
    if (widget.appBarBuilder != null) {
      final size = widget.appBarBuilder(context).preferredSize;
      appbar = PreferredSize(
        preferredSize: size,
        child: Builder(
          builder: (BuildContext context) {
            return widget.appBarBuilder(context);
          },
        ),
      );
    } else {
      appbar = PickAppBar(
        onTapClick: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context, null);
          }
        },
        provider: widget.provider,
      );
    }
    return Scaffold(
      appBar: appbar,
      body: AnimatedBuilder(
        animation: widget.provider.currentPathNotifier,
        builder: (BuildContext context, Widget child) => AssetPathWidget(
          path: widget.provider.currentPath,
          buildItem: (ctx, asset, thumbSize) {
            return PickAssetWidget(
              asset: asset,
              provider: widget.provider,
              thumbSize: thumbSize,
            );
          },
          onAssetItemClick: (ctx, asset) {
            print(asset);
          },
          thumbSize: widget.thumbSize,
        ),
      ),
    );
  }
}
