import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'asset_widget.dart';
import 'scrolling_placeholder.dart';

typedef Widget AssetPathWidgetBuilder(
    BuildContext context, AssetPathEntity path);

typedef void OnAssetItemClick(BuildContext context, AssetEntity entity,int index);

class AssetPathWidget extends StatefulWidget {
  final AssetPathEntity path;
  final AssetWidgetBuilder buildItem;
  final int rowCount;
  final int thumbSize;
  final Widget scrollingWidget;
  final double itemRatio;
  final bool loadWhenScrolling;
  final double dividerWidth;
  final Color dividerColor;
  final OnAssetItemClick onAssetItemClick;

  const AssetPathWidget({
    Key key,
    @required this.path,
    this.buildItem = AssetWidget.buildWidget,
    this.rowCount = 4,
    this.thumbSize = 100,
    this.scrollingWidget = const ScrollingPlaceholder(),
    this.itemRatio = 1,
    this.dividerWidth = 1,
    this.dividerColor = const Color(0xFF313434),
    this.onAssetItemClick,
    this.loadWhenScrolling = false,
  }) : super(key: key);

  @override
  _AssetPathWidgetState createState() => _AssetPathWidgetState();
}

class _AssetPathWidgetState extends State<AssetPathWidget> {
  static Map<int, AssetEntity> _createMap() {
    return {};
  }

  final cacheMap = _createMap();

  final scrolling = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onScroll,
      child: Container(
        color: widget.dividerColor,
        child: GridView.builder(
          key: ValueKey(widget.path),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.rowCount,
            crossAxisSpacing: widget.dividerWidth,
            mainAxisSpacing: widget.dividerWidth,
          ),
          itemBuilder: (context, index) => _buildItem(context, index),
          itemCount: widget.path?.assetCount ?? 0,
          addRepaintBoundaries: true,
        ),
      ),
    );
  }

  Widget _buildScrollItem(BuildContext context, int index) {
    final asset = cacheMap[index];
    if (asset != null) {
      return widget.buildItem(context, asset, widget.thumbSize);
    } else {
      return FutureBuilder<List<AssetEntity>>(
        future: widget.path.getAssetListRange(start: index, end: index + 1),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData || snapshot.data.isEmpty) {
            return widget.scrollingWidget;
          }
          final asset = snapshot.data[0];
          cacheMap[index] = asset;
          return widget.buildItem(context, asset, widget.thumbSize);
        },
      );
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    if (widget.loadWhenScrolling) {
      return GestureDetector(
        onTap: () async {
          var asset = cacheMap[index];
          if (asset == null) {
            asset = (await widget.path
                .getAssetListRange(start: index, end: index + 1))[0];
            cacheMap[index] = asset;
          }
          widget.onAssetItemClick?.call(context, asset,index);
        },
        child: _buildScrollItem(context, index),
      );
    }
    return GestureDetector(
      onTap: () async {
        var asset = cacheMap[index];
        if (asset == null) {
          asset = (await widget.path
              .getAssetListRange(start: index, end: index + 1))[0];
          cacheMap[index] = asset;
        }
        widget.onAssetItemClick?.call(context, asset,index);
      },
      child: _WrapItem(
        cacheMap: cacheMap,
        path: widget.path,
        index: index,
        onLoaded: (AssetEntity entity) {
          cacheMap[index] = entity;
        },
        buildItem: widget.buildItem,
        loaded: cacheMap.containsKey(index),
        thumbSize: widget.thumbSize,
        valueNotifier: scrolling,
        scrollingPlaceHolder: widget.scrollingWidget,
        entity: cacheMap[index],
      ),
    );
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      scrolling.value = false;
    } else if (notification is ScrollStartNotification) {
      scrolling.value = true;
    }
    return false;
  }

  @override
  void didUpdateWidget(AssetPathWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      cacheMap.clear();
      scrolling.value = false;
      if (mounted) {
        setState(() {});
      }
    }
  }
}

class _WrapItem extends StatefulWidget {
  final AssetPathEntity path;
  final int index;
  final void Function(AssetEntity entity) onLoaded;
  final ValueNotifier<bool> valueNotifier;
  final bool loaded;
  final AssetWidgetBuilder buildItem;
  final int thumbSize;
  final Widget scrollingPlaceHolder;
  final AssetEntity entity;
  final Map<int, AssetEntity> cacheMap;
  const _WrapItem({
    Key key,
    @required this.path,
    @required this.index,
    @required this.onLoaded,
    @required this.valueNotifier,
    @required this.loaded,
    @required this.buildItem,
    @required this.thumbSize,
    @required this.scrollingPlaceHolder,
    @required this.entity,
    this.cacheMap,
  }) : super(key: key);

  @override
  __WrapItemState createState() => __WrapItemState();
}

class __WrapItemState extends State<_WrapItem> {
  bool get scrolling => widget.valueNotifier.value;

  bool _loaded = false;

  bool get loaded => _loaded || widget.loaded;
  AssetEntity assetEntity;

  @override
  void initState() {
    super.initState();
    assetEntity = widget.cacheMap[widget.index];
    widget.valueNotifier.addListener(onChange);
    if (!scrolling) {
      _load();
    }
  }

  void onChange() {
    if (assetEntity != null) {
      return;
    }
    if (loaded) {
      return;
    }
    if (scrolling) {
      return;
    }
    _load();
  }

  @override
  void dispose() {
    widget.valueNotifier.removeListener(onChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (assetEntity == null) {
      return widget.scrollingPlaceHolder;
    }
    return widget.buildItem(context, assetEntity, widget.thumbSize);
  }

  Future<void> _load() async {
    final list = await widget.path
        .getAssetListRange(start: widget.index, end: widget.index + 1);
    if (list != null && list.isNotEmpty) {
      final asset = list[0];
      _loaded = true;
      widget.onLoaded(asset);
      assetEntity = asset;
      if (mounted) {
        setState(() {});
      }
    }
  }
}
