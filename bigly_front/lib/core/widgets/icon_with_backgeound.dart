
import 'package:flutter/material.dart';

class IconButtonWithBackground extends StatelessWidget {
  const IconButtonWithBackground({super.key,
    required this.height,
    required this.width,
    required this.icon,
    this.color,
    this.onTap,
    this.label,
    this.labelStyle,
    this.borderColor,
    this.borderWidth,
  });

  final double height;
  final double width;
  final Widget icon;
  final Color? color;
  final void Function()? onTap;
  final String? label;
  final TextStyle? labelStyle;
  final Color? borderColor;
  final double? borderWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              border:
              ((borderColor != null) || (borderWidth != null)) ?
              Border.all(
                color: borderColor ?? Colors.black,
                width: borderWidth ?? 1,
              ) : null,
              shape: BoxShape.circle,
              color: color ?? Colors.grey
            ),
            child: icon,
          ),
          if (label != null)
          const SizedBox(height: 5,),
          if (label != null)
          SizedBox(
            width: width,
            child: Text(
              label!,
              textAlign: TextAlign.center,
              style: labelStyle ??
              const TextStyle(),
            ),
          )
        ],
      ),
    );
  }
}
