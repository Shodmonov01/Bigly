import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBarBackButton extends StatelessWidget {
  final Color iconColor;
  const AppBarBackButton({super.key, this.iconColor=Colors.black});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed:() => context.pop(context),
      icon: Icon(CupertinoIcons.back,color: iconColor,),
    );
  }
}
