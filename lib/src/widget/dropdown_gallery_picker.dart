import 'dart:async';

import 'package:flutter/material.dart';
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
      animation: provider,
      builder: (_, __) => DropDownWrapper(
        child: buildButton(),
        dropdownWidgetBuilder: (BuildContext context) =>
            ChangeCurrentPathDropdown(
          provider: provider,
        ),
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

class DropDownWrapper extends StatefulWidget {
  final Widget child;
  final WidgetBuilder dropdownWidgetBuilder;

  const DropDownWrapper({
    Key key,
    @required this.child,
    @required this.dropdownWidgetBuilder,
  }) : super(key: key);
  @override
  _DropDownWrapperState createState() => _DropDownWrapperState();
}

class _DropDownWrapperState extends State<DropDownWrapper> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child,
      onTap: () {
        final height = MediaQuery.of(context).size.height;
        RenderBox box = context.findRenderObject();
        final offsetStart = box.localToGlobal(Offset.zero);
        final dialogHeight = height - (offsetStart.dy + box.paintBounds.bottom);
        _showDropDown(
          context: context,
          height: dialogHeight,
          builder: (_) {
            return widget.dropdownWidgetBuilder?.call(context);
          },
        );
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

class ChangeCurrentPathDropdown extends StatefulWidget {
  final PickerDataProvider provider;

  const ChangeCurrentPathDropdown({
    Key key,
    @required this.provider,
  }) : super(key: key);

  @override
  _ChangeCurrentPathDropdownState createState() =>
      _ChangeCurrentPathDropdownState();
}

class _ChangeCurrentPathDropdownState extends State<ChangeCurrentPathDropdown> {
  PickerDataProvider get provider => widget.provider;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: provider.pathList.length,
        itemBuilder: _buildItem,
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final item = provider.pathList[index];
    return Container(
      height: 80,
      child: Row(
        children: <Widget>[
          FutureBuilder(
            future: item.getAssetListRange(start: 0, end: 1),
            builder: (c, data) {
              if (!data.hasData) {
                return Container();
              }
              return AspectRatio(
                aspectRatio: 1,
                child: Image(
                  image: AssetEntityThumbImage(
                    entity: data.data[0],
                    width: 80,
                    height: 80,
                  ),
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
          Text(item.name),
        ],
      ),
    );
  }
}
