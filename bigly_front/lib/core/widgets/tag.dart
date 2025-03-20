
import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  const Tag({super.key,
    this.onTap,
    required this.text,
    this.textStyle,
  });

  final String text;
  final TextStyle? textStyle;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 3,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 10
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          text,
          style: textStyle ?? TextStyle(
            fontSize: 12,
            color: Colors.grey.shade800
          ),
        ),
      ),
    );
  }
}
