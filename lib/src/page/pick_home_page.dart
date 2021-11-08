import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_widget/src/theme/pick_theme.dart';
import 'package:photo_widget/src/widget/detail_widget.dart';

import '../photo_provider.dart';
import '../widget/asset_path_widget.dart';
import '../widget/pick/pick_app_bar.dart';
import '../widget/pick/pick_asset_widget.dart';
import 'pick_detail_page.dart';

typedef PreferredSizeWidget PickAppBarBuilder(BuildContext context);

class PhotoPickHomePage extends StatefulWidget {
  final PickAppBarBuilder? appBarBuilder;
  final WidgetBuilder? bottomBuilder;
  final PickerDataProvider provider;
  final int thumbSize;
  final PickTheme pickTheme;
  final Function? onTapPreview;

  const PhotoPickHomePage({
    Key? key,
    required this.provider,
    this.appBarBuilder,
    this.bottomBuilder,
    this.thumbSize = 100,
    this.pickTheme = const PickTheme(),
    this.onTapPreview,
  }) : super(key: key);

  @override
  _PhotoPickHomePageState createState() => _PhotoPickHomePageState();
}

class _PhotoPickHomePageState extends State<PhotoPickHomePage> {
  PickTheme get pickTheme => widget.pickTheme;

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
      final size = widget.appBarBuilder!(context).preferredSize;
      appbar = PreferredSize(
        preferredSize: size,
        child: Builder(
          builder: (BuildContext context) {
            return widget.appBarBuilder!(context);
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
    final bottomBar = widget.bottomBuilder?.call(context) ??
        _buildBottomBar(context, widget.provider);

    return Scaffold(
      appBar: appbar,
      body: AnimatedBuilder(
        animation: widget.provider.currentPathNotifier,
        builder: (BuildContext context, Widget? child) => AssetPathWidget(
          path: widget.provider.currentPath,
          buildItem: (ctx, asset, thumbSize) {
            return PickAssetWidget(
              asset: asset!,
              provider: widget.provider,
              thumbSize: thumbSize,
            );
          },
          onAssetItemClick: (ctx, asset, index) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PathDetailWidget(
                  path: widget.provider.currentPath,
                  initIndex: index,
                ),
              ),
            );
          },
          thumbSize: widget.thumbSize,
        ),
      ),
      bottomNavigationBar: bottomBar,
    );
  }

  Widget _buildBottomBar(BuildContext context, PickerDataProvider provider) {
    final originCheck = AnimatedBuilder(
      animation: provider.isOriginNotifier,
      builder: (ctx, __) {
        final theme = Theme.of(ctx).copyWith(
          disabledColor: pickTheme.textColor,
          unselectedWidgetColor: pickTheme.textColor,
        );
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            provider.isOrigin = !provider.isOrigin;
          },
          child: AbsorbPointer(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Theme(
                  data: theme,
                  child: Radio<bool>(
                    value: true,
                    groupValue: provider.isOrigin,
                    onChanged: (_) {},
                    activeColor: pickTheme.textColor,
                  ),
                ),
                Text(
                  "原图",
                  style: TextStyle(color: pickTheme.textColor),
                ),
              ],
            ),
          ),
        );
      },
    );
    final previewButton = AnimatedBuilder(
      animation: provider.pickedNotifier,
      builder: (_, __) {
        return FlatButton(
          disabledTextColor: pickTheme.disableColor,
          textColor: pickTheme.textColor,
          onPressed: provider.picked.isEmpty
              ? null
              : () {
                  if (widget.onTapPreview != null) {
                    widget.onTapPreview?.call();
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PickedDetailWidget(
                          entityList: provider.picked,
                        ),
                      ),
                    );
                  }
                },
          child: Text(
            '预览',
          ),
        );
      },
    );
    return Container(
      color: widget.pickTheme.backgroundColor,
      height: 50,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: previewButton,
          ),
          Center(
            child: originCheck,
          ),
        ],
      ),
    );
  }
}
