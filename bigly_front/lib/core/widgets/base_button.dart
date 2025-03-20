
import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  const BaseButton({
    super.key,
    required this.onPressed,
    this.color = Colors.white,
    this.child,
    this.height,
    this.padding,
    this.width,
    this.border = true,
    this.childText
  });
  final void Function() onPressed;
  final Widget? child;
  final String? childText;
  final Color color;
  final double? height;
  final bool border;
  final double? width;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        // width: width ?? 100,
        // height: height ?? 35,
        width: width,
        height: height,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: border ?
          Border.all(color: Colors.black,width: 1.3) :
          const Border()
        ),
        clipBehavior: Clip.hardEdge,
        child: Center(child: child ?? const SizedBox()),
      ),
    );
  }
}
