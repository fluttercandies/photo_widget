import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_widget/src/widget/asset_widget.dart';

import '../photo_provider.dart';

class DropDownGalleryPicker extends StatelessWidget {
  final PhotoDataProvider provider;

  final Color backgroundColor;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;

  const DropDownGalleryPicker({
    Key key,
    this.provider,
    this.backgroundColor = const Color(0xFF4C4C4C),
    this.textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 14,
    ),
    this.padding = const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: provider.currentPathNotifier,
      builder: (_, __) => DropDown<AssetPathEntity>(
        child: buildButton(),
        dropdownWidgetBuilder: (BuildContext context) =>
            ChangeCurrentPathWidget(
          provider: provider,
        ),
        onResult: (AssetPathEntity value) {
          provider.currentPath = value;
        },
      ),
    );
  }

  Widget buildButton() {
    final decoration = BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(35),
    );
    if (provider.currentPath == null) {
      return Container(
        padding: padding,
        decoration: decoration,
      );
    } else {
      return Container(
        padding: padding,
        decoration: decoration,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              provider.currentPath.name,
              style: textStyle,
            ),
            Container(
              width: 5,
            ),
            CircleAvatar(
              radius: 12,
              backgroundColor: const Color(0xFFB2B2B2),
              child: Icon(
                Icons.arrow_drop_down,
                color: const Color(0xFF232323),
              ),
            ),
          ],
        ),
      );
    }
  }
}

class DropDown<T> extends StatefulWidget {
  final Widget child;
  final WidgetBuilder dropdownWidgetBuilder;
  final ValueChanged<T> onResult;

  const DropDown({
    Key key,
    @required this.child,
    @required this.dropdownWidgetBuilder,
    this.onResult,
  }) : super(key: key);
  @override
  _DropDownState<T> createState() => _DropDownState<T>();
}

class _DropDownState<T> extends State<DropDown<T>> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child,
      onTap: () async {
        final height = MediaQuery.of(context).size.height;
        RenderBox box = context.findRenderObject();
        final offsetStart = box.localToGlobal(Offset.zero);
        final dialogHeight = height - (offsetStart.dy + box.paintBounds.bottom);
        final result = await _showDropDown<T>(
          context: context,
          height: dialogHeight,
          builder: (_) {
            return widget.dropdownWidgetBuilder?.call(context);
          },
        );
        widget.onResult(result);
      },
    );
  }
}

Future<T> _showDropDown<T>({
  @required BuildContext context,
  WidgetBuilder builder,
  double height,
  T testResult,
}) {
  final completer = Completer<T>();
  var isReply = false;
  OverlayEntry entry;
  entry = OverlayEntry(builder: (context) {
    return NotificationListener<DismissNotification<T>>(
      onNotification: (notification) {
        if (isReply) {
          return false;
        }
        isReply = true;

        completer.complete(notification.result);
        entry.remove();
        return true;
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Builder(
          builder: (ctx) => GestureDetector(
            onTap: () {
              DismissNotification(testResult).dispatch(null);
            },
            child: Container(
              height: height,
              width: double.infinity,
              child: builder(ctx),
            ),
          ),
        ),
      ),
    );
  });
  Overlay.of(context).insert(entry);
  return completer.future;
}

class DismissNotification<T> extends Notification {
  final T result;

  DismissNotification(this.result);
}

class ChangeCurrentPathWidget extends StatefulWidget {
  final PickerDataProvider provider;

  const ChangeCurrentPathWidget({
    Key key,
    @required this.provider,
  }) : super(key: key);

  @override
  _ChangeCurrentPathWidgetState createState() =>
      _ChangeCurrentPathWidgetState();
}

class _ChangeCurrentPathWidgetState extends State<ChangeCurrentPathWidget> {
  PickerDataProvider get provider => widget.provider;

  static const itemHeight = 65.0;
  ScrollController controller;

  @override
  void initState() {
    super.initState();
    final index = provider.pathList.indexOf(provider.currentPath);
    controller = ScrollController(initialScrollOffset: itemHeight * index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      body: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView.builder(
          controller: controller,
          itemCount: provider.pathList.length,
          itemBuilder: _buildItem,
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final item = provider.pathList[index];
    const height = 65.0;
    final w = Container(
      height: height,
      child: Row(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: FutureBuilder(
              future: item.getAssetListRange(start: 0, end: 1),
              builder: (c, data) {
                if (!data.hasData) {
                  return Container();
                }
                return Image(
                  image: AssetEntityThumbImage(
                    entity: data.data[0],
                    width: 120,
                    height: 120,
                  ),
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              item.name,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Text(
            "(${item.assetCount})",
            style: TextStyle(color: const Color(0xFF717171), fontSize: 16),
          ),
          Expanded(child: Container()),
          _buildCheckFlagWidget(item),
        ],
      ),
    );
    return GestureDetector(
      child: w,
      behavior: HitTestBehavior.opaque,
      onTap: () {
        DismissNotification(item).dispatch(context);
      },
    );
  }

  Widget _buildCheckFlagWidget(AssetPathEntity item) {
    if (widget.provider.currentPath != item) {
      return Container();
    }
    return AspectRatio(
      aspectRatio: 1,
      child: Icon(
        Icons.check,
        color: Colors.white,
      ),
    );
  }
}
