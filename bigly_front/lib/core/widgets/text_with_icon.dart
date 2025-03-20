
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextWithIcon extends StatelessWidget {
  const TextWithIcon({super.key,
    required this.text,
    required this.icon,
    required this.iconAlignment,
    this.textStyle,
    this.space,
    this.isExpandText = false,
    this.mainAxisAlignment,
  });

  final String text;
  final Widget icon;
  final TextsIconAlignment iconAlignment;
  final TextStyle? textStyle;
  final double? space;
  final bool isExpandText;
  final MainAxisAlignment? mainAxisAlignment;

  @override
  Widget build(BuildContext context) {

    Widget textWidget = Text(
      text, style: textStyle,
      // overflow: TextOverflow.clip,
      // softWrap: false,
    );

    switch (iconAlignment) {
      case TextsIconAlignment.left:
        return Row(
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(width: space ?? 0,),
            (isExpandText) ?
            Expanded(child: textWidget) :
            textWidget,
          ],
        );
      case TextsIconAlignment.right:
        return Row(
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
          children: [
            (isExpandText) ?
            Expanded(child: textWidget) :
            textWidget,
            SizedBox(width: space ?? 0,),
            icon,
          ],
        );
      case TextsIconAlignment.top:
        return Column(
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(height: space ?? 0,),
            (isExpandText) ?
            Expanded(child: textWidget) :
            textWidget,
          ],
        );
      case TextsIconAlignment.bottom:
        return Column(
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
          children: [
            (isExpandText) ?
            Expanded(child: textWidget) :
            textWidget,
            SizedBox(height: space ?? 0,),
            icon,
          ],
        );
    }
  }
}

enum TextsIconAlignment {
  top,
  bottom,
  left,
  right,
}
