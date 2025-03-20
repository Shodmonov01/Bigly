
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> confirmDialog(BuildContext context,  {
  required String title, required String content,
  String yes = 'Yes',
  String no = 'No',
  Color? yesColor = Colors.red,
  Color? noColor = Colors.green,
}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog.adaptive(
        title: Text(title),
        content: Text(content),
        actions: [

          /// yes
          if (Platform.isIOS)
          CupertinoDialogAction(
            onPressed: (){
              Navigator.pop(context, true);
            },
            textStyle: TextStyle(color: yesColor),
            child: Text(yes),
          ) else TextButton(
            onPressed: (){
              Navigator.pop(context, true);
            },
            child: Text(yes, style: TextStyle(color: yesColor),),
          ),



          /// no
          if (Platform.isIOS)
          CupertinoDialogAction(
            onPressed: (){
              Navigator.pop(context, null);
            },
            textStyle: TextStyle(color: noColor),
            child: Text(no),
          ) else TextButton(
            onPressed: (){
              Navigator.pop(context, null);
            },
            child: Text(no, style: TextStyle(color: noColor),),
          ),

        ],
      );
    },
  );
}