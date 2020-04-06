import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_widget/src/widget/asset_widget.dart';

import '../photo_provider.dart';
import 'dropdown.dart';

class SelectedPathDropdownButton extends StatelessWidget {
  final PhotoDataProvider provider;

  final Color backgroundColor;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final WidgetBuilder buttonBuilder;
  final DropdownWidgetBuilder<AssetPathEntity> dropdownBuilder;
  final ValueChanged<AssetPathEntity> onChanged;

  const SelectedPathDropdownButton({
    Key key,
    this.provider,
    this.backgroundColor = const Color(0xFF4C4C4C),
    this.buttonBuilder,
    this.dropdownBuilder,
    this.textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 14,
    ),
    this.padding = const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arrowDownNotifier = ValueNotifier(false);
    return AnimatedBuilder(
      animation: provider.currentPathNotifier,
      builder: (_, __) => DropDown<AssetPathEntity>(
        child: (buttonBuilder ??
            (context) => buildButton(context, arrowDownNotifier))(context),
        dropdownWidgetBuilder: dropdownBuilder ??
            (BuildContext context, close) {
              return ChangePathWidget(
                provider: provider,
                close: close,
              );
            },
        onResult: (AssetPathEntity value) {
          if (onChanged == null) {
            if (value != null) {
              provider.currentPath = value;
            }
          } else {
            onChanged(value);
          }
        },
        onShow: (value) {
          arrowDownNotifier.value = value;
        },
      ),
    );
  }

  Widget buildButton(
    BuildContext context,
    ValueNotifier<bool> arrowDownNotifier,
  ) {
    if (provider.pathList.isEmpty || provider.currentPath == null) {
      return Container();
    }

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
              child: AnimatedBuilder(
                child: Icon(
                  Icons.arrow_drop_down,
                  color: const Color(0xFF232323),
                ),
                animation: arrowDownNotifier,
                builder: (BuildContext context, Widget child) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    // transform: Matrix4.translationValues(1, 1, 0)
                    //   ..rotateZ(pi * sqrt),
                    child: child,
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}

class ChangePathWidget extends StatefulWidget {
  final PickerDataProvider provider;
  final IndexedWidgetBuilder itemBuilder;
  final double itemHeight;
  final ValueSetter<AssetPathEntity> close;

  const ChangePathWidget({
    Key key,
    @required this.provider,
    @required this.close,
    this.itemBuilder,
    this.itemHeight = 65,
  }) : super(key: key);

  @override
  _ChangePathWidgetState createState() => _ChangePathWidgetState();
}

class _ChangePathWidgetState extends State<ChangePathWidget> {
  PickerDataProvider get provider => widget.provider;

  ScrollController controller;

  @override
  void initState() {
    super.initState();
    final index = provider.pathList.indexOf(provider.currentPath);
    controller =
        ScrollController(initialScrollOffset: widget.itemHeight * index);
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
          itemBuilder: widget.itemBuilder ?? _buildItem,
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final item = provider.pathList[index];
    Widget w = Container(
      height: widget.itemHeight,
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
    w = Stack(
      children: <Widget>[
        w,
        Positioned(
          height: 1,
          bottom: 0,
          right: 0,
          left: widget.itemHeight + 10,
          child: IgnorePointer(
            child: Container(
              color: const Color(0xFF484848),
            ),
          ),
        ),
      ],
    );
    return GestureDetector(
      child: w,
      behavior: HitTestBehavior.translucent,
      onTap: () {
        widget?.close?.call(item);
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
