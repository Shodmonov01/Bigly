
import 'package:flutter/material.dart';

import '../../constants/app_icons.dart';
import 'button_circular.dart';
import 'button_rectangular.dart';

class SendAndAddButtonBar extends StatelessWidget {
  const SendAndAddButtonBar({super.key,
    required this.onPressed0,
    required this.onPressed1,
    required this.onPressed2,
    this.backgroundColor0,
    this.backgroundColor1,
    this.backgroundColor2,

  });

  final void Function() onPressed0;
  final void Function() onPressed1;
  final void Function() onPressed2;

  final Color? backgroundColor0;
  final Color? backgroundColor1;
  final Color? backgroundColor2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,),
      child: SizedBox(
        height: 65,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ButtonRectangular(
              onPressed: onPressed0,
              height: 40,
              backgroundColor: backgroundColor0 ?? Colors.orange,
              icon: Image.asset(
                height: 27,
                AppIcons.growUnselect,
              ),
              text: 'Send',
              subText: '(Subscribe)',
              textStyle: const TextStyle(color: Colors.black),
              subTextStyle: const TextStyle(fontSize: 8, color: Colors.black),
            ),
            ButtonRectangular(
              onPressed: onPressed1,
              height: 40,
              backgroundColor: backgroundColor1 ?? Colors.white,
              icon: Image.asset(
                height: 27,
                AppIcons.discoverUnselect,
              ),
              text: 'Send',
              subText: '(Free Followers)',
              textStyle: const TextStyle(color: Colors.black),
              subTextStyle: const TextStyle(fontSize: 8, color: Colors.black),
            ),
            ButtonCircular(
              onPressed: onPressed2,
              height: 40,
              backgroundColor: backgroundColor2 ?? Colors.white,
              icon: const Icon(Icons.arrow_right_alt, color: Colors.black,),
              text: 'Add',
              textStyle: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
