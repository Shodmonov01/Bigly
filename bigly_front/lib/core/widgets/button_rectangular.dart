
import 'package:flutter/material.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';

import 'main_button.dart';

class ButtonRectangular extends StatelessWidget {
  const ButtonRectangular({super.key,
    required this.onPressed,
    this.text,
    this.icon,
    this.iconAlignment = ButtonIconAlignment.left,
    this.height,
    this.width,
    this.backgroundColor,
    this.textStyle,
    this.subText,
    this.subTextStyle,
    this.child,
  });

  final void Function() onPressed;
  final String? text;
  final Widget? icon;
  final ButtonIconAlignment iconAlignment;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final String? subText;
  final TextStyle? subTextStyle;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return MainButton(
      onPressed: onPressed,
      text: text,
      icon: icon,
      iconAlignment: iconAlignment,
      height: height ?? 35,
      width: width,
      backgroundColor: backgroundColor,
      textStyle: textStyle,
      subText: subText,
      subTextStyle: subTextStyle,
      borderRadius: BorderRadius.circular(10),
      child: child,
    );
  }
}
