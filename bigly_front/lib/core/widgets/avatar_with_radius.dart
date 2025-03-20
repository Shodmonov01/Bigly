
import 'package:flutter/material.dart';

class AvatarWithRadius extends StatelessWidget {
  const AvatarWithRadius({super.key,
     required this.image,
     required this.radius,
  });

  final String image;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      foregroundImage: AssetImage(image),
    );
  }
}
