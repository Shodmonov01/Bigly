
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../data/models/content_model.dart';

class ProfileContentItem extends StatelessWidget {
  const ProfileContentItem({super.key,
    this.onTap,
    this.image,
    this.actionButton,
  });

  final void Function()? onTap;
  final String? image;
  final Widget? actionButton;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        margin: const EdgeInsets.all(10),
        decoration:
        (image == null) ? null :
        (image!.isEmpty) ? null :
        BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: (image!.contains('http')) ?
          DecorationImage(
            image: CachedNetworkImageProvider(image!),
            fit: BoxFit.cover,
          ) :
          DecorationImage(
            image: AssetImage(image!),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.topRight,
          child: actionButton,
          // child: GestureDetector(
          //   onTap: (){
          //
          //   },
          //   child: const Icon(
          //     Icons.close,
          //     size: 18,
          //     color: Colors.grey,
          //   ),
          // ),
        ),
      ),
    );
  }
}
