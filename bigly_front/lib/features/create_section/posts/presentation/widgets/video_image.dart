
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/data/models/content_model.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/features/create_section/posts/presentation/widgets/content_view.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../team/chat/presentation/pages/watch_video_page.dart';
import '../../view_model/posts_view_model.dart';

class VideoImageItem extends StatelessWidget {
  const VideoImageItem({super.key, required this.videoModel,});
  // final String videoModel;
  // final double aspectRatio;
  final ContentModel videoModel;

  @override
  Widget build(BuildContext context) {
    print(videoModel.thumbnail);
    return Padding(
      padding: const EdgeInsets.all(2),
      // width: 250,
      // height: double.infinity,
      // width: double.infinity,
      child:
      // _isLoading ?
      // const Center(child: CircularProgressIndicator()) :
      CachedNetworkImage(
        imageUrl: videoModel.thumbnail ?? '',
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => AspectRatio(
          aspectRatio: videoModel.media_aspect_ratio ?? 1,
          child: const Center(child: CircularProgressIndicator()),
          // child: const Center(child: const Icon(Icons.abc)),
          // child: Lottie.asset('assets/animation/loading.json'),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        // cacheKey: videoModel.thumbnail, // Optional
        maxHeightDiskCache: 1000, // Optional: Maximum size of disk cache in MB
        maxWidthDiskCache: 1000,
      ),
      // Image.file(
      //   File(_thumbnailPath ?? ''),
      //   fit: BoxFit.cover,
      // ),
      // transformAlignment: Alignment.bottomCenter,
      // margin: EdgeInsets.only(bottom: 5, left: 10),
      // child: OpenContainer(
      //   // closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //   // clipBehavior: Clip.hardEdge,
      //   closedBuilder: (context, action) {
      //     return _isLoading ?
      //     const Center(child: CircularProgressIndicator()) :
      //     (_thumbnailPath != null ?
      //     Stack(
      //       alignment: Alignment.center,
      //       children: [
      //         Image.file(
      //           File(_thumbnailPath!),
      //           fit: BoxFit.cover,
      //         ),
      //         // const Icon(
      //         //   Icons.play_circle_outline,
      //         //   color: Colors.orange,
      //         //   size: 50,
      //         // ),
      //         // const Icon(
      //         //   Icons.play_circle_fill,
      //         //   color: Colors.white,
      //         //   size: 50,
      //         // ),
      //       ],
      //     ) :
      //     const Center(child: Text('Failed to load thumbnail')));
      //   },
      //   openBuilder: (context, action) {
      //     return const SizedBox.shrink();
      //     // context.read<PostsViewModel>().isPlayVideo = true;
      //     // VideoPlayerController controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoModel))
      //     //   ..initialize().then((_) {});
      //     // controller.play();
      //     // return videoView(context, controller);
      //   },
      // ),
    );
  }
}


