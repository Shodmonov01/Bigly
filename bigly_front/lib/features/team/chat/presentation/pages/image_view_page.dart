
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageViewPage extends StatefulWidget {
  const ImageViewPage({super.key, required this.url});

  final String url;

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CachedNetworkImage(
          imageUrl: widget.url,
        ),
      ),
    );
  }
}
