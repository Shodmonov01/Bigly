
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/features/create_section/new_insight/view_model/new_insight_view_model.dart';

class VideoItem extends StatelessWidget {
  const VideoItem({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {

    final read = context.read<NewInsightViewModel>();
    final watch = context.watch<NewInsightViewModel>();

    /// Video
    var video = read.videosFromAsset[index];

    /// Minute
    Widget videoDuration = Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          read.printDuration(video.videoDuration,),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

    /// Image
    final Widget image = AssetEntityImage(
      video,
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      thumbnailFormat: ThumbnailFormat.jpeg, // Defaults to `jpeg`.
    );

    return GestureDetector(
      onTap: () {
        read.onTapVideoItem(index);
      },
      child: Stack(
        children: [
          image,
          videoDuration,
          if (watch.selectedCheck[index])
          Container(
            color: Colors.grey.withOpacity(.5) ,
          ),
        ],
      ),
    );
  }
}
