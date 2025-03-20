
import 'package:flutter/material.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';

class MainButton extends StatelessWidget {
  const MainButton({super.key,
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
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.child,
  });

  final void Function()? onPressed;
  final String? text;
  final Widget? icon;
  final ButtonIconAlignment iconAlignment;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final String? subText;
  final TextStyle? subTextStyle;
  final BorderRadiusGeometry? borderRadius;
  final double? borderWidth;
  final Color? borderColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {

    Widget? childInside = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text ?? '',
          style: textStyle ?? const TextStyle(
            color: Colors.white,
          ),
        ),
        if (subText != null)
          Text(
            subText!,
            style: subTextStyle ?? const TextStyle(
              fontSize: 8,
              color: Colors.white,
            ),
          ),
      ],
    );

    if ((child != null) && ((text != null) || (subText != null) || (icon != null))) {
      throw Exception('If you use child you cannot use text, subText and icon');
    }

    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(backgroundColor),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              side: BorderSide(
                color: borderColor ?? Colors.transparent,
                width: borderWidth ?? 1,
              ),
              borderRadius: borderRadius ?? BorderRadius.circular(10),
            ),
          ),
        ),

        child :
        (child != null) ?
        child! :
        (iconAlignment == ButtonIconAlignment.left) ?
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? const SizedBox.shrink(),
            childInside,
            if (icon != null)
              5.wGap,
          ],
        ) :
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              5.wGap,
            childInside,
            icon ?? const SizedBox.shrink(),
          ],
        ) ,
      ),
    );
  }
}

enum ButtonIconAlignment {
  left,
  right
}