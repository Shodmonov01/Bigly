import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/constants/app_paths.dart';
import 'package:social_media_app/core/data/models/message_model.dart';

import '../pages/watch_video_page.dart';

import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';



class VideoImageItem extends StatefulWidget {
  const VideoImageItem({super.key, required this.messageModel, required this.aspectRatio});
  final MessageModel messageModel;
  final double aspectRatio;

  @override
  _VideoImageItemState createState() => _VideoImageItemState();
}

class _VideoImageItemState extends State<VideoImageItem> {
  // String? _thumbnailPath;
  // bool _isLoading = true;

  // @override
  // void initState() {
  //   super.initState();
  //   _generateThumbnail();
  // }

  // Future<void> _generateThumbnail() async {
  //   try {
  //     // final Directory tempDir = await getTemporaryDirectory();
  //     final String tempPath = await AppPaths.cacheFolder;
  //     String? thumbnailPath = await VideoThumbnail.thumbnailFile(
  //       video: widget.videoUrl,
  //       thumbnailPath: tempPath,
  //       imageFormat: ImageFormat.JPEG,
  //       // maxHeight: 350,
  //       // quality: 75,
  //     );
  //
  //     if (thumbnailPath != null) {
  //       // int lastSlashIndex = thumbnailPath.lastIndexOf('/');
  //       // String pathWithoutFileName = thumbnailPath.substring(0, lastSlashIndex + 1);
  //
  //       // print(pathWithoutFileName);
  //       // String imageName = thumbnailPath.split('/').last;
  //       // imageName = imageName.replaceAll(RegExp(r'\s+'), 'a');
  //       // print('BANNER');
  //       // print(imageName);
  //       setState(() {
  //         _thumbnailPath = thumbnailPath;
  //         _isLoading = false;
  //       });
  //     } else {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       print('Thumbnail path is null');
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     print('Error generating thumbnail: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      // width: 250,
      // height: 350,
      // transformAlignment: Alignment.bottomCenter,
      // margin: EdgeInsets.only(bottom: 5, left: 10),
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: OpenContainer(
          closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.hardEdge,
          closedBuilder: (context, action) {
            return
              // _isLoading ?
            // const Center(child: CircularProgressIndicator()) :
            // (_thumbnailPath != null ?
            Stack(
              alignment: Alignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.messageModel.thumbnail!,
                  fit: BoxFit.cover,
                  maxHeightDiskCache: 1000,
                  maxWidthDiskCache: 1000,
                ),
                const Icon(
                  Icons.play_circle_outline,
                  color: Colors.orange,
                  size: 50,
                ),
                const Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 50,
                ),
              ],
            );
            // const Center(child: Text('Failed to load thumbnail')));
          },
          openBuilder: (context, action) {
            return WatchVideoPage(chatVideoModel: widget.messageModel.media!);
          },
        ),
      ),
    );
  }
}



/*class VideoImageItem extends StatelessWidget {
  final ChatVideoModel videoModel;
  const VideoImageItem({super.key, required this.videoModel});

  @override
  Widget build(BuildContext context) {
    final chatViewModel = context.watch<ChatViewModel>();
    final controller = chatViewModel.controller;

    double progress = 0.0;
    if (controller != null && controller.value.isInitialized) {
      progress = (controller.value.position.inSeconds / controller.value.duration.inSeconds) * 100;
    }


    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 250,
        height: 350,
        transformAlignment: Alignment.bottomCenter,
        margin: EdgeInsets.only(bottom: 5, left: 10),
        child: OpenContainer(
          closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          clipBehavior: Clip.hardEdge,
          closedBuilder: (context, action) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 2, color: Colors.grey),
                  ),
                  child: controller != null && controller.value.isInitialized
                      ?
                  VideoProgressIndicator(
                    controller,

                    allowScrubbing: false,
                    colors: VideoProgressColors(
                      playedColor: Colors.blue,
                      backgroundColor: Colors.grey,
                      bufferedColor: Colors.lightBlue,
                    ),
                    padding: EdgeInsets.all(5),
                  )

                      : Container(),
                ),
                Center(
                  child: Text(
                    "${progress.toStringAsFixed(0)}%",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.black54,
                    ),
                  ),
                ),
              ],
            );
          },
          openBuilder: (context, action) {
            return WatchVideoPage(chatVideoModel: videoModel);
          },
        ),
      ),
    );
  }
}*/

