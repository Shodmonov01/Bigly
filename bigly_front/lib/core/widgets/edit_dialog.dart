
import 'package:flutter/material.dart';

showEditDialog(context, Widget child) async {
  return showGeneralDialog(
    context: context,
    transitionDuration: const Duration(milliseconds: 300),
    barrierDismissible: true,
    barrierColor: Colors.transparent,
    pageBuilder: (context, animation, secondaryAnimation) {
      return child;
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
      return SlideTransition(
        position: tween.animate(
          CurvedAnimation(parent: anim, curve: Curves.easeInOutExpo),
        ),
        child: child,
      );
    },
  );
}
