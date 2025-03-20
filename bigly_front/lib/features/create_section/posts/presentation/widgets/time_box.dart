import 'package:flutter/cupertino.dart';
import '../../../../../constants/constants.dart';

class TimeBox extends StatelessWidget {
  final bool radiusTop;
  final String title;
  final Widget child;
  const TimeBox({super.key, this.radiusTop=false, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 40,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radiusTop?
          const BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)):
          const BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
          color: opacitiyWhite,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Column(
            children: [
              Text(title,style: const TextStyle(color: CupertinoColors.black,fontSize: 9),),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
