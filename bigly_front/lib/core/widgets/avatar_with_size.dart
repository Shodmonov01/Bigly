
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AvatarWithSize extends StatelessWidget {
  const AvatarWithSize({super.key,
    this.image,
    this.height,
    this.width,
    this.borderWidth,
    this.borderColor,
    this.onTap, this.radius,
    this.child,
    this.backgroundColor,
    this.fileImage,
  });

  final String? image;
  final double? height;
  final double? width;
  final double? radius;

  final double? borderWidth;
  final Color? borderColor;

  final void Function()? onTap;
  final Widget? child;
  final Color? backgroundColor;
  final File? fileImage;

  @override
  Widget build(BuildContext context) {

    if (radius != null && (height != null || width != null)) {
      throw Exception('If you use radius you cannot use height and width');
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: ((borderWidth != null) || (borderColor != null)) ?
          Border.all(
            color: borderColor ?? Colors.white,
            width: borderWidth ?? 1,
          ) : null,
        ),

        child:
        (fileImage != null) ?
        CircleAvatar(
          radius: radius,
          backgroundImage: FileImage(fileImage!),
        ) :
        (child != null) ? child :
        (image == null) ?
        CircleAvatar(
          radius: radius,
          child: const Icon(Icons.person, color: Colors.grey,),
        ) :
        (image!.isEmpty) ?
        CircleAvatar(
          radius: radius,
          child: const Icon(Icons.person, color: Colors.grey,),
        ):
        (image!.contains('http')) ?
        CircleAvatar(
          radius: radius,
          backgroundImage: CachedNetworkImageProvider(image!),
        ) :
        CircleAvatar(
          radius: radius,
          backgroundImage: AssetImage(image!),
        ),

      ),
    );
  }
}
