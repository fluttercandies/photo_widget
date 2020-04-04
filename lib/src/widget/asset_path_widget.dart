import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'asset_widget.dart';
import 'scrolling_placeholder.dart';

typedef Widget AssetPathWidgetBuilder(
    BuildContext context, AssetPathEntity path);

class AssetPathWidget extends StatefulWidget {
  final AssetPathEntity path;
  final AssetWidgetBuilder buildItem;
  final int rowCount;
  final int thumbSize;
  final Widget scrollingWidget;

  const AssetPathWidget({
    Key key,
    @required this.path,
    this.buildItem = AssetWidget.buildWidget,
    this.rowCount = 4,
    this.thumbSize = 100,
    this.scrollingWidget = const ScrollingPlaceholder(),
  }) : super(key: key);

  @override
  _AssetPathWidgetState createState() => _AssetPathWidgetState();
}

class _AssetPathWidgetState extends State<AssetPathWidget> {
  static Map<int, AssetEntity> _createMap() {
    return {};
    // return ObserverMap();
  }

  final cacheMap = _createMap();

  final scrolling = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onScroll,
      child: GridView.builder(
        key: ValueKey(widget.path),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.rowCount,
        ),
        itemBuilder: (context, index) => _buildItem(context, index),
        itemCount: widget.path.assetCount,
        addRepaintBoundaries: true,
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return _WrapItem(
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
    if (oldWidget.path.id != widget.path.id) {
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
