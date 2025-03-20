
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/router/router.dart';

class OpenCameraItem extends StatelessWidget {
  const OpenCameraItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.push(RouteNames.videoRecord);
      },
      child: const ColoredBox(
        color: Colors.grey,
        child: Icon(
          Icons.camera_alt_outlined,
          size: 36,
        ),
      ),
    );
  }
}
