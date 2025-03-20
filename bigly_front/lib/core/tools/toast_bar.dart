
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:overlay_support/overlay_support.dart';

showToast(String msg, Color color, {int? duration, int? gravity}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[200],
      textColor: Colors.black,
      fontSize: 16.0
  );
}