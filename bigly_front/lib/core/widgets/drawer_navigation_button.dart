import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/my_theme.dart';

class DrawerNavigationButton extends StatelessWidget {
  final Icon icon;
  final String title;
  final  bool titleIsGrey;
  final void Function() onTap;
  final Widget? trailing;

  DrawerNavigationButton({super.key, required this.icon, required this.title,required this.onTap, this.trailing, required this.titleIsGrey});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      minTileHeight: 45,
      contentPadding: EdgeInsets.symmetric(horizontal: 30),
      leading: icon,
      trailing: trailing,
      title: Text(title,style: titleIsGrey?MyTheme.largeBoldGreyText : TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),),
    );
  }
}
