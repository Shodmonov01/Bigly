
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension ContextExtension on BuildContext {

  ThemeData get theme => Theme.of(this);

  double get height => MediaQuery.sizeOf(this).height;
  double get width => MediaQuery.sizeOf(this).width;

  // Widget get statusBarHeightGap => Gap(MediaQuery.of(this).padding.top);
  // Widget get bottomHeightGap => Gap(MediaQuery.of(this).padding.bottom);

  double get statusBarHeight => MediaQuery.of(this).padding.top;
  double get bottomHeight => MediaQuery.of(this).padding.bottom;

  bool get isKeyboardOpen => MediaQuery.of(this).viewInsets.bottom != 0;

  void get unFocus => FocusManager.instance.primaryFocus!.unfocus();


  void showSnackBar(String msg) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(msg))
    );
  }

  void get vibrateLight => HapticFeedback.heavyImpact();

}