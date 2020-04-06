import 'package:flutter/material.dart';
import '../photo_provider.dart';
import 'dropdown_gallery_picker.dart';
import 'pick_sure_button.dart';

class PickAppBar extends StatefulWidget with PreferredSizeWidget {
  final double height;
  final Color backgroundColor;
  final Color iconColor;
  final Function onTapClick;
  final Widget leading;
  final PickerDataProvider provider;

  PickAppBar({
    Key key,
    @required this.provider,
    this.height = kToolbarHeight,
    this.backgroundColor = const Color(0xFF333333),
    this.iconColor = Colors.white,
    this.onTapClick,
    this.leading,
  }) : super(key: key);

  @override
  _PickAppBarState createState() => _PickAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _PickAppBarState extends State<PickAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: SafeArea(
        top: true,
        bottom: false,
        left: false,
        right: false,
        child: Container(
          height: widget.height,
          child: Row(
            children: <Widget>[
              buildLeading(),
              _buildPhotoPick(context),
              Expanded(
                child: Container(),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 10),
                child: buildSureButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLeading() {
    return widget.leading ??
        IconButton(
          color: Colors.white,
          icon: Icon(
            Icons.close,
          ),
          onPressed: widget.onTapClick,
        );
  }

  Widget _buildPhotoPick(BuildContext context) {
    return Container(
      height: 30,
      child: SelectedPathDropdownButton(
        provider: widget.provider,
      ),
    );
  }

  Widget buildSureButton() {
    return PickSureButton(
      provider: widget.provider,
    );
  }
}
