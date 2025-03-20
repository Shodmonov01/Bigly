import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatBubble extends StatelessWidget {
  final bool isSender;
  final Color color;
  final Widget child;
  final bool padding;
  const ChatBubble({super.key, required this.isSender, required this.color, required this.child, required this.padding});

  @override
  Widget build(BuildContext context) {
    bool stateTick = false;
    Icon? stateIcon;
    if (false) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (false) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (false) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF92DEDA),
      );
    }
    return Align(
      alignment: isSender ? Alignment.topRight : Alignment.topLeft,
      child: SizedBox(
        child: CustomPaint(
          painter: SpecialChatBubbleThree(
            color: color,
            alignment: isSender ? Alignment.topRight : Alignment.topLeft,
            tail: true,
            borderColor: Colors.transparent, // specify your border color
            borderWidth: 2.0, // specify your border width
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * .7,
            ),
            margin: padding
                ? const EdgeInsets.symmetric(horizontal: 20, vertical: 7)
                : isSender
                ? stateTick
                ? const EdgeInsets.fromLTRB(0, 0, 14, 0)
                : const EdgeInsets.fromLTRB(0, 1, 7, 2)
                : const EdgeInsets.fromLTRB(7, 1, 0, 2),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: stateTick
                      ? const EdgeInsets.only(left: 4, right: 20)
                      : const EdgeInsets.only(left: 4, right: 4),
                  child: child,
                ),
                stateIcon != null && stateTick
                    ? Positioned(
                  bottom: 0,
                  right: 0,
                  child: stateIcon,
                )
                    : const SizedBox(
                  width: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}








class SpecialChatBubbleThree extends CustomPainter {
  final Color color;
  final Alignment alignment;
  final bool tail;
  final Color borderColor;
  final double borderWidth;

  SpecialChatBubbleThree({
    required this.color,
    required this.alignment,
    required this.tail,
    required this.borderColor,
    required this.borderWidth,
  });

  final double _radius = 8.0;

  @override
  void paint(Canvas canvas, Size size) {
    var h = size.height;
    var w = size.width;
    var path = Path();

    if (alignment == Alignment.topRight) {
      if (tail) {
        path.moveTo(_radius * 2, 0);
        path.quadraticBezierTo(0, 0, 0, _radius * 1.5);
        path.lineTo(0, h - _radius * 1.5);
        path.quadraticBezierTo(0, h, _radius * 2, h);
        path.lineTo(w - _radius * 3, h);
        path.quadraticBezierTo(
            w - _radius * 1.5, h, w - _radius * 1.5, h - _radius * 0.6);
        path.quadraticBezierTo(w - _radius * 1, h, w, h);
        path.quadraticBezierTo(
            w - _radius * 0.8, h, w - _radius, h - _radius * 1.5);
        path.lineTo(w - _radius, _radius * 1.5);
        path.quadraticBezierTo(w - _radius, 0, w - _radius * 3, 0);
        path.close(); // Ensure the path is closed to draw the border correctly
      } else {
        path.moveTo(_radius * 2, 0);
        path.quadraticBezierTo(0, 0, 0, _radius * 1.5);
        path.lineTo(0, h - _radius * 1.5);
        path.quadraticBezierTo(0, h, _radius * 2, h);
        path.lineTo(w - _radius * 3, h);
        path.quadraticBezierTo(w - _radius, h, w - _radius, h - _radius * 1.5);
        path.lineTo(w - _radius, _radius * 1.5);
        path.quadraticBezierTo(w - _radius, 0, w - _radius * 3, 0);
        path.close(); // Ensure the path is closed to draw the border correctly
      }
    } else {
      if (tail) {
        path.moveTo(_radius * 3, 0);
        path.quadraticBezierTo(_radius, 0, _radius, _radius * 1.5);
        path.lineTo(_radius, h - _radius * 1.5);
        path.quadraticBezierTo(_radius * .8, h, 0, h);
        path.quadraticBezierTo(
            _radius * 1, h, _radius * 1.5, h - _radius * 0.6);
        path.quadraticBezierTo(_radius * 1.5, h, _radius * 3, h);
        path.lineTo(w - _radius * 2, h);
        path.quadraticBezierTo(w, h, w, h - _radius * 1.5);
        path.lineTo(w, _radius * 1.5);
        path.quadraticBezierTo(w, 0, w - _radius * 2, 0);
        path.close(); // Ensure the path is closed to draw the border correctly
      } else {
        path.moveTo(_radius * 3, 0);
        path.quadraticBezierTo(_radius, 0, _radius, _radius * 1.5);
        path.lineTo(_radius, h - _radius * 1.5);
        path.quadraticBezierTo(_radius, h, _radius * 3, h);
        path.lineTo(w - _radius * 2, h);
        path.quadraticBezierTo(w, h, w, h - _radius * 1.5);
        path.lineTo(w, _radius * 1.5);
        path.quadraticBezierTo(w, 0, w - _radius * 2, 0);
        path.close(); // Ensure the path is closed to draw the border correctly
      }
    }


    canvas.drawShadow(path, Colors.grey, 1, false);

    canvas.clipPath(path);


    canvas.drawRRect(
        RRect.fromLTRBR(0, 0, w, h, Radius.zero),
        Paint()
          ..color = color
          ..style = PaintingStyle.fill);

    canvas.drawPath(
        path,
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth
    );

    // canvas.drawPath(path, Paint()..color = Colors.pink);

    // canvas.restore();

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
