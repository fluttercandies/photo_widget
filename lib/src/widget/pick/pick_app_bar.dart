import 'package:flutter/material.dart';
import '../../photo_provider.dart';
import '../current_path_selector.dart';
import 'pick_sure_button.dart';

class PickAppBar extends StatefulWidget with PreferredSizeWidget {
  final double height;
  final Color backgroundColor;
  final Color iconColor;
  final Function? onTapClick;
  final Widget? leading;
  final PickerDataProvider provider;

  PickAppBar({
    Key? key,
    required this.provider,
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
  final key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      color: widget.backgroundColor,
      child: SafeArea(
        top: true,
        bottom: false,
        left: false,
        right: false,
        child: Container(
          height: widget.height,
          padding: const EdgeInsetsDirectional.only(end: 10),
          child: Row(
            children: <Widget>[
              buildLeading(),
              _buildPhotoPick(context),
              Expanded(
                child: Container(),
              ),
              buildSureButton(),
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
          onPressed: widget.onTapClick as void Function()?,
        );
  }

  Widget _buildPhotoPick(BuildContext context) {
    return Container(
      height: 30,
      child: SelectedPathDropdownButton(
        dropdownRelativeKey: key,
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
