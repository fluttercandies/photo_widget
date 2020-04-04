import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

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
      builder: (_, __) => DropDownWrapper(child: buildButton()),
    );
  }

  Widget buildButton() {
    final decoration = BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(35),
    );
    if (provider.current == null) {
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
              provider.current.name,
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
        RenderBox box = context.findRenderObject();
        final offset = box.localToGlobal(Offset.zero);
        final offsetY = offset.dy + box.paintBounds.height;
        print(offsetY);
        // print(offset);
      },
    );
  }
}
