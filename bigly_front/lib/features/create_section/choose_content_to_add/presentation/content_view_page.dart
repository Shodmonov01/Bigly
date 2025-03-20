
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/data/models/content_model.dart';

class ContentViewPage extends StatefulWidget {
  const ContentViewPage({super.key, required this.contentModel});

  final ContentModel contentModel;

  @override
  State<ContentViewPage> createState() => _ContentViewPageState();
}

class _ContentViewPageState extends State<ContentViewPage> {

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }

  VideoPlayerController? videoPlayerController;
  void initData() {
    ContentModel contentModel = widget.contentModel;
    print(contentModel.contentMediaType);
    print(contentModel.media);
    if (contentModel.media_type != null) {
      // if (contentModel.contentMediaType!.isVideo) {
        print('video');
        videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(contentModel.media!),
        )..initialize().then((value) {
          setState(() {
            setState(() {
              videoPlayerController?.setLooping(true);
              videoPlayerController?.play();
            });
          });
        },);
      }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: (){
              initData();
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body:
      (videoPlayerController != null) ?
      AspectRatio(
        aspectRatio: videoPlayerController!.value.aspectRatio,
        child: VideoPlayer(videoPlayerController!),
      ) : Center(child: Text('asdas')),
    );
  }
}
