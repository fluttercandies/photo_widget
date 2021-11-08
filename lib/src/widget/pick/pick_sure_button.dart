import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../photo_provider.dart';

typedef void PickSureCallback(List<AssetEntity> picked);

typedef Widget PickSureTextBuilder(
    BuildContext context, List<AssetEntity> picked, int max);

class PickSureButton extends StatelessWidget {
  final PickerDataProvider provider;
  final PickSureCallback? onTap;
  final PickSureTextBuilder? builder;
  final double radius;
  final Color disableColor;
  final Color color;
  final TextStyle textStyle;
  final TextStyle disableTextStyle;
  final String defaultText;
  final EdgeInsetsGeometry padding;

  const PickSureButton({
    Key? key,
    required this.provider,
    this.onTap,
    this.builder,
    this.radius = 3,
    this.defaultText = "发送",
    this.disableColor = const Color(0xFF434343),
    this.color = Colors.blue,
    this.textStyle = const TextStyle(fontSize: 14, color: Colors.white),
    this.disableTextStyle = const TextStyle(
      fontSize: 14,
      color: const Color(0xFF696969),
    ),
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  }) : super(key: key);

  List<AssetEntity> get picked => provider.picked;

  @override
  Widget build(BuildContext context) {
    final disableStyle = this.disableTextStyle;
    return AnimatedBuilder(
      animation: provider.pickedNotifier,
      builder: (_, __) {
        if (builder != null) {
          return InkWell(
            child: builder!(context, picked, provider.maxNotifier.value),
            onTap: () => onTap?.call(picked),
          );
        }
        if (picked.isEmpty) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Container(
              padding: padding,
              color: disableColor,
              child: Text(
                '$defaultText',
                style: disableStyle,
              ),
            ),
          );
        } else {
          return ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Material(
              color: color,
              child: InkWell(
                onTap: () => onTap?.call(picked),
                child: Container(
                  padding: padding,
                  child: Text(
                    '$defaultText(${picked.length}/${provider.maxNotifier.value})',
                    style: textStyle,
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
