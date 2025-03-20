
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black.withOpacity(.4),
        child: Center(
          child: Lottie.asset(
            height: 150,
            'assets/animation/loading.json',
          ),
        ),
      ),
    );
  }
}
