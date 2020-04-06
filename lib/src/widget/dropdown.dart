import 'dart:async';

import 'package:flutter/material.dart';

typedef Widget DropdownWidgetBuilder<T>(
    BuildContext context, ValueSetter<T> close);

class FeatureController<T> {
  final Completer<T> completer;

  final ValueSetter<T> close;

  FeatureController(this.completer, this.close);

  Future<T> get closed => completer.future;
}

FeatureController<T> showDropDown<T>({
  @required BuildContext context,
  DropdownWidgetBuilder<T> builder,
  double height,
}) {
  final completer = Completer<T>();
  var isReply = false;
  OverlayEntry entry;
  void close(T value) {
    if (isReply) {
      return;
    }
    isReply = true;

    completer.complete(value);
    entry?.remove();
  }

  entry = OverlayEntry(builder: (context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Builder(
        builder: (ctx) => GestureDetector(
          onTap: () {
            close(null);
          },
          child: Container(
            height: height,
            width: double.infinity,
            child: builder(ctx, close),
          ),
        ),
      ),
    );
  });
  Overlay.of(context).insert(entry);
  return FeatureController(
    completer,
    close,
  );
}

class DropDown<T> extends StatefulWidget {
  final Widget child;
  final DropdownWidgetBuilder<T> dropdownWidgetBuilder;
  final ValueChanged<T> onResult;
  final ValueChanged<bool> onShow;

  const DropDown({
    Key key,
    @required this.child,
    @required this.dropdownWidgetBuilder,
    this.onResult,
    this.onShow,
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
        widget.onShow?.call(true);
        final controller = showDropDown<T>(
          context: context,
          height: dialogHeight,
          builder: (_, close) {
            return widget.dropdownWidgetBuilder?.call(context, close);
          },
        );
        final result = await controller.closed;
        widget.onResult(result);
        widget.onShow?.call(false);
      },
    );
  }
}
