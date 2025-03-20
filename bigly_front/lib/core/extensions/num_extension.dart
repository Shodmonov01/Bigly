
import 'package:flutter/material.dart';

extension NumExtension on num {
  Widget get hGap => SizedBox(height: this / 1);
  Widget get wGap => SizedBox(width: this / 1);

  double hp(BuildContext context) => MediaQuery.sizeOf(context).height * this;
  double wp(BuildContext context) => MediaQuery.sizeOf(context).width * this;
}
