
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

extension WidgetExtensions on Widget {
  Widget padding(EdgeInsets edgeInsets) => Padding(
    padding: edgeInsets,
    child: this,
  );

  Widget loadingView(bool isLoading) {
    return Stack(
      children: [
        this,
        isLoading ?
        Container(
          color: Colors.black.withOpacity(.4),
          child: Center(
            child: Lottie.asset(
              height: 150,
              'assets/animation/loading.json',
            ),
          ),
        ) : const SizedBox.shrink(),
      ],
    );
  }

}