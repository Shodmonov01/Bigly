
import 'package:flutter/material.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/widgets/main_button.dart';

class ButtonCircular extends StatelessWidget {
  const ButtonCircular({super.key,
    required this.onPressed,
    this.height,
    this.width,
    required this.text,
    this.icon,
    this.iconAlignment = ButtonIconAlignment.right,
    this.backgroundColor,
    this.textStyle,
  });

  final void Function()? onPressed;
  final double? height;
  final double? width;
  final String text;
  final Widget? icon;
  final ButtonIconAlignment iconAlignment;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {

    return MainButton(
      onPressed: onPressed,
      height: height ?? 35,
      width: width,
      text: text,
      icon: icon,
      iconAlignment: iconAlignment,
      backgroundColor: backgroundColor,
      textStyle: textStyle,
      borderRadius: BorderRadius.circular(20),
    );
  }
}
