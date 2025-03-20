
import 'package:flutter/material.dart';

class CommonDialog extends StatelessWidget {
  const CommonDialog({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      alignment: Alignment.bottomCenter,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );;
  }
}
